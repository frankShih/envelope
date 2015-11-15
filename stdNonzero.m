function [bestStdList] = stdNonzero(data, tLabel, Lambda_list)
% using each class to build envelope & calculate nonzero
% then use it to determine which std. to use
% [object value] minimize a=LAMBDA*b, where 'a' is target entropy
% 'b' is the difference between target & another with smallest entropy
% ================================================
% input
%   data: a matrix with first column as label
%   tLabel: target label for envelope extraction
%   lambda list: given lambda to find best-std
% output
%   std. list
   
    if nargin <3
        Lambda_list=1:10;
    end

    label = unique(data(:,1));   
    
    %--------build original data set---------    
    origin = cell(length(label), 1);    
    for j=1:length(label)           
        origin{j} = data(data(:,1)==label(j),2:end);
    end

    std_range=[.1:.1:3];
    all_nonzero=[];
    for n=std_range
               
        [m, s] = envelopeBuild(data(:,2:end),data(:,1));    % return mean/std. curve

        coded_alldata = cell(length(label), 1);
        nonzero_by_label = zeros(length(label), 1);
        for j=1:length(label)
            coded_alldata{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), n);
            dataNum_each_label=size(coded_alldata{j},1);
            for k=1:dataNum_each_label
                temp=coded_alldata{j}(k,:);
                nonzero_by_label(j)=nonzero_by_label(j) + sum(temp~=0)/length(temp);
            end
            nonzero_by_label(j)=nonzero_by_label(j)/dataNum_each_label;
        end
        all_nonzero=[all_nonzero,nonzero_by_label];
            
    end
    %{
    figure
    title('nonzero ratio')
    plot(all_nonzero');
    hold
    legend(num2str(label));
 %}
    
    bestStdList = [];
    for Lambda_index=1:length(Lambda_list)
        object_value=[];
        Lambda=Lambda_list(Lambda_index);
        for i=1:size(all_nonzero,2)
            target_std_nonzero=all_nonzero(:,i);
            targetValue = target_std_nonzero(label==tLabel);
            temp = target_std_nonzero(label~=tLabel);
            [~, sort_index]=sort(temp);
            low_1=temp(sort_index(1));
            
            object_value=[object_value, targetValue-Lambda*(low_1-targetValue)];
            
        end
        
         [~, sort_obj_index]=sort(object_value);
         bestStdList = [bestStdList std_range(sort_obj_index(1))];
%          plot(sort_obj_index(1),0:.001:2,'k');
%          pause()
    end
  
end
%}

