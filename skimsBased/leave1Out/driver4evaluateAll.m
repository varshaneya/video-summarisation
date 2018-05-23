function [] = driver4evaluateAll()
vid = dir('../sumMe/videos/');
len = length(vid);
f=[];
r=[];
videoName{1,1}='St Maarten Landing.mp4';
videoName{1,2}='Jumps.mp4';
videoName{1,3}='Fire Domino.mp4';
videoName{1,4}='playing_ball.mp4';
videoName{1,5}='Cooking.mp4';
videoName{1,6}='Playing_on_water_slide.mp4';
videoName{1,7}='car_over_camera.mp4';
videoName{1,8}='paluma_jump.mp4';
videoName{1,9}='Statue of Liberty.mp4';
videoName{1,10}='Scuba.mp4';
leaveOut=[21 14 13 27 10 18 25 26 22 20];
global vidName;

for i=1:10
    try
        vidName = videoName{1,i};
        [f_measure,recall] = evaluateAll(leaveOut(i));
        display(videoName{1,i});
        f_measure
        recall
    catch ME
        ME
        continue;
    end
    f(i)=f_measure;
    r(i)=recall;
end
% global vidName;
% %vidName = 'Cooking.mp4';
% %[f_measure,recall] = evaluateAll(11);
% for i=7:len
%     try
%         tic
%         vidName = vid(i).name;
%         [f_measure,recall] = evaluateAll(i);
%         vid(i).name
%         f_measure
%         recall
%         toc
%     catch ME
%         ME
%         continue;
%     end
%     f(i-6)=f_measure;
%     r(i-6)=recall;
% end
meanF = mean(f);
meanR = mean(r);
stdF=std(f);
stdR=std(r);
save('leave1OutAll.mat','f','r','meanF','meanR','stdF','stdR');
end
function [f_measure,recall] = evaluateAll(leaveOut)
global frCount;
global dataPath;
global noOfParam;
global interestingness;
global superFrames;
global vidName;

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

run('calculateInterestingnessScore');

F1 = sfo_fn_wrapper(@int1);
F2 = sfo_fn_wrapper(@rep1);
F3 = sfo_fn_wrapper(@uni1);
Fs = cell(1,3);
Fs{1,1}=F1;
Fs{1,2}=F2;
Fs{1,3}=F3;
weights=[0.975 0.0125 0.0125];
F = sfo_fn_lincomb(Fs,weights);

V = 1:frCount;
B = floor(length(gt_score(gt_score~=0)));
[sset,scores,~] = sfo_greedy_lazy(F,V,B);

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
