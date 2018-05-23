driverForFaceAndPerson()
fromPath = '../../sumMe/videos/';
toPath = '../../data/faceDetection/';
videos = dir(fromPath);
length = size(videos,1);
for i = 4:length
    %if i==11 || i==28
    %videos(i).name
   [face,person,frCount] = faceAndPerson(strcat(fromPath,videos(i).name));
   temp = strcat(toPath,videos(i).name);
   newName = temp(1:size(temp,2)-4);
   save(strcat(newName,'.mat'),'face','person','frCount');
    %end
end