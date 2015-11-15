function [ trainSyncData, trainLabel, testSyncData, testLabel, benchmark ] = syncTransform( trainData, testData, ~ )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
labels = unique(trainData(:,1));
trainSyncData = [];     testSyncData  = [];    trainLabel = [];    testLabel = testData(:,1);
%{
testSyncData = cell(length(labels), 1);
benchmark = zeros(length(labels), size(trainData,2)-1);
while max(pdist(benchmark,'cosine'), 0) < 1
    for i=1:length(labels)
        trainTemp = trainData(trainData(:,1)==labels(i),2:end);            
        benchmark(i,:) = trainTemp(randsample(size(trainTemp, 1),1),:);
    end
end

for i=1:length(labels)
    trainTemp = trainData(trainData(:,1)==labels(i),2:end);    
    trainTempLabel = trainData(trainData(:,1)==labels(i),1);

    for  j=1:size(trainTemp,1)
        trainTemp(j,:) = syncTest(benchmark(i,:), trainTemp(j,:));
         
    end    
    trainSyncData = [trainSyncData;  trainTemp];
    trainLabel = [trainLabel; trainTempLabel];

    testTemp = zeros(size(testData,1), size(testData,2)-1);    
    for  j=1:size(testData,1)    
        testTemp(j,:) = syncTest(benchmark(i,:), testData(j,2:end));
    end
    testSyncData{i} = testTemp;
    

end
%}


% ------------------sync regardless the label of instances-----------------    
% 
    if nargin <3
    benchmark = trainData(randsample(size(trainData, 1),1),:);
    else
        
    end
    trainSyncData = zeros(size(trainData));
    for  j=1:size(trainData,1)
%         disp(['train - ' num2str(j)]);
        [temp, ~] = syncTest(benchmark(2:end), trainData(j,2:end));
        trainSyncData(j,:) = [trainData(j,1) temp];

    end
    testSyncData = zeros(size(testData));
    for  j=1:size(testData,1)
    %     disp(['test - ' num2str(i)]);
        [temp, ~] = syncTest(benchmark(2:end), testData(j,2:end));
        testSyncData(j,:) = [testData(j,1) temp];    
    end
%}