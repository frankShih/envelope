function [ mean_curve, std_curve, index] = envelopeBuild_multi( data, label, clusterNum )
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
    
   
    %=======preprocess before building envelope =======
    bestK = ones(length(labels),1);
    index = cell(size(labels,1),1);
    for i =1:length(labels)
        index{i} = find(label==labels(i));
        current = data(label==labels(i),:);  
        if size(current,1)~=1
            if nargin < 3
                k = floor(sqrt(size(current,1)/2));           
                f = ones(1, k)*inf;
                for j=1:k
                    %
                    temp = 0;
                    for p=1:10      %using avg. to overcome randomness of clustering
                        [~, ~, sumd] = kmeans(current, j, 'EmptyAction', 'drop');
                        temp = temp+mean(sumd)/10;
                    end
                    f(j) = temp;  % fValue(current, index)/j;                
                    %}

                end

                for j=2:length(f)       % elbow method to find best K
                    if f(j) < f(j-1)/(2)
                        bestK(i) = bestK(i)+1;
                    else                    
                        break;
                    end
                end
                %{
                figure; plot(f); %pause

    %             [~, k] = max(abs(diff(f)));
                title(['label: ' num2str(labels(i)) '  best cluster: ' num2str(bestK)])
                xlabel('   #cluster: ')
                ylabel(' mean dist. to centroid ')
    %             figure; plot(abs(diff(f)));
            %}
            else
                bestK(i) = clusterNum(i);       % given best K clusters
            end
            [ind, ~] = kmeans(current, bestK(i), 'EmptyAction', 'drop');

            temp_std = [];
            temp_mean = [];       
            for j=1:bestK(i)
                temp = current(ind==j,:);
                temp_std = [temp_std; std(temp,0,1)];
                temp_mean = [temp_mean; mean(temp,1)];                
            end
            index{i} = [index{i} ind+i*100];
            mean_curve{i} = temp_mean ;
            std_curve{i} = temp_std;
        else
            index{i} = [index{i} 1+i*100];
            mean_curve{i} = current ;
            std_curve{i} = zeros(size(current));
        end
    end  
       
    
  %{
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

