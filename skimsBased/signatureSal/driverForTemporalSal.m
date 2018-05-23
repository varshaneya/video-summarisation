fromPath = '../../sumMe/videos/';
toPath = '../../data/temporalAttention/';
videos = dir(fromPath);
nVid = length(videos);

for i = 4:nVid
   [temporalAttention,~] = getTemporalAttention(strcat(fromPath,videos(i).name));
   temp = strcat(toPath,videos(i).name);
   newName = temp(1:size(temp,2)-4);
   save(strcat(newName,'.mat'),'temporalAttention');
end