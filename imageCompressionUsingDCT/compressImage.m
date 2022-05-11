function [MSE_zonal, MSE_typ_zonal, MSE_thres, MSE_glob_thres] =...
    compressImage(img, blockSize, r, shouldPlot)
% function [MSE_zonal, MSE_typ_zonal, MSE_thres, MSE_glob_thres,...
%     IMG, img_zonal, IMG_ZONAL, img_typ_zonal, IMG_TYP_ZONAL,...
%     img_thres, IMG_THRES, img_glob_thres, IMG_GLOB_THRES] =...
%     compressImage(img, blockSize, r, shouldPlot)
[M, N, d] = size(img);

IMG = zeros(M, N, d); % DCT{img}
IMG_ZONAL = zeros(M, N, d);
IMG_TYP_ZONAL = zeros(M, N, d);
IMG_THRES = zeros(M, N, d);
IMG_GLOB_THRES = zeros(M, N, d);
img_zonal = zeros(M, N, d);
img_typ_zonal = zeros(M, N, d);
img_thres = zeros(M, N, d);
img_glob_thres = zeros(M, N, d);
for k=1:d
    %% Block DCT on image
    for i=1:blockSize:M
        for j=1:blockSize:N
            IMG(i:i+blockSize-1, j:j+blockSize-1, k) =...
                dct2(img(i:i+blockSize-1, j:j+blockSize-1, k));               
        end
    end
    %% Apply the masks
    % Zonal Masking
    IMG_ZONAL(:,:,k) = applyZonalMask(IMG(:,:,k),blockSize,r);
    % Typical Zonal Masking
    IMG_TYP_ZONAL(:,:,k) =...
        applyTypicalZonalMask(IMG(:,:,k),blockSize,r);
    % Threshold Mask
    IMG_THRES(:,:,k) = applyThresholdMask(IMG(:,:,k),blockSize,r);
    % Global Threshold Mask
    IMG_GLOB_THRES(:,:,k) =...
        applyGlobalThresholdMask(IMG(:,:,k),blockSize,r);

    %% Get back to spatial domain
    for i=1:blockSize:M
        for j=1:blockSize:N
            img_zonal(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(IMG_ZONAL(i:i+blockSize-1, j:j+blockSize-1, k));
            img_typ_zonal(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(IMG_TYP_ZONAL...
                (i:i+blockSize-1, j:j+blockSize-1, k));
            img_thres(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(IMG_THRES(i:i+blockSize-1, j:j+blockSize-1, k));
            img_glob_thres(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(...
                IMG_GLOB_THRES(i:i+blockSize-1, j:j+blockSize-1, k));
        end
    end
end

%% Calculate MSEs
MSE_zonal = sum((img - img_zonal).^2,'all')/(M*N);
MSE_typ_zonal = sum((img - img_typ_zonal).^2, 'all')/(M*N);
MSE_thres = sum((img - img_thres).^2, 'all')/(M*N);
MSE_glob_thres = sum((img - img_glob_thres).^2,'all')/(M*N);

%% Guard on plot
if(~shouldPlot)
    return;
end
%% Barbara in spatial and freq domain
figure;
subplot(1,2,1);
imshow(img);
title("Original Image");
subplot(1,2,2);
imshow(IMG);
title("Image DCT");

%% Zonal mask figures
figure("Name", "Results of zonal masking viewed on the frequency domain");
subplot(1,2,1);
imshow(IMG);
title("Image DCT");
subplot(1,2,2);
imshow(IMG_ZONAL);
title(strcat("Image DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name", "Results of zonal masking viewed on the spatial domain");
subplot(1,2,1);
imshow(img);
title("Original Image");
subplot(1,2,2);
imshow(img_zonal);
title("Compressed Image using a zonal mask");

%% Typical zonal mask figures
figure("Name",...
    "Results of typical zonal masking viewed on the frequency domain");
subplot(1,2,1);
imshow(IMG);
title("Image DCT");
subplot(1,2,2);
imshow(IMG_TYP_ZONAL);
title(strcat("Image DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name",...
    "Results of typical zonal masking viewed on the spatial domain");
subplot(1,2,1);
imshow(img);
title("Original Image");
subplot(1,2,2);
imshow(img_typ_zonal);
title("Compressed Image using a typical zonal mask");

%% Threshold mask figures
figure("Name",...
    "Results of threshold masking viewed on the frequency domain");
subplot(1,2,1);
imshow(IMG);
title("Image DCT");
subplot(1,2,2);
imshow(IMG_THRES);
title(strcat("Image DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name",...
    "Results of threshold masking viewed on the spatial domain");
subplot(1,2,1);
imshow(img);
title("Original Image");
subplot(1,2,2);
imshow(img_thres);
title("Compressed Image using a threshold mask");

%% Global Threshold mask figures
figure("Name",...
    "Results of global threshold masking viewed on the frequency domain");
subplot(1,2,1);
imshow(IMG);
title("Image DCT");
subplot(1,2,2);
imshow(IMG_GLOB_THRES);
title(strcat("Image DCT, preserving ", num2str(r)...
    ,"% of the coefficients"));

figure("Name",...
    "Results of global threshold masking viewed on the spatial domain");
subplot(1,2,1);
imshow(img);
title("Original Image");
subplot(1,2,2);
imshow(img_glob_thres);
title("Compressed Image using a global threshold mask");

end

