function [ reduced, index ] = fReduction( data, label, tLabel )
% input
%   data - row-wised instances
%   label - correspond to data
%   tlabel - target label for finding most distintive parts
% output
% 
% Detailed explanation goes here


%----------------------------simple test to find a threshold ---------------------------
%{
tmp_a = 0;
tmp_b = 0;
for i=1:1000
    a=rand(100,200);
    b=randn(100,200);
    tmp_a = tmp_a + fValue(a, [zeros(20,1); ones(20,1); 2*ones(20,1); 3*ones(20,1) ; 4*ones(20,1)]);
    tmp_b = tmp_b + fValue(b, [zeros(20,1); ones(20,1); 2*ones(20,1); 3*ones(20,1) ; 4*ones(20,1)]);
end
tmp_a/1000       %(2)2.87 / (4) 1.5
tmp_b/1000       %(2)2.73 / (4) 1.49

%}

wSize = ceil(size(data,2)*.05);
curve = zeros(1,size(data,2)-wSize+1);

if nargin < 3       % select subsequences that are distintive to all class   
    for i=1:size(data,2)-wSize+1
        curve(i) = fValue(data(:,i), label);
    end

else
%     only focus on target class (one-against-rest secnario)
    label(label==tLabel) = 1;
    label(label~=tLabel) = 0;
    for i=1:size(data,2)-wSize+1
        curve(i) = fValue(data(:,i:i+wSize-1), label);
    end
end

% curve = [curve, fliplr(curve(end-wSize+1:end))];
figure; plot(curve);
% bound = prctile(curve, 50);
index = curve>3;
reduced = data(:,index);
end


%{
[newTrain index] = fReduction(TwoPatternsTRAIN(:,2:end), TwoPatternsTRAIN(:,1));
newTrain = [TwoPatternsTRAIN(:,1), newTrain];
temp = TwoPatternsTEST(:,2:end);
temp = temp(:,index);
newTest = [TwoPatternsTEST(:,1) temp];


%}