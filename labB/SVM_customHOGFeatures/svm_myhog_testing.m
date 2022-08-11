close all;
clear;
clc;

test_res = "../labB_resources/mnist_testing/";

%% Load data
% for testing
test_img = readMNIST(strcat(test_res, "t10k-images.idx3-ubyte"));
test_lbl = readMNIST(strcat(test_res, "t10k-labels.idx1-ubyte"));

%% Extract the HOG features for the test set
num_test_img = length(test_img);

cellSize = [4 4];
blockSize = [2 2];
blockOverlap = blockSize/2;
numBins = 9;
BlocksPerImage = floor((size(test_img(:,:,1))./cellSize - blockSize)./ ...
    (blockSize-blockOverlap) + 1);
N = prod([BlocksPerImage, blockSize, numBins]);

hog_test = zeros(num_test_img, N);

parpool(6);
parfor i=1:num_test_img
    hog_test(i,:) = HOGFeatures(test_img(:,:,i), cellSize, ...
        blockSize, blockOverlap, numBins);
end
delete(gcp('nocreate'));
%% Predict the labels
% Load the SVM
load svm_myHog.mat;
pred = predict(svm_myHog, hog_test);
pred = pred';

% Calculate the confusion matrix
confMat = confusionMatrix(pred, test_lbl);

% Calculate the accuracy of the model
svm_accur = sum(pred == test_lbl)/length(pred);