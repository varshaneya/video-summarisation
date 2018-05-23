newVidName = strcat('summaryInt',vidName(1:length(vidName)-4),'.avi');
vidW = VideoWriter(newVidName);
open(vidW);

vidR = VideoReader(vidName);
k = 1;
i = 1;

index = intSeg(i);
frame = readFrame(vidR);

while hasFrame(vidR)
    
    lb =  superFrames(index,1);
    ub =  superFrames(index,2);
    
    if k == lb
        if ub > frCount
            ub = frCount;
        end
        for j=lb:ub
            writeVideo(vidW,frame);
            frame = readFrame(vidR);
            k = k+1;
        end
        i = i+1;
        
        if i<=length(intSeg)
        index = intSeg(i);
        end
        %k = k-1;
        continue;
    end
    
    if ~hasFrame(vidR)
        break;
    end
    frame = readFrame(vidR);
    k = k+1;
    
    %pause
end

close(vidW);
