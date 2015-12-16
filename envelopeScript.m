function envelopeScript(data, Lambda_list)
%{
bestStdList = [];
label = unique(data(:,1));   

for i=1:length(label)
    bestStdList = [bestStdList; stdEntropy(data,label(i), Lambda_list)];
end

%}
% ---------  raw data ---------
C=2.^(-10:0);
envelopeTuning(data, bestStdList, 5, -1, 1, C);
%{
% ---------  1/0/-1 ---------
C=2.^(-11:-3);
envelopeTuning(data, bestStdList, 5, 0, 1, C);
%
% ---------  counting ---------
C=2.^(-15:-5);
envelopeTuning(data, bestStdList, 5, 1, 1, C);
%
% ---------  entropy ---------
C=2.^(-3:3);
envelopeTuning(data, bestStdList, 5, 2, 1, C);
%
% ---------  compressed 10% ---------
C=2.^(-10:-2);
envelopeTuning(data, bestStdList, 5, 3, 0.1, C);
%
% ---------  compressed 20% ---------
C=2.^(-12:-2);
envelopeTuning(data, bestStdList, 5, 3, 0.2, C);

% ---------  compressed 50% ---------
C=2.^(-12:-2);
envelopeTuning(data, bestStdList, 5, 3, 0.5, C);
%}

end

trainData = importdata('E:\dataSets\datasets_ucr\50words\default\50words_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\50words\default\50words_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Adiac\default\Adiac_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Adiac\default\Adiac_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Beef\default\Beef_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Beef\default\Beef_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\CBF\default\CBF_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\CBF\default\CBF_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\ChlorineConcentration\default\ChlorineConcentration_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\ChlorineConcentration\default\ChlorineConcentration_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\CinC_ECG_torso\default\CinC_ECG_torso_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\CinC_ECG_torso\default\CinC_ECG_torso_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Coffee\default\Coffee_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Coffee\default\Coffee_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Cricket_X\default\Cricket_X_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Cricket_X\default\Cricket_X_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Cricket_Y\default\Cricket_Y_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Cricket_Y\default\Cricket_Y_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Cricket_Z\default\Cricket_Z_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Cricket_Z\default\Cricket_Z_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\DiatomSizeReduction\default\DiatomSizeReduction_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\DiatomSizeReduction\default\DiatomSizeReduction_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\ECG200\default\ECG200_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\ECG200\default\ECG200_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\ECGFiveDays\default\ECGFiveDays_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\ECGFiveDays\default\ECGFiveDays_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\FaceAll\default\FaceAll_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\FaceAll\default\FaceAll_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\FaceFour\default\FaceFour_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\FaceFour\default\FaceFour_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\FacesUCR\default\FacesUCR_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\FacesUCR\default\FacesUCR_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Fish\default\Fish_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Fish\default\Fish_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Gun_Point\default\Gun_Point_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Gun_Point\default\Gun_Point_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Haptics\default\Haptics_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Haptics\default\Haptics_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\InlineSkate\default\InlineSkate_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\InlineSkate\default\InlineSkate_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\ItalyPowerDemand\default\ItalyPowerDemand_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\ItalyPowerDemand\default\ItalyPowerDemand_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Lighting2\default\Lighting2_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Lighting2\default\Lighting2_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Lighting7\default\Lighting7_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Lighting7\default\Lighting7_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\MALLAT\default\MALLAT_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\MALLAT\default\MALLAT_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\MedicalImages\default\MedicalImages_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\MedicalImages\default\MedicalImages_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\MoteStrain\default\MoteStrain_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\MoteStrain\default\MoteStrain_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\OliveOil\default\OliveOil_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\OliveOil\default\OliveOil_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\OSULeaf\default\OSULeaf_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\OSULeaf\default\OSULeaf_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\SonyAIBORobotSurface\default\SonyAIBORobotSurface_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\SonyAIBORobotSurface\default\SonyAIBORobotSurface_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\SonyAIBORobotSurfaceII\default\SonyAIBORobotSurfaceII_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\SonyAIBORobotSurfaceII\default\SonyAIBORobotSurfaceII_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\SwedishLeaf\default\SwedishLeaf_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\SwedishLeaf\default\SwedishLeaf_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Symbols\default\Symbols_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Symbols\default\Symbols_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\synthetic_control\default\synthetic_control_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\synthetic_control\default\synthetic_control_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Trace\default\Trace_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Trace\default\Trace_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\Two_Patterns\default\Two_Patterns_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\Two_Patterns\default\Two_Patterns_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\TwoLeadECG\default\TwoLeadECG_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\TwoLeadECG\default\TwoLeadECG_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\uWaveGestureLibrary_X\default\uWaveGestureLibrary_X_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\uWaveGestureLibrary_X\default\uWaveGestureLibrary_X_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\uWaveGestureLibrary_Y\\default\uWaveGestureLibrary_Y_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\uWaveGestureLibrary_Y\default\uWaveGestureLibrary_Y_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\uWaveGestureLibrary_Z\default\uWaveGestureLibrary_Z_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\uWaveGestureLibrary_Z\default\uWaveGestureLibrary_Z_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\wafer\default\wafer_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\wafer\default\wafer_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\WordsSynonyms\default\WordsSynonyms_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\WordsSynonyms\default\WordsSynonyms_TEST');

trainData = importdata('E:\dataSets\datasets_ucr\yoga\default\yoga_TRAIN');
testData = importdata('E:\dataSets\datasets_ucr\yoga\default\yoga_TEST');



[ accuracy, bestC ] = envelopeTest( trainData(:,2:end), trainData(:,1), testData(:,2:end), testData(:,1), 0, 1);
text(-2, 55, 'ECG200 multi'); 

[ accuracy, bestC ] = envelopeTest_multi( trainData(:,2:end), trainData(:,1), testData(:,2:end), testData(:,1), 0, 1);
text(-2, 55, 'ECG200 multi'); 





eTime = [11.51 0.6023; 4.53 0.4398; 0.0126 0.0332; 0.0698 0.9357; 1.0685 5.0077; 1.057 1.6099; 0.0033 0.0316; 1.6088 0.4889; 1.3345 0.4952; 1.2853 0.523; 0.0402 0.3196; 0.0085 0.108; 0.033 0.8758; 5.6126 2.0271; 0.0189 0.0954; 2.7116 2.1556; 0.2775 0.2124; 0.0081 0.1539; 0.4733 0.5662; 1.3241 1.1128; 0.03012 1.0661; 0.01267 0.06734; 0.0676 0.07963; 3.5529 2.6397; 0.7332 0.6842; 0.04191 1.286; 0.0133 0.0345; 0.2531 0.2867; 0.0209 0.622; 0.0328 0.9986; 2.004 0.7071; 0.2655 1.0755; 0.1453 0.3193; 0.0368 0.1112; 1.2698 1.1764; 15.43 10.7214; 13.91 11.2867; 14.01 11.0878; 1.95 11.461; 4.89 0.7395; 1.16 4.4297];
% eTime = log10(1./eTime)
h=area([0:16 ], [0:16],  'FaceColor', [.9 .9 .9], 'EdgeColor', 'none')
hold on
scatter(eTime(:,1), eTime(:,2))
title('Execution time (training+ testing)')
xlabel('envelope (Sec.)')
ylabel('KNN+ED (Sec.)')

%}