function [records] = envelopeCandidate(trainSet, trainLabel)
% input - 
%       data & label
% output - 
%       a set of candidates(sub-sequences) that are discriminative 
% 
    labels = unique(trainLabel);
    records = [];
    
    disp(['********** creating all candidates...... ************'])
    
    for i = fix(size(trainSet, 2)/20):fix(size(trainSet, 2)/20):fix(size(trainSet, 2)/2)
%         for each possible window size
        for j = 1:fix(size(trainSet, 2)/50):size(trainSet, 2)-i
%             for each shift 
            sub_set = trainSet(:,j:j+i);
            temp = zeros(1,size(sub_set,1));
            for k=1:size(sub_set,1)         %calculate entropy for evaluation
                temp(k) = entropy(sub_set(k,:));
            end
            avg_entropy = zeros(1, length(labels));
            for k=1:length(labels)
                avg_entropy(k) = mean(temp(trainLabel==labels(k)));
            end
            [~,ind] =sort(avg_entropy);
            % maximize the gap between target & others            
            records = [records; i, j, avg_entropy(ind(2))-avg_entropy(ind(1)) , avg_entropy];
             
        end
    end
%     records - [window size, start position, score(gap between 2 min-entropy)]
    [~, ind] = sort(records(:,3),'descend');
    records = records(ind,:);
    disp(['************ finding best-N candidates...... *********'])
    % remove silimar records 
    len = size(records, 1);
    i=1;
    while i< len       
        lower = records(i,2);
        upper = records(i,2)+records(i,1);
        
        j=i+1;
        while j < len
            
            % remove candidate with overlapping
            if (records(j,2)-lower)*(records(j,2)-upper)<=0 || (records(j,2)+records(j,1)-lower)*(records(j,2)+records(j,1)-upper)<=0 ...
                    || (records(j,2)-lower)*(records(j,2)+records(j,1)-lower)<=0 && (records(j,2)-upper)*(records(j,2)+records(j,1)-upper)<=0
%                 [lower, upper; records(j,1:2)]
                records(j,:) = [];
                len = len-1;
            else
                j = j+1;
            end
            
        end
        i = i+1;
    end
    
    
    
end
    
    
    
    
    
    
    
    
    
    
    