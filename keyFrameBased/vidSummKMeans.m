function [] = vidSummKMeans(vidName,frames,noOfClusters,percent)
feature =frames;
for i=1:size(frames,4) 
    hsv=rgb2hsv(frames(:,:,:,i));  %convert the frames into HSV format
    H=imhist(hsv(:,:,1)); %histogram for h component
    feature(i,:)= H;
end

feature=feature./repmat(sum(feature,2),1,size(feature,2));  %normalise the feature vector

[~,score,~,~,explained] = pca(feature); %principal component analysis

tmp=0;

for i=1:length(explained)   %get the eigen vectors for the required percentage of energy
    tmp=tmp+explained(i);
    if(tmp>=percent)
        break;
    end
end

rFeature=score(:,1:i);  %representation of data in principal componenet space

%rows of score correspond to observation
%columns corresponds to components

dim=size(rFeature,2);   %dimension of the fearure space which is col dimension

[~,clusterC] = kmeans(rFeature,noOfClusters);

kf = keyFrameSelect(noOfClusters,rFeature,clusterC);

writeOutput(vidName,kf,noOfClusters,frames);

end

function kf = keyFrameSelect(noOfClusters,featureVec,med)

kf = zeros(1,noOfClusters);

for i = 1:noOfClusters
    dist = inf;
    temp = 0;
    for j = 1:size(featureVec,1)
        temp = norm(abs(featureVec(j,:)- med(i,:)));
        if temp <= dist
            dist = temp;
            kf(1,i)=j;
        end
    end
end
end

function [] = writeOutput(vidName,keyFrames,noOfKeyFrames,frames)

for i =1:noOfKeyFrames
    name = [vidName,' - KMC - ',int2str(i),'.jpg'];
    imwrite(frames(:,:,:,keyFrames(i)),name);
    %keyFrames(i)
end
   
end
