close all;
clear;
clc;

image_test = imread("../Images/exercise6/test/th_1202_16colors.jpg");
db_path = "../Images/exercise6/DataBase/";

% For every image in test folder call retrieveImage_histogram
image_db_path = retrieveImage_histogram(image_test, db_path);

% Display images
subplot(1,2,1);
imshow(image_test);
title("Original Image");

subplot(1,2,2);
imshow(imread(image_db_path));
title("Image retrieved from DB");