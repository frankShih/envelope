function [ result ] = normalDistributionCheck( data, m )
% input 
%   data:  row-wised, first column as label
%   m: mode
% output
%   given values, near to zero -> normal distribution
if nargin <2
    m=0;
end
if m==1
    data(:,1) = 1;
end
labels = unique(data(:,1));
flag=0;
result = zeros(length(labels), 3);          %keep the mean result for each class
% data =[data(:,1), fReduction(data(:,2:end), data(:,1))];

for label = 1:length(labels)
    subset = data(data(:,1)==labels(label),2:end);

    IQR_val = zeros(1,size(subset,2));          % interquartile range 
    SD = zeros(1,size(subset,2));                  % standard deviation
%     SK = zeros(1,size(subset,2));                  % skewness
%     KU = zeros(1,size(subset,2));                  % kurtosis
    for i=1:size(subset,2)
        IQR_val(i) = iqr(subset(:,i))/1.35;  %IQR/1.35 ==SD  -> normal distribution
        SD(i) = std(subset(:,i));
%         SK(i) = skewness(subset(:,i));  %normal = 0
%         KU(i) = kurtosis(subset(:,i));      %normal = 0
    end
    
    result(label, :) = [mean(IQR_val-SD), 0, 0];
%     figure; plot(IQR_val, 'LineWidth', 2);    
%     hold on; plot(SD, 'r', 'LineWidth', 2); plot(IQR_val-SD, 'g', 'LineWidth', 2)
%     title(['IQR,  label= ' num2str(label), ', mode= ' num2str(mode(IQR_val-SD)), ', mean= ' num2str(mean(IQR_val-SD))]); 
%     figure; plot(SK, 'LineWidth', 2); title(['skewness,  label= ' num2str(label), ', mode= ' num2str(mode(SK)), ', mean= ' num2str(mean(SK))]);
%     figure; plot(KU, 'LineWidth', 2); title(['kurtosis,  label= ' num2str(label), ', mode= ' num2str(mode(KU))]);
    
    
end




