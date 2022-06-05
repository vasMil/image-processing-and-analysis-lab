close all;
clear;
clc;

test_path = "../Images/exercise6/test/";
db_path = "../Images/exercise6/DataBase/";

perc_hist = driver_helper(test_path, db_path,...
    @retrieveImage_histogram);