function [bestStdAll] = stdNonzero(data, Lambda_list)
% using each class to build envelope & calculate nonzero ratio,
% then use it to determine which std. to use
% [object value] minimize a=LAMBDA*b, where 'a' is target entropy
% 'b' is the difference between target & another with smallest entropy
% ================================================
% input
%   data: a matrix with first column as label
%   lambda list: given lambda to find best-std
% output
%   std. list
   
    if nargin <2
        Lambda_list=1:3;
    end
    label = unique(data(:,1));   
    bestStdAll = [];
    std_range=[.1:.1:3];    
    [m, s] = envelopeBuild(data(:,2:end),data(:,1));    % return mean/std. curve
    
        
    for i=1:length(label)
    all_nonzero=[];
    for n=std_range
              
        coded_alldata = cell(length(label), 1);
        nonzero_by_label = zeros(length(label), 1);
        for j=1:length(label)
            coded_alldata{j} = envelopeEncode(m(label==label(i),:), s(label==label(i),:), data(data(:,1)==label(j),2:end), n);
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
            plot(all_nonzero');
            hold
            legend(num2str(label));
            text(20,.8,'minimize(a- \lambda*b)'); 
            set(gca, 'XTickLabel', {'0','.5','1','1.5','2','2.5','3'})
            ylabel('object value');
            xlabel('k-std ')
            title(['nonzero ratio  label = ' num2str(label(i)) ])
         %}
    
    bestStdList = [];
    for Lambda_index=1:length(Lambda_list)
        object_value=[];
        Lambda=Lambda_list(Lambda_index);
        for j=1:size(all_nonzero,2)
            target_std_nonzero=all_nonzero(:,j);
            targetValue = target_std_nonzero(label==label(i));
            temp = target_std_nonzero(label~=label(i));
            [~, sort_index]=sort(temp);
            low_1=temp(sort_index(1));
            
            object_value=[object_value, targetValue-Lambda*(low_1-targetValue)];
            
        end
        
        
         [~, sort_obj_index]=sort(object_value);
         bestStdList = [bestStdList std_range(sort_obj_index(1))];
%          plot(sort_obj_index(1),0:.001:2,'k');
%          text(sort_obj_index(1), Lambda*.18, ['\lambda = ' num2str(Lambda) ' std = ' num2str(std_range(sort_obj_index(1)))]); 
    end
    bestStdAll = [bestStdAll; bestStdList];
    end
  
end
%}

