function [ output ] = envelopeEncode(mc, sc,  input, n_std, mode, CS)
%================================================
% [Input]
% m: mean curve
% s: std_curve
% input: data needed to be transformed
% n_std: upper/lower bound 
% CS: measurement(sensing) matrix
%[Output]
% data in different format
% ================================================
if nargin<5
    CS=[];
    mode = 0;    
elseif nargin<6
    CS=[];    
end


switch mode
case 0
    temp1=zeros(1,numel(mc));
    output = zeros(size(input,1),numel(mc));
case 1
    temp1=zeros(1,3*size(mc,1));
    output = zeros(size(input,1),3*size(mc,1));
case 2
    temp1=zeros(1,size(mc,1));
    output = zeros(size(input,1),size(mc,1));
case 3
    temp1=zeros(1,numel(mc));
    output = zeros(size(input,1),numel(mc));
end

for j=1:size(input,1)
    flag=1;
    temp1=zeros(size(temp1));
    for i=1:size(mc,1)
        temp = zeros(size(mc(i,:)));
		% can replace 1/-1 with its real value or the distance to the boundary
        temp(input(j,:) > mc(i,:)+n_std(i)*sc(i,:)) = 1;
        temp(input(j,:) < mc(i,:)-n_std(i)*sc(i,:)) = -1;
        
       if mode==1           %-------counting---------
           temp = [sum(temp>0), sum(temp==0), sum(temp<0)]; 
       elseif mode==2    %--------zero ratio---------
           temp = sum(temp==0)/length(temp);        
           %{
		   % entropy
           temp = [sum(temp==1), sum(temp==0), sum(temp==-1)];                         
           p = temp./sum(temp);
           p(p==0) = [];
           temp = -sum(p.*log2(p));
           %}
       else
           %         mode 0, ------ 1/0/-1 ------
       end 
        temp1(flag:flag+length(temp)-1) = temp;
        flag = flag+length(temp);
    end
    output(j,:) = temp1;
end

if mode==3      %------------compressed-----------
    output = (CS * output')';
end
end



