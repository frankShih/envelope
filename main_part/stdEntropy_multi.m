function [bestStdAll, centroids] = stdEntropy_multi(data, Lambda_list)
% using each class to build envelope & calculate entropy
% then use it to determine which std. to use
% [object value] minimize a=LAMBDA*b, where 'a' is target entropy
% 'b' is the difference between target & another with smallest entropy
% ================================================
% input
%   data: a matrix with first column as label
%   tLabel: target class for envelope extraction
%   K for KNN
%   lambda list: for tuning
% output
%   std list (each class)


    if nargin <2
        Lambda_list=1:10;
    end

    
    std_range=[.1:.1:3];
    bestStdAll = [];
    [~, I] = sort(data(:,1));   data = data(I,:);
    [m, s, ind, centroids] = envelopeBuild_multi(data(:,2:end),data(:,1));    % return mean/std. curve
    m = cell2mat(m);    s = cell2mat(s);    ind = cell2mat(ind);
    newData = [ind(:,2)  data(:,2:end)];    %treat multi-cluster as new classes, and use original solution 
    newLabel = unique(newData(:,1));   
    
    for i=1:length(newLabel)
        all_entropy=[];
        for n=std_range                        
            coded_alldata = cell(length(newLabel), 1);
            entropy_by_label = zeros(length(newLabel), 1);
            for j=1:length(newLabel)
                coded_alldata{j} = envelopeEncode(m(i,:), s(i,:), newData(newData(:,1)==newLabel(j),2:end), n);
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
        end
    
        %{
        figure
        title('entropy')
        plot(all_entropy');
        hold
        legend(num2str(newLabel));
        %     pause
        %}
        bestStdList = [];
        for Lambda_index=1:length(Lambda_list)
            object_value=[];
            Lambda=Lambda_list(Lambda_index);
            for j=1:size(all_entropy,2)
                
                target_std_entropy=all_entropy(:,j);
                targetValue = target_std_entropy(newLabel==newLabel(i));
                temp = target_std_entropy(newLabel~=newLabel(i));
                [~, sort_index]=sort(temp);
                low_1=temp(sort_index(1));

                object_value=[object_value,targetValue-Lambda*(low_1-targetValue)];
            end

             [~, sort_obj_index]=sort(object_value);
             bestStdList = [bestStdList std_range(sort_obj_index(1))];
        %          plot(sort_obj_index(1),0:.001:2,'k');
        %          pause()
        end
        bestStdAll = [bestStdAll; bestStdList];
    end
end
%}

