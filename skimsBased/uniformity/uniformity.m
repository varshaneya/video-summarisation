function [uni] = uniformity(vidName)
%vidName = 'Cooking';
dataPath = '../../data';
vidPath = '../../sumMe/videos/';
obj = VideoReader(strcat(vidPath,vidName));

vidName = vidName(1:length(vidName)-4);
load(fullfile(dataPath,'superFrames',strcat(vidName,'.mat')),'superFrames');


frCount = floor(obj.FrameRate * obj.Duration);
%load(fullfile(dataPath,'featuresSumMe',strcat(vidName,'Features.mat')),'frCount');

sum2 = 0;
sum1 =0;
noSeg = size(superFrames,1);
temp = zeros(1,noSeg);
frNos = double(1:frCount);
frNos = frNos ./norm(frNos);

phantom = median(frNos);

for j=1:noSeg
        lb  = superFrames(j,1); 
        ub = superFrames(j,2);
        
        if ub > frCount
            ub = frCount;
        end
        
        midArray(j) = mean([frNos(lb:ub) phantom]);
        %midArray(j) = floor(mean(lb:ub));
end

for i=1:frCount
    for j=1:noSeg
        temp(j) = (norm(midArray(j)-double(i/frCount),2))^2;
    end
    sum1 = sum1 + norm(phantom-double(i/frCount),2)^2;
    sum2 = sum2 + min(temp);
end

uni = sum1-sum2;
save(strcat('../../data/uniformity/',vidName,'.mat'),'uni');
end