isTraining=1;
isSubModOptimisiation=1;
vid = dir('../sumMe/videos/');
nVid=length(vid);

for i=2:nVid
temp = vid(i).name;
vidName = temp(1:length(temp)-4);
obj=VideoReader(temp);
frCount = floor(obj.Duration * obj.FrameRate);
try
calculateInterestingnessScore;
catch
display(vidName);
continue;
end
end