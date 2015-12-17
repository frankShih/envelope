%
function stdAUC_by_entropy(data, tLabel, K,data_name)
% ================================================
% input
%   data: a matrix with first column as label
%   tLabel: target label for envelope extraction
%   K for KNN
% ===============================================
    result_path='C:\Users\dmlab\Dropbox\DMLAB\CompressSensing\result\data_number\';
    csv_AUC_path=[result_path 'AUC_',data_name,'_t',num2str(tLabel),'.csv'];
    csv_entropy_path=[result_path 'entropy_',data_name,'_t',num2str(tLabel),'.csv'];
    
    label = unique(data(:,1));   
    auc_result = [];    
    %--------build original data set---------    
    origin = cell(length(label), 1);    
    for j=1:length(label)           
        origin{j} = data(data(:,1)==label(j),2:end);
    end

    std_area=[.1:.1:4.5];
    all_entropy=[];
    for n=std_area
        n
        AUCavg = 0;
        for i=1:100       
            %------------------random sample anomaly data & calculate AUC ------------------------
            dataSet = [];           auc_label = [];                           
            %------------------------- original domain---------------------
            for j=1:length(label)
                if label(j)==tLabel                
                    dataSet = [dataSet; origin{j} ];            
                    auc_label = [auc_label; zeros(size(origin{j},1),1)];               
                else                
                    sample_ind = randsample(size(origin{j},1), ceil(size(origin{j},1)/10/(length(label)-1)));
                    dataSet = [dataSet; origin{j}(sample_ind,:) ];
                    auc_label = [auc_label;  ones(ceil(size(origin{j},1)/10/(length(label)-1)), 1)];                
                end
            end   

            distMrx = squareform(pdist(dataSet));
            scores = SKNN(K,distMrx);   
            [X,Y,~,AUC] = perfcurve(auc_label, scores, 1);        
            AUCavg = AUCavg+AUC;
            
        end
        
        [m, s] = envelopeBuild(data(:,2:end),data(:,1));

        coded_alldata = cell(length(label), 1);
        entropy_by_label = zeros(length(label), 1);
        for j=1:length(label)
            coded_alldata{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), n);
            data_num_each_label=size(coded_alldata{j},1);
            for k=1:data_num_each_label
                temp=coded_alldata{j}(k,:);
                n_1 = sum(temp==1);
                n_0 = sum(temp==0);
                n_neg1 = sum(temp==-1);
                total = n_1+n_0+n_neg1;
                p = [n_1, n_0, n_neg1]./total;
                p(p==0) = [];
                entropy_by_label(j)=entropy_by_label(j)-sum(p.*log2(p));
            end
            entropy_by_label(j)=entropy_by_label(j)/data_num_each_label;
        end
        all_entropy=[all_entropy,entropy_by_label];
              
    %-------------------------envelope & compress domain-----------------------        
        AUCavg_e=0;     AUCavg_c=0;     nzero_t = 0;    nzero_o = 0;
        for i=1:100
            dataSet_e = [];     dataSet_c = [];           
            auc_label_e = [];         
                        
            %---------build envelope coded data --------
            % only use part of target label to build model    
            t_test = [];        t_train = [];
            for j=1:length(label)
                temp = data(data(:,1)==label(j),:);
                ind = randsample(size(temp,1), ceil(size(temp,1)/2));
                ind_1 = 1:size(temp,1);
                ind_1(ind)=[];
                t_test = [t_test; temp(ind,:)];          
                t_train = [t_train; temp(ind_1,:)];    
            end

            [m, s] = envelopeBuild(t_train(:,2:end),t_train(:,1));
            %     [up, low] = envelopeMD(t_train(:,2:end), t_train(:,1), n_std);

            coded = cell(length(label), 1);        
            for j=1:length(label)
                coded{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), t_test(t_test(:,1)==label(j),2:end), n); 
            %         coded{j} = envelopeMDCoding(up(label==tLabel,:), low(label==tLabel,:), data(data(:,1)==label(j),2:end));            
            end
            
            %---------build compressed data --------
            A = sqrt (size(coded{1},1) ) *randn( size(coded{1},1) , size(coded{1},2));  
            A_sub = A(randsample(size(A,1), ceil(size(A,1)/2)),:);            
            compressed = cell(length(label), 1);
            for j=1:length(label)
                compressed{j} = (A_sub * coded{j}')';
            end

            for j=1:length(label)
                if label(j)==tLabel
                    dataSet_e = [dataSet_e; coded{j} ];
                    dataSet_c = [dataSet_c; compressed{j} ];
                    auc_label_e = [auc_label_e; zeros(size(compressed{j},1),1)];
                else
                    dataSet_e = [dataSet_e; coded{j}(randsample(size(coded{j},1),ceil(size(coded{j},1)/10/(length(label)-1))),:) ];
                    dataSet_c = [dataSet_c; compressed{j}(randsample(size(compressed{j},1),ceil(size(compressed{j},1)/10/(length(label)-1))),:) ];
                    auc_label_e = [auc_label_e;  ones(ceil(size(compressed{j},1)/10/(length(label)-1)),1)];
                end
            end
            nzero_t = nzero_t+ mean(sum(dataSet_e(auc_label_e==0,:)~=0,2))/size(data,2);
            nzero_o = nzero_o+ mean(sum(dataSet_e(auc_label_e==1,:)~=0,2))/size(data,2);
            distMrx = squareform(pdist(dataSet_e));
            scores = SKNN(K,distMrx);
           
            [X,Y,~,AUC] = perfcurve(auc_label_e, scores, 1);           
            AUCavg_e = AUCavg_e+AUC;
%             figure
%             plot(X,Y);
            
            distMrx = squareform(pdist(dataSet_c));
            scores = SKNN(K,distMrx);                        
            [X,Y,~,AUC] = perfcurve(auc_label_e, scores, 1);           
            AUCavg_c = AUCavg_c+AUC;
%             figure
%             plot(X,Y);
            
        end
        auc_result = [auc_result; AUCavg_e/100  AUCavg_c/100 nzero_t/100 nzero_o/100];
    end
    
    % select entropy
    Lambda_list=[1,2,3];
    lambda_result=[];
    for Lambda_index=1:length(Lambda_list)
        object_value=[];
        Lambda=Lambda_list(Lambda_index);
        for i=1:size(all_entropy,2)
            target_std_entropy=all_entropy(:,i);
            [sort_value sort_index]=sort(target_std_entropy);
            low_1=target_std_entropy(sort_index(1));
            low_2=target_std_entropy(sort_index(2));
            object_value=[object_value,low_1-Lambda*(low_2-low_1)];
%             object_value=[object_value,-(low_2-low_1)];
        end
        [sort_obj_value sort_obj_index]=sort(object_value);
        best_std=std_area(sort_obj_index(1));
        lambda_result=[lambda_result;object_value];
        
        % get best sparse data to file
        [m, s] = envelopeBuild(data(:,2:end),data(:,1));
        coded_alldata = [];
        coded_label=[];
        for j=1:length(label)
            encode_data=envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), best_std);
            coded_alldata = [coded_alldata;encode_data];
            coded_label=[coded_label;ones(size(encode_data,1),1)*label(j)];
        end
        coded_data_path=[result_path 'coded\' data_name '_e' num2str(tLabel) '_lambda' num2str(Lambda) '.csv'];
        csvwrite(coded_data_path,[coded_label,coded_alldata]);
        
        % plot figure
        auc_fig=figure;
        ylim([0 1]);
        xlim([min(std_area) max(std_area)]);
        hold on 
        plot(std_area, repmat(AUCavg/100,[length(std_area), 1]), 'b', 'LineWidth', 2);
        plot(std_area, auc_result(:,1), 'g', 'LineWidth', 2);
        plot(std_area, auc_result(:,2), 'r', 'LineWidth', 2);
        yl=get(gca,'YLim');
        plot([best_std,best_std],yl,'k','LineWidth', 1);
        legend('original','envelope','compressed','best std');
        xlabel('num of std. ');
        ylabel('AUC score' );
        title(['target label: ' num2str(tLabel) ' K: ' num2str(K) ' best std: ' num2str(best_std) ' Lambda: ' num2str(Lambda)]); 
        hold off
        
        compress_ratio_fig=figure;
        ylim([0 1]);
        xlim([min(std_area) max(std_area)]);
        hold on 
        plot(std_area, auc_result(:,3), 'c', 'LineWidth', 2);
        plot(std_area, auc_result(:,4), 'm', 'LineWidth', 2);
        yl=get(gca,'YLim');
        plot([best_std,best_std],yl,'k','LineWidth', 1);
        legend('nonzero ratio(target)', 'nonzero ratio(other)' ,'best std');
        xlabel('num of std. ');
        ylabel('nonzero ratio' );
        title(['target label: ' num2str(tLabel) ' K: ' num2str(K) ' best std: ' num2str(best_std) ' Lambda: ' num2str(Lambda)]); 
        hold off

        entropy_fig=figure;
        xlim([min(std_area) max(std_area)]);
        hold on
        color_list=['g','r','m','c'];
        legend_cell={};
        for label_ind=1:length(label)
            plot(std_area, all_entropy(label_ind,:), color_list(label_ind), 'LineWidth', 2);
            legend_cell{label_ind}=['label ' num2str(label(label_ind))];
        end
        legend_cell{length(legend_cell)+1}='best std';
        yl=get(gca,'YLim');
        plot([best_std,best_std],yl,'k','LineWidth', 1);
%         legend('label 0','label 1','label 2','label 3' ,'best std');
        legend(legend_cell);
        xlabel('num of std. ');
        ylabel('entropy' );
        title({['Entropy'];['Lambda: ' num2str(Lambda) ' best std: ' num2str(best_std) ]},'FontSize',18); 
        hold off
        
        auc_fig_path=[result_path 'figure\AUC_' data_name '_e' num2str(tLabel)  '_Lambda' num2str(Lambda)];
        print(auc_fig,auc_fig_path,'-dpng');
        entropy_fig_path=[result_path 'figure\entropy_' data_name '_e' num2str(tLabel)  '_Lambda' num2str(Lambda)];
        print(entropy_fig,entropy_fig_path,'-dpng');
        compress_ratio_fig_path=[result_path 'figure\compress_' data_name '_e' num2str(tLabel)  '_Lambda' num2str(Lambda)];
        print(compress_ratio_fig,compress_ratio_fig_path,'-dpng');
    end
        
    % write data to file
    auc_data2file=[auc_result';repmat(AUCavg/100,1,length(std_area))];
    csvwrite(csv_AUC_path,auc_data2file);
    
    entropy_data2file=[all_entropy;lambda_result];
    csvwrite(csv_entropy_path,entropy_data2file); 
end
%}

