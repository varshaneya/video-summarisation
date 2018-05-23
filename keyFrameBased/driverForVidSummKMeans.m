vidDir = input('Enter directory containing videos: ')
vidName = dir(vidDir)
for i =2:length(vidName)
    tic
    frames = frameReader(vidName{1,i});
    noOfClusters = 10; %hyperparameter
    vidSummKMeans(vidName{1,i},frames,noOfClusters,90);
    toc
end