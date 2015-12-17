%
% using knn distance as score to calculate AUC
function [ stdBest, best ] = stdTuning(data, tLabel )
% finding best STD for envelope
% [input]   data - first col. as label
%              tLabel - target label to build envelope
% [output]  
% 		best std.
addpath E:\Dropbox\DM_ML\Toolbox\libsvm-3.19\matlab
    label = unique(data(:,1));
    auc_result = [];
    stdList = .1:.1:3;
    for n = stdList
        n
        AUCavg_e=0;         nzero = 0;
        for i=1:10
            dataSet_e = [];
            auc_label_e = [];
            [m, s] = envelopeBuild(data(:,2:end),data(:,1));
            coded = cell(length(label), 1);
			
            for j=1:length(label)
                coded{j} = envelopeEncode(m(label==tLabel,:), s(label==tLabel,:), data(data(:,1)==label(j),2:end), n); 
            end

            for j=1:length(label)
                if label(j)==tLabel
                    dataSet_e = [dataSet_e; coded{j} ];
                    auc_label_e = [auc_label_e; ones(size(coded{j},1),1)*label(j)];
                else
                    dataSet_e = [dataSet_e; coded{j}(randsample(size(coded{j},1),fix(size(coded{j},1)/10/(length(label)-1))),:) ];
                    auc_label_e = [auc_label_e;  ones(fix(size(coded{j},1)/10/(length(label)-1)),1)*label(j)];
                end
            end
            nzero = nzero+ mean(sum(dataSet_e(1:length(auc_label_e),:)~=0,2))/size(data,2);
            distMrx = squareform(pdist(dataSet_e));
            scores = SKNN(3,distMrx);
            [~,~,~,AUC] = perfcurve(auc_label_e, 1./(scores+1), tLabel);
            AUCavg_e = AUCavg_e+AUC;

        end
        auc_result = [auc_result; AUCavg_e/10 nzero/10];
    end
    [best, ind] = max(auc_result(:,1));
    stdBest = stdList(ind);
    nzeroBest = auc_result(ind,2);

    figure
    ylim([0 1])
    xlim([stdList(1) stdList(end)])
    hold on 
    
    plot(.1:.1:3, auc_result(:,1), 'g', 'LineWidth', 2);    
    plot(.1:.1:3, auc_result(:,2), 'm', 'LineWidth', 2);    
    legend('AUC', 'nonzero ratio')
    xlabel('multiple of std. ');
%     ylabel('AUC score' );
    title(['target label: ' num2str(tLabel) ]); 
    
end

%{


function [ stdBest ] = stdTuning(data)
% finding best std. based on AUC (using sparseness as score)
addpath E:\Dropbox\DM_ML\Toolbox\libsvm-3.19\matlab
    label = unique(data(:,1));
    stdBest = [];
    stdList = .1:.1:3;
	
    stdChosen = stdNonzero(data, 3);
    for i=1:length(label)
        temp_AUC=[];
        tempData = data(:,2:end);
        tempLabel = data(:,1);
        tempLabel(tempLabel~=label(i))=-999;
        tempLabel(tempLabel==label(i))=999;
        for n = stdList
            [ mc, sc ] = envelopeBuild( tempData, tempLabel);
            tempData = envelopeEncode(mc(2,:), sc(2,:),  tempData, n, 0);
            sparseness = sum(tempData==0,2);
            [~,~,~,AUC] = perfcurve(tempLabel, sparseness, 999);     
            temp_AUC = [temp_AUC AUC];
        end
        [~, ind] = max(temp_AUC);
        stdBest = [stdBest stdList(ind)];

        figure
        ylim([0 1])
        xlim([stdList(1) stdList(end)])
        hold on 

        plot(.1:.1:3, temp_AUC, 'g', 'LineWidth', 2);    
        text(stdChosen(i)-.7, .55, ['chosen std. = ' num2str(stdChosen(i))]); 
        legend('AUC') 
        xlabel('multiple of std. ');
    %     ylabel('AUC score' );
    end
end
%}






