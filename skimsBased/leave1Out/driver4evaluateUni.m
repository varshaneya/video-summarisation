function [] = driver4evaluateUni()
vid = dir('../sumMe/videos/');
len = length(vid);
f=[];
r=[];
%[f_measure,recall] = evaluateUni('Cooking.mp4');
for i=3:6
    try
        [f_measure,recall] = evaluateUni(vid(i).name);
        vid(i).name
        f_measure
        recall
    catch
        continue;
    end
    f(i-6)=f_measure;
    r(i-6)=recall;
end
meanF = mean(f);
meanR = mean(r);
stdF = std(f);
stdR = std(r);
save('leave1OutUni.mat','f','r','meanF','meanR','stdR','stdF');
end
function [f_measure,recall] = evaluateUni(videoName)
global vidName;
global frCount;
global dataPath;
% global noOfParam;
global superFrames;
vidName = videoName;
noOfParam= 7;
dataPath = '../data';
tempVidName = vidName(1:length(vidName)-4);
load(fullfile(dataPath,'featuresSumMe',strcat(tempVidName,'Features.mat')),'frCount');
load(fullfile(dataPath,'GT',tempVidName),'gt_score');
load(fullfile(dataPath,'aesthetics',tempVidName),'colour','cont','quality');
load(fullfile(dataPath,'faceDetection',tempVidName),'face','person');
load(fullfile(dataPath,'staticAttention',tempVidName),'staticAttention');
load(fullfile(dataPath,'temporalAttention',tempVidName),'temporalAttention');
load(fullfile(dataPath,'superFrames',tempVidName),'superFrames');

isTraining =0;
isSubModOptimisiation =1;
isEvaluate=1;

%run('calculateInterestingnessScore');

% [allFrames,FPS] = frameReader(vidName);
% default_parameters;
% [superFrames,~] = summe_superframeSegmentation(allFrames,FPS,Params);
% display('super frame segmentation done...');
% clear allFrames;

% F1 = sfo_fn_wrapper(@int1);
% F2 = sfo_fn_wrapper(@rep1);
F3 = sfo_fn_wrapper(@uni1);
% Fs = cell(1,3);
% Fs{1,1}=F1;
% Fs{1,2}=F2;
% Fs{1,3}=F3;
% weights=[0 0 1];
% F = sfo_fn_lincomb(Fs,weights);

V = 1:frCount;
B = floor(length(gt_score(gt_score~=0)));
[sset,scores,~] = sfo_greedy_lazy(F3,V,B);

sscore=zeros(1,frCount);
tempSum=0;
scoreStruct=struct('scores',[],'sset',[]);
for i=1:length(sset)
    scoreStruct(i).scores=scores(i)-tempSum;
    scoreStruct(i).sset=sset(i);
    tempSum = scores(i);
end
[~,I] = sort([scoreStruct.sset]);
scoreStruct=scoreStruct(I);
sscore([scoreStruct.sset]) = scoreStruct.scores;

[f_measure,~,recall,~,~] = summe_evaluateSummary(sscore,tempVidName,fullfile(dataPath,'GT/'),-1,1);
end