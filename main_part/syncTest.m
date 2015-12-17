function [ aligned,lagDiff] = syncTest( Series1, Series2)
%input 
% 2 series
%output
% alignment series with index (either  one would be modified)
%{
ind=0;
figure
subplot(2,1,1)
plot(1:length(Series1),Series1);
title('train')

subplot(2,1,2)
plot(1:length(Series2),Series2);
title('test')
% The cross-correlation of the two measurements is maximum at a lag equal to the delay.
fig = nan(1,2);
[acor,lag] = xcorr(Series1, Series2);
[~,I] = max(abs(acor));
lagDiff = lag(I);
if lagDiff<0
    ind = 2;
    aligned = [Series2(1) Series2(-lagDiff:end) median(Series2)*ones(1, -lagDiff)];
    figure
    fig(1)=subplot(2,1,1);
    plot(1:length(Series1),Series1);
    title('train')

    fig(2) = subplot(2,1,2);
    plot(1:length(aligned),aligned);
    title('test')   
    
    set(fig, 'xlim', [1, length(Series1)])
else
    ind=1;
    aligned = [Series1(1) Series1(lagDiff:end)  median(Series1)*ones(1, lagDiff)];
    figure
    fig(1) = subplot(2,1,1);
    plot(1:length(aligned),aligned);
    title('train')
    xlim([1, length(Series2)])
    fig(2) = subplot(2,1,2);
    plot(1:length(Series2),Series2);
    title('test')   
    
    set(fig, 'xlim', [1, length(Series2)])
end
%}

% suppose that Series1 always no delay -> Series2 needed to be aligned
%
% ==========cross-correlation approach===========
[acor,lag] = xcorr(Series1, Series2);
[~,I] = max((acor));
lagDiff = lag(I);

if lagDiff<0
    aligned = [Series2(-lagDiff+1:end) median(Series2)*ones(1, -lagDiff)];
elseif lagDiff>0
    aligned = [median(Series2)*ones(1, lagDiff) Series2(1:end-lagDiff) ];
else    
    aligned = Series2;
end
%}


% ========= euclidean distance approach=========
%{
indicator = zeros(1, length(Series1)+length(Series2)-1);
for i=1:length(indicator)

temp1 = 
temp2 = 
%}

end

