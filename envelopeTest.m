function [ accuracy, bestC ] = envelopeTest( trainData, trainLabel, testData, testLabel, mode, ratio )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    label = unique(trainLabel);   
    C=2.^(-6:2);        
    A = [];
    tic
    %

        [bestStdList, clusterNum]= stdEntropy_multi([trainLabel trainData ], 7);
%         bestStdList = [bestStdList; stdNonzero([trainLabel trainData ], label(i), 7)];

    %}
    if nargin < 6
        ratio=1;
    end

    if mode ==-1        %----------------- raw data testing -------------------- 
        [~, ~, bestC, ~] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, ratio, C);           
        model = svmtrain(trainLabel, trainData, ['-t 0 -c ' sprintf('%f', bestC)]);      
        [~, accuracy, ~] = svmpredict(testLabel, testData, model); 

    elseif mode==0        % -------------------full sparse form-------------------
        [~, ~, bestC, ~] = envelopeTuning([trainLabel trainData ], {bestStdList, clusterNum}, 0, mode, ratio, C);
%{        
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);        
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode); 
%}
        [m_c, s_c] = envelopeBuild_multi(trainData, trainLabel, clusterNum);                   
        train1=envelopeEncode_multi(m_c,s_c, trainData, bestStdList, mode);
        test1=envelopeEncode_multi(m_c, s_c, testData, bestStdList, mode); 
%}
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 

    elseif mode==1      % ----------------counting----------------
        [~, ~, bestC, ~] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, ratio, C);
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);       
        
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode); 
        
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 
        
        
    elseif mode==2      %--------------------entropy-------------------
        [~, ~, bestC, ~] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, ratio, C);
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);       
        
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode); 
        
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 

        
    elseif mode==3      %-------------------compressed-----------------
        [~, ~, bestC, A] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, ratio, C);
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);       
        
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode, A);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode, A); 
        
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model);                
    end    
    toc
end

