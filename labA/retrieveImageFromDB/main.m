close all;
clear;
clc;

test_path = "../Images/exercise6/test/";
db_path = "../Images/exercise6/DataBase/";

perc_hist = driver_helper(test_path, db_path,...
    @retrieveImage_histogram); % res = 0.4

perc_dct_100 = driver_helper(test_path, db_path,...
    @retrieveImage_DCT, 100); % res = 0.7 
perc_dct_50 = driver_helper(test_path, db_path,...
    @retrieveImage_DCT, 50); % res = 0.7
perc_dct_10 = driver_helper(test_path, db_path,...
    @retrieveImage_DCT, 10); % res = 0.5
