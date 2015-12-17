function [sumTE, sumVE, bestC] = envelopeTuning(data, best_std, fold, mode, C, A)
% input
%   data - with label in first column
%   best_std - obtain from 'stdEntropy', array of std. (for each class)
%   fold - for CV
%   mode - different ways for data representation 
%   ratio - compressed ratio (if needed)
% output
%   A - measurement matrix
% addpath E:\Dropbox\DM_ML\Toolbox\SSVMtoolbox
addpath E:\Dropbox\DM_ML\Toolbox\libsvm-3.19\matlab
if nargin < 6
    A= [];
end
labels = unique(data(:,1));
iteration = 10;
if fold==0
    flag = size(data,1)/length(labels);      %avg. instances of each class
    if flag < 20
        fold = size(data,1);        % leave one out
        iteration = 1;
    elseif flag < 50
        fold = 2;
        iteration = 25;
    elseif flag < 100
        fold = 5;
        iteration = 10;
    else
        fold = 10;
        iteration = 5;
    end
end
        
sumTE=zeros(size(C,2),2);  sumVE=zeros(size(C,2),2);
% A =  randn( fix(size(data(:,2:end),2)*length(labels)/(1/ratio)) , size(data(:,2:end),2)*length(labels)) / sqrt (size(data(2:end,:),2)*length(labels)/(1/ratio) );              
% measurement matrix = 1/sqrt(m)*rand(m,n)
%
for j=1:iteration
    TE=zeros(length(C),2); VE=zeros(length(C),2); 
    v_ind = crossvalind('KFold',size(data,1), fold);
    for c=C
        
        trainErr1 = 0; validateErr1= 0;
        for i=1:fold                % n-fold cross validation
            if mode ==-1
                train1 = data(v_ind~=i, 2:end);         %raw data
                test1 = data(v_ind==i, 2:end);
            else
                %
                [m_c, s_c] = envelopeBuild(data(v_ind~=i,2:end), data(v_ind~=i,1));                   
                train1=envelopeEncode(m_c,s_c,data(v_ind~=i, 2:end), best_std, mode, A);      
                test1=envelopeEncode(m_c, s_c, data(v_ind==i, 2:end), best_std, mode, A); 
%                 train1 = train1(:,length(train1)/2+1:end);
%                 test1 = test1(:,length(test1)/2+1:end);
            end
            model = svmtrain(data(v_ind~=i, 1), train1, ['-t 0 -c ' sprintf('%f', c)]);      

            [~, TErr1, ~] = svmpredict(data(v_ind~=i, 1), train1, model); 
            [~, VErr1, ~] = svmpredict(data(v_ind==i, 1), test1, model); 
       
             trainErr1=trainErr1+TErr1(1);       validateErr1=validateErr1+VErr1(1);               
        end
        
           TE(C==c,:) = [c trainErr1/fold  ];  
           VE(C==c,:) = [c validateErr1/fold ];
        
    end
    sumTE = sumTE + TE;
    sumVE = sumVE + VE;

end
sumTE = sumTE/iteration;
sumVE = sumVE/iteration;
[~, temp ] = max(sumVE(:,2)) ;
bestC = sumTE(temp, 1);


%
% plot the result if cross validation 
f= figure;
hold on;
temp = [sumTE(temp, 2) sumVE(temp, 2)];
plot(log2(C),sumTE(:,2), 'b', 'LineWidth', 2 );
plot(log2(C),sumVE(:,2), 'r', 'LineWidth', 2 );
title([num2str(fold) ' folds,  mode ' num2str(mode)  ',  best: ' num2str(temp)]);
legend('trainingAcc', 'validationAcc');
ylim([0 100])
xlabel('log2(C)')
% saveas(f,['E:\Dropbox\Graduation\envelope\Cinc1_mode_' num2str(mode) 'ratio_' num2str(ratio) ],'fig');

%}
end
 