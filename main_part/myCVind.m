function [ output ] = myCVind( dataSize, n_fold )
% input
%       dataSize: the number of data instances in a data set
%       n_fold: fold of cross validation
% output
%       same as matlab function - crossvalind 
    output = zeros(dataSize, 1);

    sub_length = fix(dataSize/n_fold);
    start = randsample(dataSize-sub_length+1, 1);
    temp = start;
    for i=1:n_fold
        if temp+sub_length-1 <= dataSize
            output(temp:temp+sub_length-1) = i;    
            temp = temp+sub_length;
        else
            ind = temp:dataSize;
            remain = sub_length-length(ind);
            ind = [ind 1:remain];
            output(ind) = i;
            temp = remain+1;
        end

    end

    ind = find(output==0);
    for i=1:length(ind)

        output(ind(i)) = randsample(n_fold, 1);
    end


end