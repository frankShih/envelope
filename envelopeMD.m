function [ up_curve, low_curve , label]  = envelopeMD(input_data, input_label, percent)

% input 
%   TS: time series data
%   enWidth: percentile boundary (the range of coverage)
% output
%   upper&lower bound of envelope

    label = unique(input_label);    
    up_curve = []; low_curve=[];
  
    for i =1:size(label,1)
        temp = input_data(input_label==label(i),:);        
                                
        up_curve = [up_curve; quantile(temp, 0.5+percent) ];
        low_curve = [low_curve; quantile(temp, 0.5-percent) ];
        
    end  
    %
    for i =1:size(label,1)
        figure;
        
       
        hold
        plot(up_curve(1,:),'r','LineWidth',2)
        plot(low_curve(1,:),'r','LineWidth',2)
        for j= 1:size(label,1)
            if j==i
                continue
            else
                plot(quantile(input_data(input_label==label(j),:), 0.5), 'LineWidth', 1, 'Color', rand(1,3))
            end
            
        end
        pause
    end
    %}
end