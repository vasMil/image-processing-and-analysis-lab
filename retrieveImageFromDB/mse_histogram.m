function [mse_hist] = mse_histogram(image_test_hist, image_db)
% Find histogram of image in db (image_db)
% Calculate the MSE between image_test_hist and image_db
% Return that MSE
[M,N,d] = size(image_db);

image_db_hist = zeros(256, d);
for i=1:d
    image_db_hist(:,i) = histcounts(image_db(:,:,i), 256);
end
mse_hist = immse(image_test_hist, image_db_hist);

end

