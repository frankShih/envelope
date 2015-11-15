function [suspiciousScore, true_label] = anomalyScore(data, tLabel, n_std, K, mode)
% ================================================
%   data: building envelope 
%   tLabel: target label for envelope establishment
%   n_std: # of standard deviation to create upper/lower bound (fine-tuned)
%   K for KNN
%  mode: different experimental settings 
% ===============================================

    label = unique(data(:,1));
     
    
    if mode==0                  %-----------original data-------------        
        temp = cell(length(label), 1);    
        for j=1:length(label)           
        temp{j} = data(data(:,1)==label(j),2:end);
        end              
        
    elseif mode==1          %-----------envelope 0/1/-1-----------        
         [m, s] = envelopeBuild(data(:,2:end),data(:,1));
        %     [up, low] = envelopeMD(train(:,2:end), train(:,1), n_std);

        temp = cell(length(label), 1);        
        for j=1:length(label)
            temp{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), n_std); 
        %         temp{j} = envelopeMDCoding(up(label==tLabel,:), low(label==tLabel,:), data(data(:,1)==label(j),2:end));            
        end                                
        
    elseif mode==2          %-----------envelope count ------------
       [m, s] = envelopeBuild(data(:,2:end),data(:,1));
        %     [up, low] = envelopeMD(train(:,2:end), train(:,1), n_std);

        temp = cell(length(label), 1);        
        for j=1:length(label)
            temp{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), n_std); 
        %         temp{j} = envelopeMDCoding(up(label==tLabel,:), low(label==tLabel,:), data(data(:,1)==label(j),2:end)); 
            [~,~,idx] = unique(temp{j});
             temp{j} = accumarray(idx(:),1,[],@sum);
        end                                
    
    elseif mode==3          %-----------entropy count_envelope ------------
       [m, s] = envelopeBuild(data(:,2:end),data(:,1));
        %     [up, low] = envelopeMD(train(:,2:end), train(:,1), n_std);

        temp = cell(length(label), 1);        
        for j=1:length(label)
            temp{j} = [];
            tem = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), n_std); 
        %         temp{j} = envelopeMDCoding(up(label==tLabel,:), low(label==tLabel,:), data(data(:,1)==label(j),2:end)); 
            for k=1:size(tem,1)
                temp{j} = [temp{j} entropy(tem(k,:))];
            end
        end            
        
    else                                %---------build compressed data --------
        [m, s] = envelopeBuild(data(:,2:end),data(:,1));
        %     [up, low] = envelopeMD(train(:,2:end), train(:,1), n_std);

        temp1 = cell(length(label), 1);        
        for j=1:length(label)
            temp1{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), n_std); 
        %         temp1{j} = envelopeMDCoding(up(label==tLabel,:), low(label==tLabel,:), data(data(:,1)==label(j),2:end));            
        end
        
        A = sqrt (size(temp1{1},1) ) *randn( size(temp1{1},1) , size(temp1{1},2));  
        A_sub = A(randsample(size(A,1),fix(size(A,1)/2)),:);            
        temp = cell(length(label), 1);
        
        for j=1:length(label)
            temp{j} = (A_sub * temp1{j}')';
        end
        
        
    end
    
    dataSet = [];           true_label = [];
        for j=1:length(label)
            if label(j)==tLabel
                dataSet = [dataSet; temp{j} ];
                true_label = [true_label; zeros(size(temp{j},1),1)];
            else
                dataSet = [dataSet; temp{j}(randsample(size(temp{j},1),ceil(size(temp{j},1)/10/(length(label)-1))),:) ];
                true_label = [true_label;  ones(ceil(size(temp{j},1)/10/(length(label)-1)),1)];
            end
        end

        distMrx = squareform(pdist(dataSet));
        suspiciousScore = SKNN(K,distMrx);            
        
        
        
end

