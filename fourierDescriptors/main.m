close all;
clear;
clc;

% Convert image to a binary one
leaf = imread("../Images/exercise4/leaf.jpg");
leaf = imbinarize(rgb2gray(leaf));
% Flip pixel values so the object is white (0) and the background black (1)
leaf = ~leaf;
% Calculate the Fourier Descriptors
Fourier_Descr = calc_FD(leaf);
