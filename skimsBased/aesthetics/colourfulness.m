function [fval] = colourfulness(frame)
height = size(frame,1);
width = size(frame,2);

colorfulImg = uint8(randi([0 255],height,width,3));

nbins = 4;

ca = rgbhist(colorfulImg, nbins);
cb = rgbhist(frame, nbins);

ha = reshape(0:length(ca)-1,[length(ca),1]);
hb = reshape(0:length(cb)-1,[length(cb),1]);

% Features
f1 = ha;
f2 = hb;
% Weights
w1 = ca / sum(ca);
w2 = cb / sum(cb);
% Earth Mover's Distance
[~, fval] = emd(f1, f2, w1, w2, @gdf);
end