function [ f_val  ] = fValue( input_data, input_label )
%input:
%   data - row-wised
%   label 
%output:
%   f_val - (between means sum of squares)/(within means sum of squares)

    
    labels = unique(input_label);
    TSS = 0;          % total sum of squares
    WSS = 0;         % within group sum of squares
    BSS = 0;          % between groups  sum of squares
    t_mean = mean(input_data);              %mean of all data points
    g_mean = zeros(length(labels), size(input_data,2));      % mean of each group
    classCount = zeros(1, length(labels));  %number of instances in each class
%     for i=1:size(input_data,1)
%         TSS = TSS + sum(t_mean-input_data(i,:).^2);
%     end
    TSS = sum(sum(bsxfun(@minus, input_data, t_mean).^2));
    
    for i=1:length(labels)
        temp = input_data(input_label==labels(i),:);
        g_mean(i,:) = mean(temp);
        classCount(i) = size(temp,1);
        WSS = WSS + sum(sum(bsxfun(@minus, temp, g_mean(i)).^2));
        BSS = BSS + classCount(i)*sum((g_mean(i)-t_mean).^2);
    end
    
    BMSS = BSS/(length(labels)-1);
    WMSS = WSS/(size(input_data,1)-length(labels));
    
    f_val = BMSS/WMSS;
    
    
       
end



%{
% plot continuous pdf
 A = rand(700,1);
 MAX = max(A);
 STD = std(A);
 MAX = max(A);
 MIN = min(A);
 STEP = (MAX - MIN) / 1000;
 PDF = normpdf(MIN:STEP:MAX, Mean, Std);
 plot(MIN:STEP:MAX, PDF);


%}