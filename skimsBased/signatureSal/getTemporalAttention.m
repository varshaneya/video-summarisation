function [temporalAttention,outMapMean] = getTemporalAttention(vidName)
obj = VideoReader(vidName); %// Place your video path here
% width = obj.Width; %// Get width and height of the video
% height = obj.Height;
height = 48;
width = 64;
frm1 = uint8(zeros(height,width,3));
outMap = zeros(height,width,3);
numChannels = 3;
k=1;
count = 0;
% numberOfFrames = obj.Duration*obj.FrameRate; %// Calculate total number of frames to save
% 
% outMapMean = zeros(height,width,floor(numberOfFrames));
% temporalAttention = zeros(1,totalFrames);

while hasFrame(obj)
    frm2 = imresize(readFrame(obj),[height width]); %// Read frame
    if k == 1
        temporalAttention(count+1) = 0;
        frm1 = frm2;
        count = count + 1;
        k = k+1;
        continue;
    
    elseif mod(k,5) == 0
       for i =1:numChannels
        outMap(:,:,i) = temporalAttentionValue(frm1(:,:,i),frm2(:,:,i));
        end
%   outMapMean(:,:,count) = mean(outMap,3);
        outMapMean = mean(outMap,3);
        temporalAttention(count) = mean(mean(outMapMean));
        frm1 = frm2; 
        count = count + 1;
    end
    k = k+1;
end

temporalAttention = temporalAttention ./ max(temporalAttention);
end