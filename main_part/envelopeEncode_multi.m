function [ output ] = envelopeEncode_multi(mc, sc, input, n_std, mode, CS)
%================================================
% [Input]
% m: list of mean curves (may more than one curve in a class)
% s: list ofstd_curves
% input: data needed to be transformed 
% n_std: upper/lower bound 
% CS: measurement
%[Output]
% data in different format
% ================================================
nonzeroRatio=@(x) length(nonzeros(x))/length(x);

if nargin<6
    CS=[];
    mode = 0;    
elseif nargin<7
    CS=[];    
end

stdList = cell(length(mc),1);     flag = 1;
for i=1:length(mc)
    stdList{i} = n_std(flag:flag+size(mc{i},1)-1);
    flag = flag+size(mc{i},1);
end

switch mode
case 0
    temp1=zeros(1,length(mc)*length(mc{1}));
    output = zeros(size(input,1),length(mc)*length(mc{1}));
case 1
    temp1=zeros(1,3*length(mc));
    output = zeros(size(input,1),3*length(mc));
case 2
    temp1=zeros(1,length(mc));
    output = zeros(size(input,1),length(mc));
case 3
    temp1=zeros(1,length(mc)*length(mc{1}));
    output = zeros(size(input,1),length(mc)*length(mc{1}));
end
    if iscell(input)
		number = size(input{1},1);
    else
        number = size(input,1);
    end
	
for j=1:number           % for each instance
    flag=1;
    temp1=zeros(size(temp1));
    for i=1:length(mc)          % for each label of envelope
       options = zeros(size(mc{i}));
       temp = zeros(length(mc{i}),1); bestNonzero = inf;
       for k = 1:size(mc{i},1)  % for each pattern in a class, find sparest one
           if ~iscell(input)
               options(k,input(j,:) > mc{i}(k,:)+stdList{i}(k)*sc{i}(k,:)) = 1;
               options(k,input(j,:) < mc{i}(k,:)-stdList{i}(k)*sc{i}(k,:)) = -1;               
           else
               options(k,input{i}(j,:) > mc{i}(k,:)+stdList{i}(k)*sc{i}(k,:)) = 1;
               options(k,input{i}(j,:) < mc{i}(k,:)-stdList{i}(k)*sc{i}(k,:)) = -1;               
           end
           if nonzeroRatio(options(k,:)) < bestNonzero
               temp = options(k,:);
               bestNonzero = nonzeroRatio(options(k,:));               
           end
       end 
       
       if mode==1           %-------counting---------
           temp = [sum(temp>0), sum(temp==0), sum(temp<0)]; 
       elseif mode==2    %--------zero ratio---------
			temp = sum(temp==0)/length(temp);        
            %{
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



