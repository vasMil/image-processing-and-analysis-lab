close all;
clear;
clc;

train_res = "../labB_resources/mnist_training/";

train_img = readMNIST(strcat(train_res, "train-images.idx3-ubyte"));

cellSize = [4 4];
blockSize = [2 2];
blockOverlap = [1 1];

hogVect = HOGFeatures(train_img(:,:,1), cellSize, blockSize, blockOverlap, 9);

% % imgRes = floor(size(train_img(:,:,1)) ./ cellSize) .* cellSize;
% % res_img = imresize(train_img(:,:,1), imgRes);
% res_img = train_img(1:24,1:24,1);
% hog_test_res = extractHOGFeatures(res_img, ...
%         "CellSize",cellSize, ...
%         "BlockSize", blockSize, ...
%         "BlockOverlap", blockOverlap);
hog_test = extractHOGFeatures(train_img(:,:,1), ...
    "CellSize",cellSize, ...
    "BlockSize", blockSize, ...
    "BlockOverlap", blockOverlap);