close all;
clear;
clc;

% Either use min_expect_coef, so you may skip pixels outside the shape
% that may be selected as starting points or use one of the layers of the
% rgb image, instead of using rgb2gray();
min_expect_coef = 5;

r = 1; % Ratio of the Fourier coefficients to preserve
rot_deg = 90; % Rotate image
scale = 1; % Resize image
shift_pix = [0, 0]; % Translate image

% Convert image to a binary one
leaf = imread("../Images/exercise4/leaf.jpg");
leaf_bw = imbinarize(rgb2gray(leaf));

% Flip pixel values so the object is white (1) and the background black (0)
leaf_bw = ~leaf_bw;

% Rotate the image
leaf_bw = imrotate(leaf_bw, rot_deg);

% Resize the image
leaf_bw = imresize(leaf_bw, scale);

% Tranclate the image
leaf_bw = imtranslate(leaf_bw, shift_pix, 'OutputView', 'full');

% Calculate the Fourier Descriptors
Fourier_Descr = calc_FD(leaf_bw, min_expect_coef);
% Reconstruct the image
rec_img = reconstruct_shape_FD(Fourier_Descr, r);

figure(1);
imshow(leaf_bw);
title("Original Image");
figure(2);
imshow(rec_img);
title(strcat("Extracted shape using ", num2str(r*100),...
    "% of the Fourier Descriptors"));