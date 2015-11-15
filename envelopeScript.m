function envelopeScript(data, Lambda_list)
%{
bestStdList = [];
label = unique(data(:,1));   

for i=1:length(label)
    bestStdList = [bestStdList; stdEntropy(data,label(i), Lambda_list)];
end

%}
% ---------  raw data ---------
C=2.^(-10:0);
envelopeTuning(data, bestStdList, 5, -1, 1, C);
%{
% ---------  1/0/-1 ---------
C=2.^(-11:-3);
envelopeTuning(data, bestStdList, 5, 0, 1, C);
%
% ---------  counting ---------
C=2.^(-15:-5);
envelopeTuning(data, bestStdList, 5, 1, 1, C);
%
% ---------  entropy ---------
C=2.^(-3:3);
envelopeTuning(data, bestStdList, 5, 2, 1, C);
%
% ---------  compressed 10% ---------
C=2.^(-10:-2);
envelopeTuning(data, bestStdList, 5, 3, 0.1, C);
%
% ---------  compressed 20% ---------
C=2.^(-12:-2);
envelopeTuning(data, bestStdList, 5, 3, 0.2, C);

% ---------  compressed 50% ---------
C=2.^(-12:-2);
envelopeTuning(data, bestStdList, 5, 3, 0.5, C);
%}



end