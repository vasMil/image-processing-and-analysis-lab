close all;
clear;
clc;

moon = imread('..\Images\exercise1\moon.jpg');
imshow(moon(:,:,3));

% Why does the image have three dimensions?
% It may be that each plane represents one of the three colors r,g,b
t0 = all(moon(:,:,1) == moon(:,:,2),'all');
t1 = all(moon(:,:,1) == moon(:,:,3),'all');
if (t0 == t1)
    disp("All 3 planes have the save values");
end
% But if that is the case then why are all planes identical?
% Answer:
% https://www.mathworks.com/matlabcentral/answers/155029-trying-to-understand-the-image-matrix#answer_151862

% How do I handle rgb images?
% For example applying DFT?
% https://stackoverflow.com/a/9827229/14958480
% Applying filter:
% https://www.mathworks.com/matlabcentral/answers/616753-applying-2d-filter-on-rgb-image
% Essentially I operate upon each channel separately.



