close all;
clear;
clc;

moon = imread('..\Images\exercise1\moon.jpg');
[M, N, d] = size(moon);

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

% Preprocessing
% Since it is a grayscale image I may only hold on to one of the channels
moon_r = moon(:,:,1);
% Histogram Equalization
moon_r_equ = histogramEqualization(moon_r, 256);

subplot(2,2,1);
histogram(moon_r, 256);
title("Initial histogram");
subplot(2,2,2);
imshow(moon_r,[])
title("Initial image");

subplot(2,2,3);
histogram(moon_r_equ, 256);
title("histogram after equalization")
subplot(2,2,4);
imshow(moon_r_equ,[])
title("Image after histogram equalization")

moon_r_equ_cent = moon_r_equ;
for i=1:M
    for j=1:N
        if ~mod(i+j,2)
            moon_r_equ_cent(i,j) = (-1).*moon_r_equ_cent(i,j);
        end
    end
end

figure;
imshow(log(1+abs(fft2(moon_r_equ_cent))), []);