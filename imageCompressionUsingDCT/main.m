close all;
clear;
clc;

blockSize = 32;
bandRadius = 20;
r = 99;

load("../Images/exercise2/barbara.mat");
barbara = im2double(barbara);

[M, N, d] = size(barbara);

BARBARA = zeros(M, N, d); % DCT{barbara}
BARBARA_ZONAL = zeros(M, N, d);
BARBARA_TYP_ZONAL = zeros(M, N, d);
BARBARA_THRES = zeros(M, N, d);
BARBARA_GLOB_THRES = zeros(M, N, d);
barbara_zonal = zeros(M, N, d);
barbara_typ_zonal = zeros(M, N, d);
barbara_thres = zeros(M, N, d);
barbara_glob_thres = zeros(M, N, d);
for k=1:d
    % Apply DCT on blocks
    for i=1:blockSize:M
        for j=1:blockSize:N
            BARBARA(i:i+blockSize-1, j:j+blockSize-1, k) =...
                dct2(barbara(i:i+blockSize-1, j:j+blockSize-1, k));               
        end
    end

    % Zonal Masking
    BARBARA_ZONAL(:,:,k) = applyZonalMask(BARBARA(:,:,k),blockSize,r);
    % Typical Zonal Masking
    BARBARA_TYP_ZONAL(:,:,k) =...
        applyTypicalZonalMask(BARBARA(:,:,k),blockSize,r);
    % Threshold Mask
    BARBARA_THRES(:,:,k) = applyThresholdMask(BARBARA(:,:,k),blockSize,r);
    % Global Threshold Mask
    BARBARA_GLOB_THRES(:,:,k) =...
        applyGlobalThresholdMask(BARBARA(:,:,k),blockSize,r);

    % Get back to spatial domain
    for i=1:blockSize:M
        for j=1:blockSize:N
            barbara_zonal(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(BARBARA_ZONAL(i:i+blockSize-1, j:j+blockSize-1, k));
            barbara_typ_zonal(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(BARBARA_TYP_ZONAL...
                (i:i+blockSize-1, j:j+blockSize-1, k));
            barbara_thres(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(BARBARA_THRES(i:i+blockSize-1, j:j+blockSize-1, k));
            barbara_glob_thres(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(...
                BARBARA_GLOB_THRES(i:i+blockSize-1, j:j+blockSize-1, k));
        end
    end
end

%% Barbara in spatial and freq domain
figure;
subplot(1,2,1);
imshow(barbara);
title("Original Image");
subplot(1,2,2);
imshow(BARBARA);
title("Barbara DCT");

%% Zonal mask figures
figure("Name", "Results of zonal masking viewed on the frequency domain");
subplot(1,2,1);
imshow(BARBARA);
title("Barbara DCT");
subplot(1,2,2);
imshow(BARBARA_ZONAL);
title(strcat("Barbara DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name", "Results of zonal masking viewed on the spatial domain");
subplot(1,2,1);
imshow(barbara);
title("Original Image");
subplot(1,2,2);
imshow(barbara_zonal);
title("Compressed Image using a zonal mask");

%% Typical zonal mask figures
figure("Name",...
    "Results of typical zonal masking viewed on the frequency domain");
subplot(1,2,1);
imshow(BARBARA);
title("Barbara DCT");
subplot(1,2,2);
imshow(BARBARA_TYP_ZONAL);
title(strcat("Barbara DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name",...
    "Results of typical zonal masking viewed on the spatial domain");
subplot(1,2,1);
imshow(barbara);
title("Original Image");
subplot(1,2,2);
imshow(barbara_typ_zonal);
title("Compressed Image using a typical zonal mask");

%% Threshold mask figures
figure("Name",...
    "Results of threshold masking viewed on the frequency domain");
subplot(1,2,1);
imshow(BARBARA);
title("Barbara DCT");
subplot(1,2,2);
imshow(BARBARA_THRES);
title(strcat("Barbara DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name",...
    "Results of threshold masking viewed on the spatial domain");
subplot(1,2,1);
imshow(barbara);
title("Original Image");
subplot(1,2,2);
imshow(barbara_thres);
title("Compressed Image using a threshold mask");

%% Global Threshold mask figures
figure("Name",...
    "Results of global threshold masking viewed on the frequency domain");
subplot(1,2,1);
imshow(BARBARA);
title("Barbara DCT");
subplot(1,2,2);
imshow(BARBARA_GLOB_THRES);
title(strcat("Barbara DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name",...
    "Results of global threshold masking viewed on the spatial domain");
subplot(1,2,1);
imshow(barbara);
title("Original Image");
subplot(1,2,2);
imshow(barbara_glob_thres);
title("Compressed Image using a global threshold mask");