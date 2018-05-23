fromPath = '../../sumMe/videos/';
toPath = '../../data/aesthetics/';
videos = dir(fromPath);

for i = 1:size(videos,1)
   [quality,cont,colour,frCount] = contrastEdgesAndColourfulness(strcat(fromPath,videos(i).name));
   temp = videos(i).name;
   temp = temp(1:size(temp,2)-4);
   temp = strcat(temp,'.mat');
   save(strcat(toPath,temp),'quality','cont','colour','frCount');
end