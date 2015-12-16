%
function envelopePCA(data, tLabel, n_std, ratio)
% ================================================
% input
%   data: a matrix with first column as label
%   tLabel: target label for envelope extraction
%   n_std: # of standard deviation to create upper/lower bound

%   K for KNN
% ===============================================

    label = unique(data(:,1));    
    %--------build original data set---------
    
    origin = cell(length(label), 1);        

    %---------build envelope coded & compressed data --------
    % only use part of target label to build model    
    t_test = [];        t_train = [];
    for j=1:length(label)
        temp = data(data(:,1)==label(j),:);
        ind = randsample(size(temp,1), fix(size(temp,1)/2));
        ind_1 = 1:size(temp,1);
        ind_1(ind)=[];
        t_test = [t_test; temp(ind,:)];          
        t_train = [t_train; temp(ind_1,:)];    
        origin{j} = temp(ind,:);
    end

    [m, s] = envelopeBuild(t_train(:,2:end),t_train(:,1));
    %     [up, low] = envelopeMD(t_train(:,2:end), t_train(:,1), n_std);

    coded = cell(length(label), 1);        
    for j=1:length(label)
        coded{j} = [t_test(t_test(:,1)==label(j),1) envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), t_test(t_test(:,1)==label(j),2:end), n_std)]; 
    %         coded{j} = envelopeMDCoding(up(label==tLabel,:), low(label==tLabel,:), data(data(:,1)==label(j),2:end));            
    end

    A = sqrt (size(coded{1},1) ) *randn( size(coded{1},1) , size(coded{1},2)-1);              
    A_sub = A(randsample(size(A,1), fix(size(A,1)*ratio)),:);            
    compressed = cell(length(label), 1);
    for j=1:length(label)
        compressed{j} = [coded{j}(:,1) (A_sub * (coded{j}(:,2:end))')'];
    end

    %------------------random sample anomaly data & calculate AUC ------------------------
    dataSet = [];          dataSet_e = [];      dataSet_c = [];
    %         compute average AUC for envelope & original domain
    for j=1:length(label)
        if label(j)==tLabel                
            dataSet = [dataSet; origin{j} ];                            
            dataSet_e = [dataSet_e; coded{j} ];    
            dataSet_c = [dataSet_c; compressed{j} ];
        else                
            sample_ind = randsample(size(origin{j},1), ceil(size(origin{j},1)/10/(length(label)-1)));
            dataSet = [dataSet; origin{j}(sample_ind,:) ];

            sample_ind = randsample(size(coded{j},1), ceil(size(coded{j},1)/10/(length(label)-1)));
            dataSet_e = [dataSet_e; coded{j}(sample_ind,:) ];      
            dataSet_c = [dataSet_c; compressed{j}(sample_ind,:) ];
        end
    end   
    % --------------------------------PCA-----------------------------------    

    %----------original domain------------
    [eigenVector, ~, ~] = princomp(dataSet(:,2:end));   %PCA dimension reduction       
    dataSet = [dataSet(:,1)  dataSet(:,2:end)*eigenVector(:,1:3)];

    cc = hsv(length(label));
    figure;     hold;   grid;
    for j=1:length(label)            
        scatter3(dataSet(dataSet(:,1)==label(j),2), dataSet(dataSet(:,1)==label(j),3), ...
                        dataSet(dataSet(:,1)==label(j),4),'filled','MarkerFaceColor',cc(j,:));
    end
    legend(num2str(label))
    title(['original - ' 'target label: ' num2str(tLabel) ]);
    
    %----------envelope domain------------
    [eigenVector, ~, ~] = princomp(dataSet_e(:,2:end));   %PCA dimension reduction       
    dataSet_e = [dataSet_e(:,1)  dataSet_e(:,2:end)*eigenVector(:,1:3)];

    cc = hsv(length(label));
    figure;     hold;   grid;
    for j=1:length(label)            
        scatter3(dataSet_e(dataSet_e(:,1)==label(j),2), dataSet_e(dataSet_e(:,1)==label(j),3), ...
                        dataSet_e(dataSet_e(:,1)==label(j),4),'filled','MarkerFaceColor',cc(j,:));
    end
    legend(num2str(label))
    title(['envelope - ' 'target label: ' num2str(tLabel) ]);
        
    %----------compress domain------------
    [eigenVector, ~, ~] = princomp(dataSet_c(:,2:end));   %PCA dimension reduction       
    dataSet_c = [dataSet_c(:,1)  dataSet_c(:,2:end)*eigenVector(:,1:3)];

    cc = hsv(length(label));
    figure;     hold;   grid;
    for j=1:length(label)            
        scatter3(dataSet_c(dataSet_c(:,1)==label(j),2), dataSet_c(dataSet_c(:,1)==label(j),3), ...
                        dataSet_c(dataSet_c(:,1)==label(j),4),'filled','MarkerFaceColor',cc(j,:));
    end
    legend(num2str(label))
    title(['compress - ' 'target label: ' num2str(tLabel) ]);

   
end
%}
