fromPath = '../../sumMe\videos/';
toPath = '../../staticAttention/';
videos = dir(fromPath);

for i = 2:size(videos,1)
   [staticAttention,frCount] = getStaticAttention(strcat(fromPath,videos(i).name));
   temp = strcat(toPath,videos(i).name);
   newName = temp(1:size(temp,2)-4);
   save(strcat(newName,'.mat'),'staticAttention','frCount');
   end
end