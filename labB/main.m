close all;
clear;
clc;

res = "./labB_resources/mnist_training/";

%% Load the data
train_img = readMNIST(strcat(res, "train-images.idx3-ubyte"));
train_lbl = readMNIST(strcat(res, "train-labels.idx1-ubyte"));

%% Train the neural network
