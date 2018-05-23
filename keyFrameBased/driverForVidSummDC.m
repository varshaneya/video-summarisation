vidDir = input('Enter directory containing videos: ')
vidName = dir(vidDir)
for i =2:length(vidName)
    tic
    frames = frameReader(vidName{1,i});
    vidSummDC(vidName{1,i},frames,90);
    toc
end