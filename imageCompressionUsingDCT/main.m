close all;
clear;
clc;

blockSize = 32;
r = 5:50;

load("../Images/exercise2/barbara.mat");
barbara = im2double(barbara);

MSE_zonal = zeros(size(r));
MSE_typ_zonal = zeros(size(r));
MSE_thres = zeros(size(r));
MSE_glob_thres = zeros(size(r));

for i=1:length(r)
    [MSE_zonal(i), MSE_typ_zonal(i), MSE_thres(i), MSE_glob_thres(i)] =...
        compressImage(barbara, blockSize, r(i), 0);
end

figure;
hold on;
plot(r,MSE_zonal,'-or');
plot(r,MSE_typ_zonal,'-ob');
plot(r,MSE_thres,'-og');
plot(r,MSE_glob_thres,'-om');
legend("zonal", "typical zonal", "threshold", "global threshold");
xlabel("Number of coefficients preserved (r)");
ylabel("MSE");