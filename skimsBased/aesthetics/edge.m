function [quality] = edge(frame)

tempImg = uint8(zeros(size(frame,1),size(frame,2),3));

for i =1:3
   tempImg(:,:,i) = abs(imfilter(frame(:,:,i),fspecial('laplacian',0.2))); 
end

tempImg = mean(tempImg,3);

laplacianImg = imresize(tempImg,[100 100]);

laplacianImg = laplacianImg ./sum(sum(laplacianImg));
%laplacianImg = laplacianImg ./norm(laplacianImg,1);

pX = zeros(1,size(laplacianImg,1));
pY = zeros(1,size(laplacianImg,2));

for i = 1:size(laplacianImg,1)
    pX(i) = sum(laplacianImg(i,:));
end

for i = 1:size(laplacianImg,2)
    pY(i) = sum(laplacianImg(:,i));
end

wX = 0;
wY = 0;
i = 1;

pX = sort(pX,'descend');

while(wX < 0.98)
    wX = wX + pX(i);
    i = i + 1;
end
i=i-1;
j = 1;
pY = sort(pY,'descend');
while(wY < 0.98)
    wY = wY + pY(j);
    j = j + 1;
end
j=j-1;
quality = 1 - (i * j/10000);
%imshow(laplacianImg,[])

end