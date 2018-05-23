function [f_measure,recall] = evaluationSummary(vidName)
dataPath = '../data';
load(fullfile(dataPath,'featuresSumMe',strcat(vidName,'Features.mat')),'frCount');
load(strcat(fullfile(dataPath,'GT',vidName),'.mat'),'gt_score');

frameNos=randi([1 frCount],floor(length(gt_score(gt_score~=0))),1);
sscore=zeros(frCount,1);
sscore(frameNos)=floor(length(gt_score(gt_score~=0)))/frCount;
[f_measure,~,recall,~,~] = summe_evaluateSummary(sscore,vidName,fullfile(dataPath,'GT/'),-1,1);
end