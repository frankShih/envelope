
% injecting white noise
noisyTrain = zeros(size(trainData));
noisyTest = zeros(size(testData));
noise = 0:5:100; 
acc_all = zeros(size(noise));
 
for i=1:10
    acc_temp = [];
for n =noise    
    noisyTrain(:,1) = trainData(:,1);
    noisyTest(:,1) = testData(:,1);

    for j=1:size(trainData,1)
        noisyTrain(j,2:end) = awgn(trainData(j,2:end), n , 'measured'); 
    end
    for j=1:size(testData,1)        
        noisyTest(j,2:end) = awgn(testData(j,2:end), n , 'measured'); 
    end
%     envelopeBuild( noisyTrain(:,2:end), noisyTrain(:,1));
    [ accuracy, bestC ] = envelopeTest( noisyTrain(:,2:end), noisyTrain(:,1), noisyTest(:,2:end), noisyTest(:,1), 0);
    acc_temp = [acc_temp accuracy];
    
end
acc_all = acc_all + acc_temp(1,:);
end
figure
hold on
plot(noise, acc_all(1,:)/10)

xlabel( 'SNR')
ylabel( 'accuracy')
ylim([1 100])
title('Robustness to noise')


%{
% add random large noises
noisyTrain = zeros(size(trainData));
noisyTest = zeros(size(testData));
noise = 0:0.02:.5; 
acc_all = zeros(size(noise));   
 
for i=1:10
    acc_temp = [];
for n =noise    
    noisyTrain(:,1) = trainData(:,1);
    noisyTest(:,1) = testData(:,1);

    for j=1:size(trainData,1)
        ind = randsample(size(trainData,2)-1, fix((size(trainData,2)-1)*n))+1;
        noisyTrain(j,2:end) = trainData(j,2:end);
        if binornd(1,0.5)==1
            noisyTrain(j,ind) = noisyTrain(j,ind) + 3*std(noisyTrain(j,:));
        else
            noisyTrain(j,ind) = noisyTrain(j,ind) - 3*std(noisyTrain(j,:));
        end
    end
    for j=1:size(testData,1)
        ind = randsample(size(testData,2)-1, fix((size(testData,2)-1)*n))+1;
        noisyTest(j,2:end) = testData(j,2:end); 
        if binornd(1,0.5)==1
            noisyTest(j,ind) = noisyTest(j,ind) + 3*std(noisyTest(j,:));
        else
            noisyTest(j,ind) = noisyTest(j,ind) - 3*std(noisyTest(j,:));
        end
    end
%     envelopeBuild( noisyTrain(:,2:end), noisyTrain(:,1));
    [ accuracy, bestC ] = envelopeTest( noisyTrain(:,2:end), noisyTrain(:,1), noisyTest(:,2:end), noisyTest(:,1), 0);
    acc_temp = [acc_temp accuracy];
    
end
acc_all = acc_all + acc_temp(1,:);
end
figure
hold on
plot(noise, acc_all(1,:)/10)

ylabel( 'accuracy')
ylim([1 100])
title('Robustness to noise')


%}

