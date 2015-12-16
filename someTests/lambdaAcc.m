function accResult = lambdaAcc(data, fold, Lambda_list)

    
bestStdList = [];
label = unique(data(:,1));   
accResult = zeros(11,length(Lambda_list),2);


for i=1:length(label)
    bestStdList = [bestStdList; stdEntropy(data,label(i), Lambda_list)];
end

for i=1:size(bestStdList,2)
    [sumTE, sumVE, ~, ~] = envelopeTuning(data, bestStdList(:,i), fold);
    [~,I] = sort(sumVE(:,2));
%     accResult = [accResult; Lambda_list(i) sumTE(I(end),:) sumVE(I(end),2)];
    accResult(:,i,1) = sumTE(:,2);
    accResult(:,i,2) = sumVE(:,2);
    
end
%
mesh(accResult(:,:,1));
hold
mesh(accResult(:,:,2));
set(gca, 'YTickLabel',{'2^-10','2^-9','2^-8','2^-7','2^-6','2^-5','2^-4','2^-3','2^-3','2^-1','2^-0'})
set(gca, 'XTickLabel',num2cell(0.5:.5:5));
ylabel('C range')
xlabel('LAMBDA range')
%}
