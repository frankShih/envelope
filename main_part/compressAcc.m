function [all_acc] = compressAcc( trainData, testData )
%input 
%	~
%output
%	accuracy of different compression ratio
all_acc=[];
A = [];
labels = unique(trainData(:,1));
%{
% perform dimension reduction with f-test
[rTrain, index ] = fReduction( trainData(:,2:end), trainData(:,1) );
rTrain = [trainData(:,1) rTrain];
rTest = testData(:,2:end);
rTest = rTest(:,index);
rTest = [testData(:,1) rTest];
%}
ratio = .05:.05:1;
A =  randn( size(trainData(:,2:end),2)*length(labels) , size(trainData(:,2:end),2)*length(labels))/ sqrt(size(trainData(2:end,:),2)*length(labels) );              
% A =  randn( fix(size(trainData(:,2:end),2)*length(labels)/(1/r)) , size(trainData(:,2:end),2)*length(labels)) / sqrt (size(trainData(2:end,:),2)*length(labels)/(1/r) );              
for r=ratio
    A_sub = A(1:fix(size(trainData(:,2:end),2)*length(labels)/(1/r)), :) ;
    [ accuracy, ~ ] = envelopeTest( trainData(:,2:end), trainData(:,1), testData(:,2:end), testData(:,1), 3, A_sub);
    all_acc = [all_acc; accuracy(1)];
end

f = figure; 
hold on;
plot([ratio ],mean(accAll), 'r', 'LineWidth', 2 );

ylim([0 100])
xlabel('compressed ratio')
ylabel('classification accuracy')
% saveas(f,['E:\Dropbox\Graduation\envelope\Cinc1_mode_' num2str(mode) 'ratio_' num2str(ratio) ],'fig');
%}

% plot(ratio, repmat(74.5,1,20),'g');
% plot(ratio, repmat(85.88,1,20));
% legend( 'envelope+SVM', '1NN+ED', '1NN+DTW');
%  text(.2, 40, [sprintf('avgSparsity=91.25 \n'), 'O(k*ln(n/k)) \approx 0.34 (in percentage)' ])