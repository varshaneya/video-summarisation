function [rep] = representativeness(vidName)
vidName = vidName(1:length(vidName)-4);
%vidName = 'Cooking';
dataPath = '../../data';
load(fullfile(dataPath,'superFrames',strcat(vidName,'.mat')),'superFrames');
load(fullfile(dataPath,'featuresSumMe',strcat(vidName,'Features.mat')),'allFeatures','frCount');

sum2 = 0;
sum1 =0;
noSeg = size(superFrames,1);
temp = zeros(1,noSeg);

for i=1:size(allFeatures,1)
    allFeatures(i,:) = allFeatures(i,:)/norm(allFeatures(i,:),2);
end
phantom = median(allFeatures);

medArray=zeros(noSeg,size(allFeatures,2));

for j=1:noSeg
    lb  = superFrames(j,1); 
    ub = superFrames(j,2);
        
    if ub > size(allFeatures,1)
        ub = size(allFeatures,1);
    end
        
    medArray(j,:) = median([allFeatures(lb:ub,:);phantom]);
end

for i=1:frCount
    for j=1:noSeg
        temp(j) = (norm(medArray(j,:)-allFeatures(i,:),2))^2;
    end
    sum1 = sum1 + norm(phantom-allFeatures(i,:),2)^2;
    sum2 = sum2 + min(temp);
end

rep = sum1-sum2;
save(strcat('../../data/representativeness/',vidName,'.mat'),'rep');
end