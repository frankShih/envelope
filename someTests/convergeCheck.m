function [ entropyAll, zeroRatio, accAll ] = convergeCheck( trainData, testData )
%input
%   all the availiable data sets
% 
%   for each round, add 1 instance for all classes. then use entropy to
%   check if it converges(enough data to build envelope) or not.


allData = [trainData; testData];
labels = unique(allData(:,1));
subset = cell(1,length(labels));
bestStdList = [];
for i=1:length(labels)
        bestStdList = [bestStdList; stdEntropy( trainData,labels(i), 3)];
end


maxlimit = inf;
for i=1:length(labels)
    subset{i} = allData(allData(:,1)==labels(i),:);
    if size(subset{i},1) < maxlimit
        maxlimit = size(subset{i},1);
    end
end

currentTrain = [];      entropyAll = [];     zeroRatio = [];    accAll = [];

for i=1:maxlimit-1
    currentTest = [];
    for j=1:length(labels)
        currentTrain = [currentTrain; subset{j}(i,:)];
        currentTest = [currentTest; subset{j}(i+1:end,:)];
    end
    [ m, s] = envelopeBuild( currentTrain(:,2:end), currentTrain(:,1))    ;

    coded_data = cell(length(labels), 1);
    entropy_by_label = zeros(length(labels), 1);
    zero_by_label = zeros(length(labels), 1);
    for j=1:length(labels)
        coded_data{j} = envelopeEncode(m(labels==labels(j),:), s(labels==labels(j),:), currentTrain(currentTrain(:,1)==labels(j),2:end), 2);
        data_num_each_label=size(coded_data{j},1);
        for k=1:data_num_each_label
            temp=coded_data{j}(k,:);
            n_1 = sum(temp==1);
            n_0 = sum(temp==0);
            n_neg1 = sum(temp==-1);
            total = n_1+n_0+n_neg1;
            p = [n_1, n_0, n_neg1]./total;
            p(p==0) = [];
            entropy_by_label(j)=entropy_by_label(j)-sum(p.*log2(p));
            zero_by_label(j) = zero_by_label(j) + (n_0/length(temp));
        end
        entropy_by_label(j)=entropy_by_label(j)/data_num_each_label;
        zero_by_label(j) = zero_by_label(j)/data_num_each_label;
    end   
    entropyAll = [entropyAll entropy_by_label];
    zeroRatio = [zeroRatio zero_by_label];
    [ accuracy, ~] = envelopeTest( currentTrain(:,2:end), currentTrain(:,1), currentTest(:,2:end), currentTest(:,1), 0, 1 );
    accAll = [accAll accuracy];
end

%     figure; plot(entropyAll');   title('entropy each class');
%     hold on; plot((mean(entropyAll,1)), 'r', 'LineWidth', 2); 
%     figure; plot(zeroRatio');   title('zeroRatio each class');
%     hold on; plot((mean(zeroRatio,1)), 'r', 'LineWidth', 2); 
    figure;plot(accAll(1,:))
    xlabel('#instance each class')
    ylabel('accuracy')
    
end

