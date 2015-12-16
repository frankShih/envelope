function anomalyDetect(train_data, test_data, best_std, tLabel, tp_rate)
% train_data: data set with first column as label (for building envelope)
% tesr_data: for evaluation
% best_std: using 'stdTuning' to find it (or entropy_std)
% tLabel: target label to build envelope
% tp_rate: use it to get threshold
% 
% [door] 
%     0 - [1.7, 2.2, 2.1, 2.7]
%     1 - [1.7, 1.6, 2, 2.5]
%     2 - [1.7, 2.4, 2.5, 2.7]
%     3 - [1.8, 2.1, 2.5, 2.6]
% [ECG200TRAIN]
%   -1 - [1.5, 2.5, 1.1, 2.3]
%    1 - [1.5, 1.8, 1.7, 1.7]
% [ECGFiveDays]
%   1 - [2.6, 0.7, 0.7, 3]
%   2 - [2.5, 1.3, 1.5, 2.5]
% [CincECG]
%   1 - [1.5, 2.2, 2.7, 3.4]
%   2 - [1.4, 1.4, 3, 3.5]
%   3 - [2.3, 2.9, 3, 3.5]
%   4 - [2, 2.3, 3, 2.5]
% 
    
    %{
    label = unique(data(:,1));
    meanAUC=zeros(length(label),1);
    % transform to different data type
    data_d = dataTransform(data);
    data_i = dataTransform(data,0 );
    data_ii = dataTransform(data_i,0 );
    dataCell = {data_ii, data_i, data, data_d};
    scoreList = [];

    for i=1:length(dataCell)
        suspiciousScore = 0;
        for j=1:10
            t_test = [];        t_train = [];
            temp = dataCell{i}(data(:,1)==label(i),:);
            ind = randsample(size(temp,1), fix(size(temp,1)/2));
            ind_1 = 1:size(temp,1);
            ind_1(ind)=[];
            t_test = [t_test; temp(ind,:)];          
            t_train = [t_train; temp(ind_1,:)];    


            [score, true_label] = anomalyScore(t_train, t_test, tLabel, best_std(i), 5, 1);
            suspiciousScore = suspiciousScore + score*;
            [score, true_label] = anomalyScore(t_train, t_test, tLabel, best_std(i), 5, 2);
            suspiciousScore = suspiciousScore + score;

        end    
        scoreList = [scoreList suspiciousScore/10];

    end

    [X,Y,~,AUC] = perfcurve(auc_label, 1./(scores+1), tLabel);        
    %}
    
    [score, ~] = anomalyScore(train_data, tLabel, best_std, 5, 1);
    avg_records=zeros(length(score),3);
%     f_score = @(TP,FN,FP) 2*TP/(2*TP+FN+FP);
    for j=1:10
        [score, true_label] = anomalyScore(train_data, tLabel, best_std, 5, 1);
        pos = sum(true_label==1);
        neg = sum(true_label==0);
        records = [];       
        [score, ind]= sort(score,'descend');
        true_label = true_label(ind);
        
        for i=1:length(score)
            guess = [ones(1,i) zeros(1, length(score)-i)];
            
            TP = sum( guess(1:i)' & true_label(1:i) & (true_label(1:i)==1));
    %         TN = sum( not(guess(1:i)' & true_label(1:i)) & (true_label(1:i)==0));
            FP = sum( guess(1:i)' & not(true_label(1:i)) & (true_label(1:i)==0));
    %         FN = sum( not(guess(1:i)' & not(true_label(1:i))) & (true_label(1:i)==1));
    %         [TP FP TN FN]
            TPR = TP./pos;
            FPR = FP./neg;
            records = [records; score(i) TPR FPR ];
        end
        avg_records = avg_records + records;
    end
    avg_records = avg_records./10;
    threshold = [avg_records(:,2); tp_rate];
    threshold = sort(threshold, 'ascend');
    
    
    
    figure   
    hold on 
    
    plot(avg_records(:,3), avg_records(:,2), 'r', 'LineWidth', 2);
    ind = avg_records(threshold==tp_rate,3);
    plot(repmat(ind(1), 1, 2),[0,1], 'b', 'LineWidth', 2);
%     plot( records(:,4), 'g', 'LineWidth', 2);
%     legend('TPR','FPR');
    xlabel('FPR');
    ylabel(' TPR' );
    title(['ROC curve - ' 'target label: ' num2str(tLabel) ' best std: ' num2str(best_std)]); 
    threshold = find(threshold==tp_rate);
    threshold = (avg_records(threshold(1),1)+avg_records(threshold(1)+1,1))/2;
    disp(num2str(threshold));
    prediction = zeros(1,size(test_data,1));
    %{
    distance = pdist(train_data(:,2:end));
    for i=1:size(test_data,1)
        
        temp = zeros(1,size(train_data,1));
        for j=1:size(train_data,1)
            temp(j) = sqrt(sum((test_data(i,2:end) - train_data(j,2:end)) .^ 2));
        end
        distMrx = squareform([distance temp]);
    %}
    for i = 1:size(test_data,1)
        distMrx = squareform((pdist([train_data(:,2:end); test_data(i,2:end)])));
        suspiciousScore = SKNN(5,distMrx);         
%         suspiciousScore(end)
        if suspiciousScore(end) >threshold
            prediction(i) = 1;
        end
    end
    test_label = test_data(:,1);
    test_label(test_label ~=tLabel) = 1;
    test_label(test_label ==tLabel) = 0;
    TP = sum(prediction' & test_label & test_label==1);
    FP = sum(prediction' & not(test_label) & test_label==0);
    disp(['TP: ' num2str(TP) ' FP: ' num2str(FP)])
end