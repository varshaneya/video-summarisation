function [staticAttention,frCount] = getStaticAttention(vidName)
obj = VideoReader(vidName); %// Place your video path here
frCount = 1; %// Keeps track of where to place frame
while hasFrame(obj)
    frm = readFrame(obj); %// Read frame
    outMap = signatureSal(imresize(frm,[48 64]));
    staticAttention(frCount) = mean(mean(outMap(outMap~=0)));
    frCount = frCount + 1;
end
end