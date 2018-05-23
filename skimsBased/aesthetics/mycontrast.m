function [width] = mycontrast(frm)
% grayImg = rgb2gray(frm);
[countsR,X] = imhist(frm(:,:,1));
[countsG,X] = imhist(frm(:,:,2));
[countsB,X] = imhist(frm(:,:,3));
counts = countsR+countsG+countsB;
counts=counts./sum(counts);
%figure, plot(X, counts)
wl=0;
i=1;
while(wl<0.01)
    wl=wl+counts(i);
    i=i+1;
end
wr=0;
len=length(counts);
while(wr<0.01)
    wr=wr+counts(len);
    len=len-1;
end
if i <=length(X) && len >0
    width=X(len)-X(i);
else
    width = 0;
end
end