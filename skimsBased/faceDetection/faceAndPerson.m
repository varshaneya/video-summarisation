function [face,person,frCount] = faceAndPerson(vidName)
obj = VideoReader(vidName); %// Place your video path here
frCount = 1; %// Counts the total number of frames so far
faceDetector = vision.CascadeObjectDetector;
peopleDetector = vision.PeopleDetector;

while hasFrame(obj)
   frm = readFrame(obj); %// Read frame
   fbboxes = step(faceDetector,frm);
   face(frCount) = getScore(fbboxes,size(frm,1),size(frm,2));
      
   pbboxes = step(peopleDetector,frm);
   person(frCount) = getScore(pbboxes,size(frm,1),size(frm,2));
   frCount = frCount + 1; %// Increment count
end
end

function score = getScore(bbox,height,width)

score = 0;
imArea = height * width;

for i = 1:size(bbox,1)
    score = score + (bbox(i,3) * bbox(i,4) / imArea);
end
end
%img = imread('img.JPG');
% peopleDetector = vision.PeopleDetector;
% [bboxes,score] = step(peopleDetector,img1);
