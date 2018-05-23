function [allFrames,FPS] = frameReader(vidName)
obj = VideoReader(vidName); %// Place your video path here
FPS = obj.FrameRate;
width = floor(obj.Width/4); %// Get width and height of the video
height = floor(obj.Height/4);
numChannels = 3; %// Get number of channels.  Assuming RGB - Change if necessary
numberOfFrames = obj.Duration*obj.FrameRate; %// Calculate total number of frames to save

%// Determine total number of frames to save
totalFrames = floor(numberOfFrames);

allFrames = zeros(height,width,numChannels,totalFrames,'uint8'); %// Pre-allocate frames matrix

frCount = 0; %// Keeps track of where to place frame
while hasFrame(obj)
    allFrames(:,:,:,frCount+1) = imresize(readFrame(obj),[height width]); %// Read frame
    frCount = frCount + 1;
end
%save(strcat(vidName(1:length(vidName)-4),'.mat'),'allFrames','frCount','-v7.3');
end