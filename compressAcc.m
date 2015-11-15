function compressAcc( trainData, testData )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
all_acc=[];

%{
% perform dimension reduction with f-test
[rTrain, index ] = fReduction( trainData(:,2:end), trainData(:,1) );
rTrain = [trainData(:,1) rTrain];
rTest = testData(:,2:end);
rTest = rTest(:,index);
rTest = [testData(:,1) rTest];
%}
ratio = .05:.05:1;
for r=ratio
    [ accuracy, ~ ] = envelopeTest( trainData(:,2:end), trainData(:,1), testData(:,2:end), testData(:,1), 3, r );
    all_acc = [all_acc; accuracy(1)];

end

%
f = figure; 
hold on;

plot(ratio,all_acc, 'r', 'LineWidth', 2 );
legend( 'testAcc');
ylim([0 100])
xlabel('compressed ratio')
% saveas(f,['E:\Dropbox\Graduation\envelope\Cinc1_mode_' num2str(mode) 'ratio_' num2str(ratio) ],'fig');

%}