close all;
clear;
clc;

train_res = "../labB_resources/mnist_training/";

%% Load data
% for training
train_img = readMNIST(strcat(train_res, "train-images.idx3-ubyte"));
train_lbl = readMNIST(strcat(train_res, "train-labels.idx1-ubyte"));

%% Extract the HOG features for the training set
num_train_img = length(train_img);

cellSize = [4 4];
blockSize = [2 2];
blockOverlap = blockSize/2;
numBins = 9;
BlocksPerImage = floor((size(train_img(:,:,1))./cellSize - blockSize)./ ...
    (blockSize-blockOverlap) + 1);
N = prod([BlocksPerImage, blockSize, numBins]);

hog_train = zeros(num_train_img, N);

disp([string(datetime('now')) "Starting HOG Features extraction"]);
parpool(6);
parfor i=1:num_train_img
    hog_train(i,:) = HOGFeatures(train_img(:,:,i), cellSize, ...
        blockSize, blockOverlap, numBins);
end
disp([string(datetime('now')) "HOG Features extraction done"]);
delete(gcp('nocreate'));
%% Train the SVM
disp([string(datetime('now')) "Starting SVM training"]);
t = templateSVM('Standardize',true);
svm_myHog = fitcecoc(hog_train,train_lbl','Learners',t);
% Save the SVM
save svm_myHog;
