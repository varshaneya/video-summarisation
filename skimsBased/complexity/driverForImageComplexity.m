fromPath = '../../sumMe/videos/';
toPath = '../../data/complexity/';
videos = dir(fromPath);
length = size(videos,1);
for i = 3:length
    %if i==11 || i==28
    %videos(i).name
   [imgCompl]= imageComplexity(videos(i).name);
   temp = strcat(toPath,videos(i).name);
   newName = temp(1:size(temp,2)-4);
   save(strcat(newName,'.mat'),'imgCompl');
    %end
end