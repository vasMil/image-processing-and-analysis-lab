close all;
clear;
clc;

test_res = "./labB_resources/mnist_testing/";

%% Load
% for testing
test_img = readMNIST(strcat(test_res, "t10k-images.idx3-ubyte"));
test_lbl = readMNIST(strcat(test_res, "t10k-labels.idx1-ubyte"));

num_of_test_samples = length(test_img);
img_dim = size(test_img);
img_dim = img_dim(1:2);

% Canonicalize the arrays so they may be used as inputs in matlab func
test_img = reshape(test_img,[img_dim, 1, num_of_test_samples]);
test_lbl = categorical(test_lbl');

% Load the pretrained CNN
CNN = load("trained_cnn.mat");
CNN = CNN.CNN;

%% Evaluate the test set of images using the CNN
cnn_pred = classify(CNN, test_img);
confMat = confusionMatrix(cnn_pred, test_lbl);
