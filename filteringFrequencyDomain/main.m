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
    disp("All 3 planes have the same values");
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
% In the case of a colored image, it is still possible to apply histogram
% equalization to each layer independently, but I would get significant
% changes on the color balance of the image.
% Sources:
% https://en.wikipedia.org/wiki/Histogram_equalization#:~:text=The%20above%20describes,applying%20the%20algorithm.
% https://towardsdatascience.com/histogram-equalization-5d1013626e64#:~:text=A%20color%20histogram,of%20the%20image.
moon_r_equ = histogramEqualization(moon_r, 256);

figure;
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

% Apply DFT property Gonzalez chapter 4, 4.6, page 251 (fourth edition)
% Circular Frequency Shift is the property used to translate frequency 
% point (0,0) to the center of the frequency rectangle
moon_r_equ_cent = alternamePixelSigns(moon_r_equ);
figure;
imshow(moon_r_equ_cent, []);
title("Image after Histogram Equalization and Circular Frequency Shift");

% Compute 2D DFT, using row-column algorithm
MOON_R_EQU_CENT = rowColumn_fft(moon_r_equ_cent);
% Plot the magnitude
figure;
subplot(1,2,1);
imshow(abs(MOON_R_EQU_CENT), []);
title("DFT Magnitude");

subplot(1,2,2);
imshow(log(abs(MOON_R_EQU_CENT)), []);
title("DFT Magnitude in logarithmic scale");


