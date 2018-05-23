tic
dataDir='.\sumMe\videos\';
D=dir(dataDir);
nVid=length(D(not([D.isdir])));
for i=2:nVid
    if(mod(i,2) == 1)   %leave .webm files
        continue
    end
    
    vidName=D(i+2).name;
    obj = VideoReader(vidName); %// Place your video path here
    width = obj.Width; %// Get width and height of the video
    height = obj.Height;
    numChannels = 3; %// Get number of channels.  Assuming RGB - Change if necessary
    numberOfFrames = obj.Duration*obj.FrameRate; %// Calculate total number of frames to save

    allFrames = zeros(height,width,numChannels,ceil(numberOfFrames),'uint8'); %// Pre-allocate frames matrix

    frCount = 0; %// Counts the total number of frames so far
    while hasFrame(obj)
        frm = readFrame(obj); %// Read frame
        allFrames(:,:,:,frCount+1) = frm;
        frCount = frCount + 1;
    end

    save(strrep(vidName,'mp4','mat'), 'allFrames','height','width','frCount','-v7.3');
end
toc