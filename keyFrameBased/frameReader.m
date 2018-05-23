function allFrames = frameReader(vidName)
obj = VideoReader(vidName); %// Place your video path here
width = obj.Width; %// Get width and height of the video
height = obj.Height;
numChannels = 3; %// Get number of channels.  Assuming RGB - Change if necessary
numberOfFrames = obj.Duration*obj.FrameRate; %// Calculate total number of frames to save

%// Determine total number of frames to save
totalFrames = floor(numberOfFrames/5);

allFrames = zeros(height,width,numChannels,totalFrames,'uint8'); %// Pre-allocate frames matrix

k = 0; %// Counts the total number of frames so far
count = 1; %// Keeps track of where to place frame
while hasFrame(obj)
    frm = readFrame(obj); %// Read frame
    k = k + 1; %// Increment count
    if mod(k,5) == 0 %// If we're at the 10th frame, save it
        allFrames(:,:,:,count) = frm;
        count = count + 1;
    end
end

end