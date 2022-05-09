close all;
clear;
clc;

blockSize = 32;
bandRadius = 20;

load("../Images/exercise2/barbara.mat");
barbara = im2double(barbara);

[M, N, d] = size(barbara);

% Apply DCT on blocks
BARBARA = zeros(M, N, d);
for k=1:d
    for i=1:blockSize:M
        for j=1:blockSize:N
            BARBARA(i:i+blockSize-1, j:j+blockSize-1, k) =...
                dct2(barbara(i:i+blockSize-1, j:j+blockSize-1, k));               
        end
    end
end

% Band Method
BARBARA_BAND = BARBARA;
for k=1:d
    for i=1:M
        for j=1:N
            r = mod(i, blockSize);
            c = mod(j, blockSize);
            if (r+c > bandRadius)
                BARBARA_BAND(i,j,k) = 0;
            end
        end
    end
end

% Get back to spatial domain
compressedBarbara = zeros(M, N, d);
for k=1:d
    for i=1:blockSize:M
        for j=1:blockSize:N
            compressedBarbara(i:i+blockSize-1, j:j+blockSize-1, k) =...
                idct2(BARBARA_BAND(i:i+blockSize-1, j:j+blockSize-1, k));               
        end
    end
end

figure;
subplot(1,2,1);
imshow(barbara);
title("Original Image");
subplot(1,2,2);
imshow(BARBARA);
title("Barbara DCT");

figure;
subplot(1,2,1);
imshow(BARBARA);
title("Barbara DCT");
subplot(1,2,2);
imshow(BARBARA_BAND);
title(strcat("Barbara DCT, preserving DCT coefficients in radius of ",...
    num2str(bandRadius)));

figure;
subplot(1,2,1);
imshow(barbara);
title("Original Image");
subplot(1,2,2);
imshow(compressedBarbara);
title("Compressed Image");