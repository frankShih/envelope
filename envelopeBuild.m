function [ mean_curve, std_curve ] = envelopeBuild( input_data, input_label )
% input: 
%   a matrix of series  
%   a vector of labels
% output: 
%  a matrix of each users' mean 
%                                      & standard deviation (in label order)
    label = unique(input_label);    
    mean_curve = zeros(length(label), size(input_data,2)); 
    std_curve = zeros(length(label), size(input_data,2));
%     mean_values = zeros(length(label), 1);
    %=======preprocess before building envelope =======
    
    
    for i =1:size(label,1)
        temp = input_data(input_label==label(i),:);
%         mean_values(i) = mean(temp(:));
%         temp = temp-mean_values(i);  %correction
        if size(temp,1)==1
            temp_std = 0.01*std(temp)*ones(1, length(temp));     %use its std to build a brief envelope
            temp_mean = temp;                    
        else
            temp_std = std(temp,0,1);
            temp_mean = mean(temp,1);        
        end
        
        mean_curve(i,:) = temp_mean ;
        std_curve(i,:) = temp_std ;
       
       
    end  
       
    mean_curve(isnan(mean_curve)) = 0;
    std_curve(isnan(std_curve)) = 0;
    
  %{
    for i =1:size(label,1)
        figure;        
%          ylim([-50 50]);
%          plot(mean_curve(i,:),'LineWidth',2)
        hold
%         plot(mean_curve(i,:)+1*std_curve(i,:),'r','LineWidth',2)
%         plot(mean_curve(i,:)-1*std_curve(i,:),'r','LineWidth',2)
        fill([1:size(input_data,2), fliplr(1:size(input_data,2)) ], [mean_curve(i,:)+2*std_curve(i,:), fliplr(mean_curve(i,:)-2*std_curve(i,:))], [.7 .7 .7] ,'EdgeColor','none')
        fill([1:size(input_data,2), fliplr(1:size(input_data,2)) ], [mean_curve(i,:)+1*std_curve(i,:), fliplr(mean_curve(i,:)-1*std_curve(i,:))], [.9 .9 .9] ,'EdgeColor','none')
%{        
        for j= 1:size(label,1)
            if j==i
                continue
            else
                plot(mean_curve(j,:),'LineWidth',1,'Color', rand(1,3))
            end            
        end
        
%}
        
        %{
        temp = input_data(input_label==label(i),:);
        for j=1:size(temp, 1)
            plot(temp(j,:))
        end
        %}
        title(['label = ' num2str(label(i))]);
        
    end
    %}
end

