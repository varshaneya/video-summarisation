tic
global vidName;
global frCount;
global dataPath;
global noOfParam;
global interestingness;
global superFrames;

noOfParam= 8;
vidName = 'drone.mp4';
dataPath = '../data';

load(fullfile(dataPath,'featuresSumMe',strcat(vidName(1:length(vidName)-4),'Features.mat')),'frCount');

try
    load(fullfile(dataPath,'aesthetics',vidName(1:length(vidName)-4)),'colour','cont','quality');
catch
    [quality,cont,colour,~] = contrastEdgesAndColourfulness(vidName);
    save(fullfile(dataPath,'aesthetics',vidName(1:length(vidName)-4),'colour','cont','quality'));
end
display('aesthetics done...');

try
    load(fullfile(dataPath,'faceDetection',vidName(1:length(vidName)-4)),'face','person','frCount');
catch
    [face,person,~] = faceAndPerson(vidName);
    save(fullfile(dataPath,'faceDetection',vidName(1:length(vidName)-4)),'face','person','frCount');
end
display('faces and persons recognised...');

try
    load(fullfile(dataPath,'staticAttention',vidName(1:length(vidName)-4)),'staticAttention');
catch
    [staticAttention,~] = getStaticAttention(vidName);
    save(fullfile(dataPath,'staticAttention',vidName(1:length(vidName)-4)),'staticAttention');
end
display('static attention done...');

try
    load(fullfile(dataPath,'temporalAttention',vidName(1:length(vidName)-4)),'temporalAttention');
catch
    [temporalAttention,~] = getTemporalAttention(vidName);
    save(fullfile(dataPath,'temporalAttention',vidName(1:length(vidName)-4)),'temporalAttention');
end
display('temporal attention done...');

try
    load(fullfile(dataPath,'complexity',vidName(1:length(vidName)-4)),'imgCompl');
catch
    [imgCompl]= imageComplexity(vidName);
    save(fullfile(dataPath,'complexity',vidName(1:length(vidName)-4)),'imgCompl');
end
display('image complexity done...');

isTraining =0;
isSubModOptimisiation =1;

run('calculateInterestingnessScore');

try
    load(fullfile(dataPath,'superFrames',vidName(1:length(vidName)-4)),'superFrames');
catch
    [allFrames,FPS] = frameReader(vidName);
    default_parameters;
    [superFrames,~] = summe_superframeSegmentation(allFrames,FPS,Params);
    display('super frame segmentation done...');
    save(fullfile(dataPath,'superFrames',vidName(1:length(vidName)-4)),'superFrames');
    clear allFrames;
end

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
B = floor(frCount/4);
[sset,scores,evalNum] = sfo_greedy_lazy(F,V,B);

s = sort(sset);
newVidName = strcat('summarySubm',vidName(1:length(vidName)-4),'.avi');
vidW = VideoWriter(newVidName);
open(vidW);
vidR = VideoReader(vidName);
k=1;
i=1;
while hasFrame(vidR)
frame = readFrame(vidR);
if i<= length(s)&& k == s(i)
writeVideo(vidW,frame);
i = i+1;
end
if ~hasFrame(vidR)
break;
end
k = k+1;
end
close(vidW);
toc