%
function stdAUC(data, tLabel, K)
% ================================================
% input
%   data: a matrix with first column as label
%   tLabel: target label for envelope extraction
%   K for KNN
% ===============================================
        
    label = unique(data(:,1));   
    auc_result = [];    
    %--------build original data set---------    
    origin = cell(length(label), 1);    
    for j=1:length(label)           
        origin{j} = data(data(:,1)==label(j),2:end);
    end


    for n=.1:.2:3
        n
        AUCavg = 0;
        for i=1:100       
            %------------------random sample anomaly data & calculate AUC ------------------------
            dataSet = [];           auc_label = [];                           
            %------------------------- original domain---------------------
            for j=1:length(label)
                if label(j)==tLabel                
                    dataSet = [dataSet; origin{j} ];            
                    auc_label = [auc_label; zeros(size(origin{j},1),1)];               
                else                

                    sample_ind = randsample(size(origin{j},1), max(fix(size(origin{j},1)/10/(length(label)-1)), 1));
                    dataSet = [dataSet; origin{j}(sample_ind,:) ];
                    auc_label = [auc_label;  ones(max(fix(size(origin{j},1)/10/(length(label)-1)), 1), 1)];                
                end
            end   

            distMrx = squareform(pdist(dataSet));
            scores = SKNN(K,distMrx);   
            [X,Y,~,AUC] = perfcurve(auc_label, scores, 1);        
            AUCavg = AUCavg+AUC;
%             figure
%             plot(X,Y);
            
        end
    
    %-------------------------envelope & compress domain-----------------------        
        AUCavg_env=0;     AUCavg_com=0;     AUCavg_count=0;   AUCavg_entro=0;
        nzero_t = 0;    nzero_o = 0;
        for i=1:10
            dataSet_env = [];     dataSet_com = [];           
            dataSet_count = [];     dataSet_entro = [];           
            auc_label_e = [];         
                        
            %---------build envelope coded data --------
            % only use part of target label to build model    
            t_test = [];        t_train = [];
            for j=1:length(label)
                temp = data(data(:,1)==label(j),:);
                ind = randsample(size(temp,1), fix(size(temp,1)/2));
                ind_1 = 1:size(temp,1);
                ind_1(ind)=[];
                t_test = [t_test; temp(ind,:)];          
                t_train = [t_train; temp(ind_1,:)];    
            end

            [m, s] = envelopeBuild(t_train(:,2:end),t_train(:,1));
            %     [up, low] = envelopeMD(t_train(:,2:end), t_train(:,1), n_std);

            coded = cell(length(label), 1);    
            counting = cell(length(label), 1);    
            entro = cell(length(label), 1);     
            compressed = cell(length(label), 1);
            A = sqrt (size(origin{1},1) ) *randn( size(origin{1},1) , size(origin{1},2));  
            A_sub = A(randsample(size(A,1), fix(size(A,1)/2)),:);            
           
            for j=1:length(label)
                coded{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), t_test(t_test(:,1)==label(j),2:end), n, 0); 
            %         coded{j} = envelopeMDCoding(up(label==tLabel,:), low(label==tLabel,:), data(data(:,1)==label(j),2:end));  
                counting{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), t_test(t_test(:,1)==label(j),2:end), n, 1);
                entro{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), t_test(t_test(:,1)==label(j),2:end), n, 2);
                compressed{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), t_test(t_test(:,1)==label(j),2:end), n, 3, A_sub);
            end
            

            for j=1:length(label)
                if label(j)==tLabel
                    dataSet_env = [dataSet_env; coded{j} ];
                    dataSet_com = [dataSet_com; compressed{j} ];
                    dataSet_count = [dataSet_count; counting{j}];
                    dataSet_entro = [dataSet_entro; entro{j}];
                    auc_label_e = [auc_label_e; zeros(size(compressed{j},1),1)];
                else                    
                    dataSet_env = [dataSet_env; coded{j}(randsample(size(coded{j},1),max(fix(size(coded{j},1)/10/(length(label)-1)), 1)),:) ];
                    dataSet_com = [dataSet_com; compressed{j}(randsample(size(compressed{j},1),max(fix(size(compressed{j},1)/10/(length(label)-1)), 1)),:) ];
                    dataSet_count = [dataSet_count; counting{j}(randsample(size(counting{j},1),max(fix(size(counting{j},1)/10/(length(label)-1)), 1)),:)];
                    dataSet_entro = [dataSet_entro; entro{j}(randsample(size(entro{j},1),max(fix(size(entro{j},1)/10/(length(label)-1)), 1)),:)];
                    auc_label_e = [auc_label_e;  ones(max(fix(size(compressed{j},1)/10/(length(label)-1)), 1),1)];
                end
            end
            nzero_t = nzero_t+ mean(sum(dataSet_env(auc_label_e==0,:)~=0,2))/size(data,2);
            nzero_o = nzero_o+ mean(sum(dataSet_env(auc_label_e==1,:)~=0,2))/size(data,2);
            
            distMrx = squareform(pdist(dataSet_env));
            scores = SKNN(K,distMrx);               
            [~,~,~,AUC] = perfcurve(auc_label_e, scores, 1);           
            AUCavg_env = AUCavg_env+AUC;
            
            distMrx = squareform(pdist(dataSet_com));
            scores = SKNN(K,distMrx);                        
            [~,~,~,AUC] = perfcurve(auc_label_e, scores, 1);           
            AUCavg_com = AUCavg_com+AUC;

             distMrx = squareform(pdist(dataSet_entro));
            scores = SKNN(K,distMrx);               
            [~,~,~,AUC] = perfcurve(auc_label_e, scores, 1);           
            AUCavg_entro = AUCavg_entro+AUC;
            
             distMrx = squareform(pdist(dataSet_count));
            scores = SKNN(K,distMrx);               
            [~,~,~,AUC] = perfcurve(auc_label_e, scores, 1);           
            AUCavg_count = AUCavg_count+AUC;
        end
        auc_result = [auc_result; AUCavg_env/10  AUCavg_com/10 AUCavg_entro/10  AUCavg_count/10, nzero_t/10, nzero_o/10];
   end    
   
    figure
    ylim([0 1])
    xlim([.1 3.5])
    hold on 
    plot(.1:.2:3.5, repmat(AUCavg/100,[length(.1:.2:3.5), 1]), 'b', 'LineWidth', 2);
    plot(.1:.2:3.5, auc_result(:,1), 'g', 'LineWidth', 2);
    plot(.1:.2:3.5, auc_result(:,2), 'r', 'LineWidth', 2);
    plot(.1:.2:3.5, auc_result(:,3), 'm', 'LineWidth', 2);
    plot(.1:.2:3.5, auc_result(:,4), 'c', 'LineWidth', 2);
    plot(.1:.2:3.5, auc_result(:,5), 'k', 'LineWidth', 2);
    plot(.1:.2:3.5, auc_result(:,6), 'y', 'LineWidth', 2);
    legend('original','envelope','compressed', 'entropy', 'counting', 'target', 'other');
    xlabel('num of std. ');
    ylabel('AUC score' );
    title(['target label: ' num2str(tLabel) ' K: ' num2str(K)]); 
   
   
end
%}
