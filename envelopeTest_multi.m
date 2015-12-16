function [ accuracy, bestC ] = envelopeTest_multi( trainData, trainLabel, testData, testLabel, mode, A )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %varname=@(x) inputname(1);
    label = unique(trainLabel);   
    C=2.^(-8:2);        
    


    [bestStdList, centroids]= stdEntropy_multi([trainLabel trainData ], 7);
%     [bestStdList, centroids]= stdNonzero_multi([trainLabel trainData ], 7);
    

    if nargin < 6 && mode~=3
        A = [];
	else
		A =  randn( size(trainData,2)*length(label) , size(trainData,2)*length(label))/ sqrt(size(trainData,2)*length(label) );
		% randomly select rows according to the compression ratio you need
    end

    if mode ==-1        %----------------- raw data testing -------------------- 
        [~, ~, bestC] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, C, A);     
        tic
        model = svmtrain(trainLabel, trainData, ['-t 0 -c ' sprintf('%f', bestC)]);      
        [~, accuracy, ~] = svmpredict(testLabel, testData, model); 
        toc

    elseif mode==0        % -------------------full sparse form-------------------
        [~, ~, bestC] = envelopeTuning_multi([trainLabel trainData ], {bestStdList, centroids}, 10, mode, C, A);
        tic
        [m_c, s_c] = envelopeBuild_multi(trainData, trainLabel, centroids);                   
        train1=envelopeEncode_multi(m_c,s_c, trainData, bestStdList, mode);
        test1=envelopeEncode_multi(m_c, s_c, testData, bestStdList, mode); 
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 
        toc
        
    elseif mode==1      % ----------------counting----------------
        [~, ~, bestC] = envelopeTuning_multi([trainLabel trainData ], bestStdList, 0, mode, C, A);
        tic
        [m_c, s_c] = envelopeBuild_multi(trainData, trainLabel, centroids);                   
        train1=envelopeEncode_multi(m_c,s_c, trainData, bestStdList, mode);
        test1=envelopeEncode_multi(m_c, s_c, testData, bestStdList, mode); 
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 
        toc
        
    elseif mode==2      %--------------------entropy-------------------
        [~, ~, bestC] = envelopeTuning_multi([trainLabel trainData ], bestStdList, 0, mode, C, A);
        tic
        [m_c, s_c] = envelopeBuild_multi(trainData, trainLabel, centroids);                   
        train1=envelopeEncode_multi(m_c,s_c, trainData, bestStdList, mode);
        test1=envelopeEncode_multi(m_c, s_c, testData, bestStdList, mode);         
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 
        toc
        
    elseif mode==3      %-------------------compressed-----------------
        [~, ~, bestC] = envelopeTuning_multi([trainLabel trainData ], bestStdList, 0, mode, C, A);
        tic
        [m_c, s_c] = envelopeBuild_multi(trainData, trainLabel, centroids);                   
        train1=envelopeEncode_multi(m_c,s_c, trainData, bestStdList, mode);
        test1=envelopeEncode_multi(m_c, s_c, testData, bestStdList, mode);         
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model);                
        toc
    end        
    text(-2, 50, [' test result = ' num2str(accuracy(1))]); 
end

