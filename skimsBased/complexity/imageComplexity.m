function [imgCompl]= imageComplexity(vidName)
obj=VideoReader(vidName);
imgCompl = zeros(1,floor(obj.FrameRate * obj.Duration));
i=1;
while hasFrame(obj)
    frame=readFrame(obj);
    imwrite(frame,'f.jpg','jpeg');
    info =imfinfo('f.jpg');
    imgCompl(i)=info.FileSize/(size(frame,1)*size(frame,2)*3*8);
    delete 'f.jpg'
    i=i+1;
end
end