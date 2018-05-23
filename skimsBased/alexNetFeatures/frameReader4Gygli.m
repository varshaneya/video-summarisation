function allFrames = frameReader4Gygli(vidName)
tic
obj = VideoReader(vidName); %// Place your video path here
width = obj.Width; %// Get width and height of the video
height = obj.Height;
numChannels = 3; %// Get number of channels.  Assuming RGB - Change if necessary
numberOfFrames = obj.Duration*obj.FrameRate; %// Calculate total number of frames to save
%frCount = 0; %// Counts the total number of frames so far

allFrames = zeros(height,width,numChannels,1000,'uint8'); %// Pre-allocate frames matrix

noOfSets = floor(numberOfFrames/1000);
flag =0;

for i = 1:noOfSets
    frCount = 0;
    for j=1:1000
      if ~hasFrame(obj)
          flag = 1;
          break;
      end
      allFrames(:,:,:,frCount+1) = readFrame(obj); %// Read frame
      frCount = frCount+1;
    end
    name = strsplit(vidName,'.');
    save(strcat(name{1},num2str(i),'.mat'), 'allFrames','height','width','frCount','-v7.3');
    if flag == 1
        break;
    end
end

%store the rest of the frames.....
restOfFrames = mod(numberOfFrames,1000);
frCount = 0;

% while hasFrame(obj)
%     frm = readFrame(obj); %// Read frame
%     allFrames(:,:,:,frCount+1) = frm;
%     frCount = frCount + 1;
% end

for i=1:restOfFrames
    if ~hasFrame(obj)
        break
    end
    allFrames(:,:,:,frCount+1) = readFrame(obj); %// Read frame
    frCount = frCount+1;
end

save(strcat(name{1},num2str(noOfSets + 1),'.mat'), 'allFrames','height','width','frCount','-v7.3');

toc
end