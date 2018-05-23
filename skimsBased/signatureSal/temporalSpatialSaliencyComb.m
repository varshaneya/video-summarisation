function [] = temporalSpatialSaliencyComb()
fromPath = 'C:\Users\varshaneya\Desktop\MScDissertation\sumMe\videos\';
%loadPath = 'C:\Users\varshaneya\Desktop\MScDissertation\data\staticAttention\';
toPath = 'C:\Users\varshaneya\Desktop\MScDissertation\data\temporalAttention\';
videos = dir(fromPath);

for i = 2:size(videos,1)
   [temporalAttention,~] = getTemporalAttention(strcat(fromPath,videos(i).name));
   temporalAttention = temporalAttention ./ max(temporalAttention);
%    attn = attentionCombined(videos(i).name,fromPath,loadPath);
   temp = strcat(toPath,videos(i).name);
   newName = temp(1:size(temp,2)-4);
   save(strcat(newName,'.mat'),'temporalAttention');
end
end

function [attention] = attentionCombined(vidName,fromPath,loadPath)

[temporalAttention,outMap] = getTemporalAttention(strcat(fromPath,vidName));
temp = strcat(loadPath,vidName);
newName = temp(1:size(temp,2)-4);
load(strcat(newName,'.mat'));%loads the variable staticAttention
gamma = 0.2;
attention = zeros(1,size(staticAttention,2));
for i = 1:size(staticAttention,2)
    d = max(max(outMap(:,:,i))) - min(min(outMap(:,:,i)));
    wT = d * exp(1-d);
    wS = 1 - wT;
    W = weight(wS,wT);
    wVec = [wS,wT];
    aVec = [staticAttention(1,i),temporalAttention(1,i)];
    dp = dot(wVec,aVec);
    attention(1,i) = (dp + (abs((2 * wS * staticAttention(1,i)) - dp) + abs((2 * wT * temporalAttention(1,i)) - dp))/(2 * (1 + gamma)))/W;
end
end

function [wt] = weight(wS,wT)
gamma = 0.2;
wt = 1 +(abs(1-(2*wS)) + abs(1-(2*wT)))/(2*(1 + gamma));
end