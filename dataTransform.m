function [ output ] = dataTransform( input, mode)
% input : datasest with first column as label
%           OR
%             a cell of datasets with different axis
% (depends lone mode)
    if nargin<2
        mode = 1;
    end
    if mode ==1
% ------------- differentiate --------------
        output = [input(:,1) diff(input(:,2:end), 1, 2)];
    elseif mode ==2
% ------------- integrate --------------
        output = [input(:,1) cumsum(input(:,2:end), 2)];         
    else                
% --------------combine all axes into one--------------
% in this mode, input should be a cell of datasets with different axis
        labels = unique(input{1}(:,1));
        output =[];
        
        for i=1:length(labels)
            dataSet = [];
            for j=1:length(input)
                ind = input{j}(:,1)==labels(i);
                len = sum(ind);
                dataSet = [dataSet; reshape(input{j}(ind,2:end), 1, len*(size(input{j},2)-1))];
                
            end
            [eigenVector, ~, ~] = princomp(dataSet');   %PCA dimension reduction
            dataSet =  eigenVector(:,1)'*dataSet;
            dataSet = [ ones(len,1)*labels(i), reshape(dataSet',len,(size(input{j},2)-1))];
            output = [output; dataSet];
        end
    end


end

