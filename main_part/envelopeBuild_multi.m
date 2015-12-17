function [ mean_curve, std_curve, index, bestCen] = envelopeBuild_multi( data, label, centroids )
% using clustering to build multi-envelope without label information
% use it when there exist more than one pattern in a class
% input: 
%   a matrix of series  
%   a vector of labels
%   indicator - indicate that wihich class may have multi-pattern, and
%   perform clustering 
% output: 
%   cell array of matrix of each users' mean 
%                                      & standard deviation (in label order)
    labels = unique(label); 
    mean_curve = cell(length(labels), 1);
    std_curve = cell(length(labels), 1);
    bestCen = cell(1, length(labels));
   
    %=======preprocess before building envelope =======
%     bestK = ones(length(labels),1);
    index = cell(size(labels,1),1);
    for i =1:length(labels)
        index{i} = find(label==labels(i));
        current = data(label==labels(i),:);  
        if size(current,1)~=1       % avoid the condition with only one instance 
%             can set a threshold, if certain class contain less than 'n' instances, don't perform clustering
            if nargin < 3       % find best centroids for tuning
                k = floor(sqrt(size(current,1)/2));           
                f = ones(1, k)*inf;
                tempCen = cell(1,k);
                for j=1:k
                    temp = inf;   
                    for p=1:10      %using avg. to overcome randomness of clustering, and get best centroid
                        [~, centroid, sumd] = kmeans(current, j, 'EmptyAction', 'drop');
                        if sum(sumd(:)) < temp
                            temp = sum(sumd(:));
                            tempCen{j} = centroid;
                        end
                    end
                    f(j) = temp;  % fValue(current, index)/j;                

                end
                bestCen{i} = tempCen{1};
                for j=2:length(f)       % elbow method to find best K
                    if f(j) < f(j-1)/(3/2)
                        bestCen{i} = tempCen{j};
%                         bestK(i) = bestK(i)+1;
                    else                    
                        break;
                    end
                end
				
                %{
				% a plot t verify if the chosen k is reasonable
                figure; plot(f); 
                title(['label: ' num2str(labels(i)) '  best cluster: ' num2str(bestK)])
                xlabel('   #cluster: ')
                ylabel(' mean dist. to centroid ')
				%}
				% using centroids found from above steps
                [ind, ~] = kmeans(current, size(bestCen{i}, 1), 'EmptyAction', 'drop', 'Start', bestCen{i});
                temp_std = [];
                temp_mean = [];       
                for j=1:size(bestCen{i},1)
                    temp = current(ind==j,:);
                    temp_std = [temp_std; std(temp,0,1)];
                    temp_mean = [temp_mean; mean(temp,1)];                
                end
            else    %using given centroids
                [ind, ~] = kmeans(current, size(centroids{i},1), 'EmptyAction', 'drop', 'Start', centroids{i});       % given best K clusters
                temp_std = [];
                temp_mean = [];       
                for j=1:size(centroids{i},1)
                    temp = current(ind==j,:);
                    temp_std = [temp_std; std(temp,0,1)];
                    temp_mean = [temp_mean; mean(temp,1)];                
                end
            end
           
            index{i} = [index{i} ind+i*100];
            mean_curve{i} = temp_mean ;
            std_curve{i} = temp_std;
        else            % only  one instance cluster
            index{i} = [index{i} 1+i*100];
            mean_curve{i} = current ;
            std_curve{i} = zeros(size(current));
            bestCen{i} = current;
        end
    end  
       
    
  %{
	% plot all the envelopes
    for i =1:length(labels)        
        for j = 1:size(mean_curve{i},1)
        figure;       
        ylim([-3 3]);
%          plot(mean_curve(i,:),'LineWidth',2)
        hold
%         plot(mean_curve(i,:)+1*std_curve(i,:),'r','LineWidth',2)
%         plot(mean_curve(i,:)-1*std_curve(i,:),'r','LineWidth',2)
        fill([1:size(data,2), fliplr(1:size(data,2)) ], [mean_curve{i}(j,:)+2*std_curve{i}(j,:), fliplr(mean_curve{i}(j,:)-2*std_curve{i}(j,:))], [.7 .7 .7] ,'EdgeColor','none')
        fill([1:size(data,2), fliplr(1:size(data,2)) ], [mean_curve{i}(j,:)+1*std_curve{i}(j,:), fliplr(mean_curve{i}(j,:)-1*std_curve{i}(j,:))], [.9 .9 .9] ,'EdgeColor','none')
	%{        
        for j= 1:size(label,1)
            if j==i
                continue
            else
                plot(mean_curve(j,:),'LineWidth',1,'Color', rand(1,3))
            end            
        end
	%}
        
        %{
        temp = input_data(input_label==label(i),:);
        for j=1:size(temp, 1)
            plot(temp(j,:))
        end
        %}
        title(['label = ' num2str(labels(i)) '  cluster = ' num2str(j)]);
        end
    end
%}
end

