function [quality,cont,colour,frCount] = contrastEdgesAndColourfulness(vidName)
obj = VideoReader(vidName); %// Place your video path here
k=1;
frCount = 0; %// Keeps track of where to place frame
while hasFrame(obj)
    frm = readFrame(obj); %// Read frame
    if mod(k,5) == 0
        quality(frCount+1) = edge(frm);
        cont(frCount+1) = mycontrast(frm);
        colour(frCount+1) = colourfulness(frm);
        frCount = frCount + 1;
    end
    k = k+1;
end
end

