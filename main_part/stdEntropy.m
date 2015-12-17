function [bestStdAll] = stdEntropy(data, Lambda_list)
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

%     
    if nargin <2
        Lambda_list=1:3;
    end
    label = unique(data(:,1));   
    bestStdAll = [];
    std_range=[.1:.1:3];    
    [m, s] = envelopeBuild(data(:,2:end),data(:,1));    % return mean/std. curve
    
    for i=1:length(label)
    
    all_entropy=[];
    for n=std_range         
              
        coded_alldata = cell(length(label), 1);
        entropy_by_label = zeros(length(label), 1);
        for j=1:length(label)
            coded_alldata{j} = envelopeEncode(m(label==label(i),:), s(label==label(i),:), data(data(:,1)==label(j),2:end), n);
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
    
    plot(all_entropy');
    hold
    legend(num2str(label));
    ylabel('object value');
    xlabel('#std *10')
    title(['entropy  label = ' num2str(label(i)) ])
    %}
    bestStdList = [];
    for Lambda_index=1:length(Lambda_list)
        object_value=[];
        Lambda=Lambda_list(Lambda_index);
        for j=1:size(all_entropy,2)
            target_std_entropy=all_entropy(:,j);
            targetValue = target_std_entropy(label==label(i));
            temp = target_std_entropy(label~=label(i));
            [~, sort_index]=sort(temp);
            low_1=temp(sort_index(1));
            
            object_value=[object_value,targetValue-Lambda*(low_1-targetValue)];            
        end
        
         [~, sort_obj_index]=sort(object_value);
         bestStdList = [bestStdList std_range(sort_obj_index(1))];

%         text(sort_obj_index(1)-3, Lambda*.18, ['\lambda = ' num2str(Lambda) ' std = ' num2str(std_range(sort_obj_index(1)))]); 
    end
    bestStdAll = [bestStdAll; bestStdList];
    end
end
%}

