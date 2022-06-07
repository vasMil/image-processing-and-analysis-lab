function [image_db_path] = retrieveImage_DCT(image_test, db_path,...
    preserve_perc, blocksize)
    %% Handle default arguments
    [M,N,d] = size(image_test);
    if nargin < 3
        preserve_perc = 100;
        blocksize = M;
    end
    if nargin < 4
        blocksize = M;
    end
    %% Preprocess image_test
    dct_test = zeros(M,N,d);
    for i=1:d
        % Move to the frequency domain
        dct_test(:,:,i) = dct2(im2double(image_test(:,:,i)));
        % Apply the threshold filter
        dct_test(:,:,i) = applyGlobalThresholdMask(...
            dct_test(:,:,i),blocksize,preserve_perc);
    end
    %% Process every image in the db - calculate MSEs using dct_test
    % Calculate the MSE between image_test and image_db
    path_to_images = fullfile(db_path, "*.jpg");
    fileStruct = dir(path_to_images);
    filenames = strings(length(fileStruct), 1);
    MSEs = zeros(length(fileStruct), 1);
    for i=1:length(fileStruct)
        filenames(i) = fullfile(fileStruct(i).folder, fileStruct(i).name);
        MSEs(i) = mse_DCT(dct_test, imread(filenames(i)),...
            preserve_perc, blocksize);
    end

    % Select the image with the smallest mse
    [~, min_mse_ind] = min(MSEs);

    % Return that image
    image_db_path = filenames(min_mse_ind);
end

