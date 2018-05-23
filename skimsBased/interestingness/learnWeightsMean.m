function [] = learnWeightsMean()
noOfParam = 8;
numRow = 1+noOfParam+((noOfParam-1)*noOfParam/2);
wt = zeros(numRow,1,50);

for i =1:50
    wt(:,:,i) = learnWeights(noOfParam);
end

wt = mean(wt,3);
save('weights.mat','wt');
end

function [X] = learnWeights(noOfParam)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
gtPath = 'C:\Users\varshaneya\Desktop\MScDissertation\data\GT\';

videos = dir(gtPath);
A = [];
b = [];

for i = 3:length(videos)
   [tempA,tempB] = loadValues(videos(i).name,noOfParam);
   A = [A;tempA];
   b = [b;tempB];
end

X = A\b;
end

function [A,B] = loadValues(vidName,noOfParam)
dataPath  = 'C:\Users\varshaneya\Desktop\MScDissertation\data';
load(fullfile(dataPath,'GT',vidName),'gt_score','nFrames');
load(fullfile(dataPath,'aesthetics',vidName),'colour','cont','quality');
load(fullfile(dataPath,'faceDetection',vidName),'face','person');
load(fullfile(dataPath,'staticAttention',vidName),'staticAttention');
load(fullfile(dataPath,'temporalAttention',vidName),'temporalAttention');
load(fullfile(dataPath,'complexity',vidName),'imgCompl');

numCol = 1+noOfParam+((noOfParam-1)*noOfParam/2);

A = ones(100,numCol);

frNos1 = randi([1 nFrames-6],1,100);
limit = size(cont,2);

frNos2 = ceil(frNos1./5);
frNos2(frNos2>limit) = limit;

A(:,2) = colour(frNos2)';
A(:,3) = cont(frNos2)';
A(:,4) = quality(frNos2)';
A(:,5) = face(frNos1)';
A(:,6) = person(frNos1)';
A(:,7) = staticAttention(frNos1)';
A(:,8) = temporalAttention(frNos2)';
A(:,9) = imgCompl(frNos1)';

A(:,10) = colour(frNos2)' .* cont(frNos2)';
A(:,11) = colour(frNos2)' .* quality(frNos2)';
A(:,12) = colour(frNos2)' .* face(frNos1)';
A(:,13) = colour(frNos2)' .* person(frNos1)';
A(:,14) = colour(frNos2)' .* staticAttention(frNos1)';
A(:,15) = colour(frNos2)' .* temporalAttention(frNos2)';
A(:,16) = colour(frNos2)' .* imgCompl(frNos1)';

A(:,17) = cont(frNos2)' .* quality(frNos2)';
A(:,18) = cont(frNos2)' .* face(frNos1)';
A(:,19) = cont(frNos2)' .* person(frNos1)';
A(:,20) = cont(frNos2)' .* staticAttention(frNos1)';
A(:,21) = cont(frNos2)' .* temporalAttention(frNos2)';
A(:,22) = cont(frNos2)' .* imgCompl(frNos1)';

A(:,23) = quality(frNos2)' .* face(frNos1)';
A(:,24) = quality(frNos2)' .* person(frNos1)';
A(:,25) = quality(frNos2)' .* staticAttention(frNos1)';
A(:,26) = quality(frNos2)' .* temporalAttention(frNos2)';
A(:,27) = quality(frNos2)' .* imgCompl(frNos1)';

A(:,28) = face(frNos1)' .* person(frNos1)';
A(:,29) = face(frNos1)' .* staticAttention(frNos1)';
A(:,30) = face(frNos1)' .* temporalAttention(frNos2)';
A(:,31) = face(frNos1)' .* imgCompl(frNos1)';

A(:,32) = person(frNos1)' .* staticAttention(frNos1)';
A(:,33) = person(frNos1)' .* temporalAttention(frNos2)';
A(:,34) = person(frNos1)' .* imgCompl(frNos1)';

A(:,35) = staticAttention(frNos1)' .* temporalAttention(frNos2)';
A(:,36) = staticAttention(frNos1)' .* imgCompl(frNos1)';

A(:,37) = temporalAttention(frNos2)'.*imgCompl(frNos1)';

B = gt_score(frNos1);
end

% numCol = 1+noOfParam+((noOfParam-1)*noOfParam/2);
% A = ones(2500,numCol);
% b = zeros(2500,1);