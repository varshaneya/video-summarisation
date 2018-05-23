function [temporalGradient] = temporalAttentionValue(image1,image2)

height = size(image1,1);
width = size(image1,2);
%temporalGradient = zeros((size(image2,1)+2)*(size(image2,2)+2),25); %window size is 5x5

temporalGradientVector = cell(size(image2,1)+4,size(image2,2)+4);

for i = 1:size(image2,1)+4 
    for j = 1:size(image2,2)+4
        temporalGradientVector{i,j} = zeros(1,25);
    end
end

newImage = zeros(height+4,width+4);

newImage(3:height+2,3:width+2) = image1;

newImage(1:2,3:width+2) = image1(3:4,:);
newImage(size(newImage,1)-1:size(newImage,1),3:width+2) = image1(height-3:height-2,:);
newImage(3:height+2,1:2) = image1(:,3:4);
newImage(3:height+2,size(newImage,2)-1:size(newImage,2)) = image1(:,width-3:width-2);

% newImage(1:2,3:width+2) = uint8(zeros(2,width));
% newImage(size(newImage,1)-1:size(newImage,1),3:width+2) = uint8(zeros(2,width));
% newImage(3:height+2,1:2) = uint8(zeros(height,2));
% newImage(3:height+2,size(newImage,2)-1:size(newImage,2)) = uint8(zeros(height,2));

for i = 1:height
    for j = 1:width
        %k= ((i+1) * width) + j;
       temporalGradientVector{i+2,j+2} = TCCalculate(image2(i,j),newImage(i:i+4,j:j+4));
    end
end

%computing gradient vector at each pixel...

temporalGradient = zeros(height,width);

for i = 1:size(image2,1) 
    for j = 1:size(image2,2)
        temporalGradient(i,j) = calcTempGrad(temporalGradientVector,i,j);
    end
end

clear temporalGradientVector;
% for i = 1:size(video,4)
%     
% end
%temporalGradient = temporalGradient./max(max(temporalGradient));
%attentionValue = mean(mean(temporalGradient(temporalGradient ~= 0)));
end

function [grad] = calcTempGrad(temporalGradientVector,iIndex,jIndex)
grad = 0;
% relativePixeli = iIndex + 2;
% relativePixelj = jIndex + 2;

for i = 0:4
    for j = 0:4
        %i
        %j
        grad = grad + norm(temporalGradientVector{iIndex+2,jIndex+2} - temporalGradientVector{iIndex+i,jIndex+j},1);
    end
end

end

function vector = TCCalculate(pixelVal,window)
vector = zeros(1,25);
k = 1;

for i = 1:5
    for j=1:5
        vector(1,k) = abs(pixelVal - window(i,j));
        k = k+1;
    end
end
end