function [image_db_path] = retrieveImage_histogram(image_test, db_path)
[M,N,d] = size(image_test);

% Preprocess image_test
hist_test = zeros(256, d);
for i=1:d
    hist_test(:, i) = histcounts(image_test(:,:,i), 256)';
end

% Process every image in the db
% Calculate the MSE between image_test and image_db
path_to_images = fullfile(db_path, "*.jpg");
fileStruct = dir(path_to_images);
filenames = strings(length(fileStruct), 1);
MSEs = zeros(length(fileStruct), 1);
for i=1:length(fileStruct)
    filenames(i) = fullfile(fileStruct(i).folder, fileStruct(i).name);
    MSEs(i) = mse_histogram(hist_test, imread(filenames(i)));
end

% Select the image with the smallest mse
[~, min_mse_ind] = min(MSEs);

% Return that image
image_db_path = filenames(min_mse_ind);

end

