function [] = generateIntSummaries(vidName)
tic
%vidName = 'drone.mp4';
datapath='../data';
[quality,cont,colour,~] = contrastEdgesAndColourfulness(vidName);
display('aesthetics done...');
[face,person,~] = faceAndPerson(vidName);
display('faces and persons recognised...');
[staticAttention,~] = getStaticAttention(vidName);
display('static attention done...');
[temporalAttention,~] = getTemporalAttention(vidName);
display('temporal attention done...');
[imgCompl]= imageComplexity(vidName);
display('image complexity done...');
vidObj = VideoReader(vidName);
frCount = floor(vidObj.Duration * vidObj.FrameRate);

 try
     load(strcat(fullfile(dataPath,'superFrames',vidName(1:length(vidName)-4)),'.mat'),'superFrames');
 catch
    display('superframes segments not found.. so calculating');
    [allFrames,FPS] = frameReader(vidName);
    default_parameters;
    [superFrames,~] = summe_superframeSegmentation(allFrames,FPS,Params);
    clear allFrames;
    display('super frame segmentation done...');
end

% segInterestingness = calculateInterestingnessScore(vidName,0);
isTraining = 0;
isSubModOptimisiation=0;

run('calculateInterestingnessScore');
[~, amount] = knapsack(superFrames(:,2)-superFrames(:,1)+1,ceil(segInterestingness),ceil(frCount/5));
intSeg = ind2sub(size(amount),find(amount>0));

run('intSum');

display('summary generated...');
toc
end