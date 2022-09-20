% The point of this script is to try and figure out how extractHOGFeatures
% handles the last columns (and rows) that are leftover when dividing the
% image into cells.
% I did not figure out exactly how it handles it but it is definitely not
% cropping or resizing the image. My guess is that it just makes the last
% cell a couple of pixels larger (so it may include the leftover columns
% (and rows)).
% The same problem occurs also when dividing the image into overlapping
% blocks. I have no opinion on the matter. My guess is that it probably
% ignores the leftover cells (See example where cellSize = [3 3],
% blockSize = [2 2] and overlap = [0 0]).
close all;
clear;
clc;

m = 28;
n = 28;

% Use this to test an edge case
img = zeros(m,n);
for i=1:m-1
    for j=1:n-1
        img(i,j) = 1;
    end
end

% Use this to test a random case
% img = rand(m,n);

cellSize = [3 3];
blockSize = [2 2];
overlap = [0 0];
resSize = floor(size(img)./cellSize).*cellSize;

hogf = extractHOGFeatures(img, ...
    'CellSize',cellSize, ...
    'BlockSize',blockSize, ...
    'BlockOverlap', overlap);
hogf_cropped = extractHOGFeatures(img(1:resSize(1), 1:resSize(2)), ...
    'CellSize', cellSize, ...
    'BlockSize',blockSize, ...
    'BlockOverlap', overlap);
hogf_resize = extractHOGFeatures(imresize(img, resSize), ...
    'CellSize', cellSize, ...
    'BlockSize',blockSize, ...
    'BlockOverlap', overlap);

if (all(size(img) == resSize,'all'))
    disp("CROP and RESIZE calls have the same arguments as hogf");
    return;
end

if(hogf == hogf_cropped)
    disp("CROP: HOG Features match");
elseif(hogf == hogf_resize)
    disp("RESIZE: HOG Features match");
else
    disp("HOG Features do not match");
end