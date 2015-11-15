function output = envelopeMDCoding(up, low, TS)
% TS 
%   TS: data
%   percent: upper&lower bound of envelope
%                   eg. percent=10, set percentile 40~60 to 0
% output 
%   encoded data
%{
[n,p] = size(TS);
EPcoding = zeros(n,p);

% EPcoding(TS<repmat(EP(1,:),n,1))=-1;
% EPcoding(TS>repmat(EP(2,:),n,1))=1;

tmp = TS<repmat(EP(1,:),n,1);
EPcoding(tmp)=TS(tmp);
tmp = TS>repmat(EP(2,:),n,1);
EPcoding(tmp)=TS(tmp);
%}

output = [];
for j=1:size(TS,1)
    temp1=[];
    for i=1:size(up,1)
%         temp_up = TS(j,:) - m(i,:)+percent*s(i,:);
%         temp_low = TS(j,:) - m(i,:)-percent*s(i,:); 
        temp = zeros(size(up(i,:)));
        
        temp(TS(j,:) > up(i,:)) = 1;%TS(j,TS(j,:) > m(i,:)+percent*p(i,:));%temp_up(TS(j,:) > m(i,:)+percent*p(i,:));
        temp(TS(j,:) < low(i,:)) = -1;%TS(j,TS(j,:) < m(i,:)-percent*p(i,:));%temp_low(TS(j,:) < m(i,:)-percent*p(i,:));
        temp1=[temp1, temp];
    end
    output = [output; temp1];
end

end

