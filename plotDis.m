function [ temp_sum ] = plotDis( data )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%{
addpath E:\Dropbox\inel_project\Code
data = [data(:,1) featureScaling(data(:,2:end)) ];
bin = 0:.1:1;     
temp_sum=zeros(length(bin)-1, size(data,2));    

for i = 1:size(data,2)
    ts=[];
    for j=1:length(bin)-1
        ts = [ts; sum(data(:,i) > bin(j) & data(:,i) <= bin(j+1))];            
    end
    temp_sum(:,i) = ts;    

end
%}

figure
hold on
for i=1:size(data,2)
    plot(sort(data(:,i)));
    pause


end

hold off
