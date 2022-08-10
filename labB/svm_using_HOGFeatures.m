close all;
clear;
clc;

train_res = "./labB_resources/mnist_training/";
test_res = "./labB_resources/mnist_testing/";

%% Load data
% for training
train_img = readMNIST(strcat(train_res, "train-images.idx3-ubyte"));
train_lbl = readMNIST(strcat(train_res, "train-labels.idx1-ubyte"));
% for testing
test_img = readMNIST(strcat(test_res, "t10k-images.idx3-ubyte"));
test_lbl = readMNIST(strcat(test_res, "t10k-labels.idx1-ubyte"));

%% Extract the HOG features for the training set
num_train_img = length(train_img);
num_test_img = length(test_img);

cellSize = [8 8];
blockSize = [2 2];
blockOverlap = blockSize/2;
numBins = 9;
BlocksPerImage = floor((size(train_img(:,:,1))./cellSize - blockSize)./ ...
    (blockSize-blockOverlap) + 1);
N = prod([BlocksPerImage, blockSize, numBins]);

hog_train = zeros(num_train_img, N);

parpool(6);
parfor i=1:num_train_img
    hog_train(i,:) = extractHOGFeatures(train_img(:,:,i), ...
        "CellSize",cellSize, ...
        "BlockSize", blockSize, ...
        "BlockOverlap", blockOverlap);
end
delete(gcp('nocreate'));
% %% Train the SVM
% t = templateSVM('Standardize',true);
% Mdl = fitcecoc(hog_train,train_lbl','Learners',t);
% % Save the SVM
% save Mdl;
%% Extract the HOG features for the test set
hog_test = zeros(num_test_img, N);

parpool(6);
parfor i=1:num_test_img
    hog_test(i,:) = extractHOGFeatures(test_img(:,:,i), ...
        "CellSize",cellSize, ...
        "BlockSize", blockSize, ...
        "BlockOverlap", blockOverlap);
end
delete(gcp('nocreate'));
%% Predict the labels
% Load the SVM
load Mdl.mat;
pred = predict(Mdl, hog_test);
% Calculate the confusion matrix
confMat = confusionMatrix(pred', test_lbl);