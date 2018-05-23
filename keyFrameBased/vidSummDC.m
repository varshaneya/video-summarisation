function feature=vidSummDC(frames, percent)
vidName = input('Enter a name for the output summary: ');    
    for i=1:size(frames,4)
        hsv=rgb2hsv(frames(:,:,:,i));
        H=imhist(hsv(:,:,1));
        feature(i,:)=H';
    end
    clear frames
    feature=feature./repmat(sum(feature,2),1,size(feature,2));
    [~,score,~,~,explained] = pca(feature);
    tmp=0;
    
    for i=1:length(explained)
        tmp=tmp+explained(i);
        if(tmp>=percent)
            break;
        end
    end
    
    rFeature=score(:,1:i);
    dim=size(rFeature,2);
    
    T = delaunayn(rFeature);
    
    for i=1:size(rFeature,1)
        [r c]=ind2sub(size(T),find(T==i));
        nbr{i}=T(sub2ind(size(T),r,mod(c,dim+1)+1)); %all right neighbors
        nbr{i}=[nbr{i};T(sub2ind(size(T),r,mod(c+dim-1,dim+1)+1))];%all left neighbors
        nbr{i}=unique(nbr{i});    
        d(i)=length(nbr{i});
        eLen{i}=sqrt(sum((repmat(rFeature(i,:),length(nbr{i}),1)-rFeature(nbr{i},:)).^2,2));
        lMean(i)=sum(eLen{i})/(d(i)+eps);
        lDev(i)=sqrt((sum((lMean(i)-eLen{i}).^2))/(d(i)+eps));
    end
    
    gDev=sum(lDev)/size(rFeature,1);

    for i=1:size(rFeature,1)    
        temp=find(eLen{i}>lMean(i)+gDev);
        nbr{i}(temp)=[];
        eLen{i}(temp)=[];    
        temp=find(eLen{i}>=lMean(i)-gDev & eLen{i}<=lMean(i)+gDev);
        nbr{i}(temp)=[];
        eLen{i}(temp)=[];
        nbr{i}=[i;nbr{i}];
    end
    
    cnum=0;
    curr=cnum;
    cluster{1}=[];
    
    for i =1:size(rFeature,1)
%         i
        c=inClust(cluster,i);
        if(c==0)
            cnum=curr+1;
            curr=cnum;
            cluster{cnum}=[];
        else
           cnum=c;
        end
        for j =i:size(rFeature,1)
            if(any(nbr{j}==i))
                cluster{cnum}=[cluster{cnum};j;nbr{j}];   
                cluster{cnum}=unique(cluster{cnum});
            end       
        end    
    end

for i = 1:size(cluster,2)
    for j=i+1:size(cluster,2)
        if(~isempty(intersect(cluster{i},cluster{j})))
            cluster{i} = unique(vertcat(cluster{i},cluster{j}));
            cluster{j} = [];
        end
    end
end

k=1;

sigFactor = 0;

totFrames=0;

for i = 1:size(cluster,2)
    totFrames = totFrames + size(cluster{i},1);
end

for i=1:size(cluster,2)
    if size(cluster{i},1) > 1    %look for non empty cells which are clusters
        sigFactor = calSigFactor(cluster,i,totFrames);
        indices = int32(cluster{i});
        med(k,:) = [sigFactor median(rFeature(indices,:))]; %find the median of the such a cluster
        k = k + 1;
    
    elseif size(cluster{i},1) == 1
        cluster{i} = [];        %sqaush all the singleton points
    end
end

noOfClusters = k -1;

[dCluster,med] = keyFrameSelect(noOfClusters,rFeature,med,gDev);

 display('The significance factors of the clusters are: ');
 display(med(:,1));
 display('Compression factor is: ');
 display(noOfClusters/size(frames,4));
 
writeOutput(vidName,dCluster,size(dCluster,2),frames);

end

function sf = calSigFactor(cluster,clNo,totFrames)
sf = size(cluster{clNo},1)/totFrames;
end

function [kf,med] = keyFrameSelect(noOfClusters,featureVec,med,gDev)

%this function takes the mathematically calculated mean values and find a
%frame from the set of acquired frames which is CLOSEST to it... metric
%used is |x-y|

kf = zeros(1,noOfClusters);

for i = 1:noOfClusters
    dist = inf;
    temp = 0;
    for j = 1:size(featureVec,1)
        temp = norm(abs(featureVec(j,:)- med(i,2:size(med,2))));
        if temp <= dist
            dist = temp;
            kf(1,i)=j;  %store the closest frame acquired from the video
        end
    end
end

%code to merge similiar looking frames to reduce redundancy

for i = 1:size(kf,2)
    for j = i+1:size(kf,2)
        if(kf(1,j) ~= 0 && kf(1,i) ~= 0)
            if(norm(abs(featureVec(int32(kf(1,j)),:)- featureVec(int32(kf(1,i)),:))) < gDev)
            kf(1,j) = 0;
            med(j,:) = [];
            noOfClusters = noOfClusters -1;
            end
        end
    end
end

kf = kf(kf ~=0 );

end

function writeOutput(vidName,keyFrames,noOfKeyFrames,frames)
%fucntion to write the output as images to the current directory with
%proper nameing.

for i =1:noOfKeyFrames
    if(keyFrames(i) ~= 0)
        name = [vidName,' - DC - ',int2str(i),'.jpg'];
        imwrite(frames(:,:,:,keyFrames(i)),name);
    end
end


end

function c=inClust(cluster,ind)
c=0;
if(isempty(cluster))
    return;
else
    for i=1:length(cluster)
        if(any(cluster{i}==ind))
            c=i;
            break;
        end
    end    
end
end
