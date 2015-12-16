function [ accuracy, bestC ] = envelopeTest( trainData, trainLabel, testData, testLabel, mode, A )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
    %varname=@(x) inputname(1);
    label = unique(trainLabel);   
    C=2.^(-10:0);        

%     [bestStdList] = stdEntropy([trainLabel trainData ], 3);
     [bestStdList] = stdNonzero([trainLabel trainData ], 3);

    if nargin < 6 && mode~=3
        A = [];
    end

    if mode ==-1        %----------------- raw data testing -------------------- 
        [~, ~, bestC] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, C, A);   
        tic
        model = svmtrain(trainLabel, trainData, ['-t 0 -c ' sprintf('%f', bestC)]);              
        [~, accuracy, ~] = svmpredict(testLabel, testData, model); 
        toc

    elseif mode==0        % -------------------full sparse form-------------------
        [~, ~, bestC] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, C, A);
        tic
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);        
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode); 
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 
        toc

    elseif mode==1      % ----------------counting----------------
        [~, ~, bestC] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, C, A);       
        tic
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);               
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode); 
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 
        toc
        
    elseif mode==2      %--------------------zero ratio-------------------
        [~, ~, bestC] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, C, A);
        tic        
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);               
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode);         
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model); 
        toc
        
    elseif mode==3      %-------------------compressed-----------------
        [~, ~, bestC] = envelopeTuning([trainLabel trainData ], bestStdList, 0, mode, C, A);
        tic
        [m_c, s_c] = envelopeBuild(trainData, trainLabel);              
        train1=envelopeEncode(m_c,s_c, trainData, bestStdList, mode, A);      
        test1=envelopeEncode(m_c, s_c, testData, bestStdList, mode, A); 
        model = svmtrain(trainLabel, train1, ['-t 0 -c ' sprintf('%f', bestC)]);          
        [~, accuracy, ~] = svmpredict(testLabel, test1, model);                
        toc
    end    
    

%      text(-2, 50, [' test result = ' num2str(accuracy(1))]); 
    
end

