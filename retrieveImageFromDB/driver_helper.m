function [correct_perc] = driver_helper(test_path, db_path, retr_func, ...
    preserve_perc)
    if nargin < 4
        preserve_perc = 100;
    end
    % Get all the paths to *.jpg inside the test folder
    path_to_test_images = fullfile(test_path, "*.jpg");
    fileStruct = dir(path_to_test_images);

    % Create an array to save the paths of the images retrieved
    image_db_paths = strings(length(fileStruct), 1);
    % Preserve users decision to whether the image retrieved
    % is the correct one or not
    user_decisions = false(length(fileStruct), 1);

    for i=1:length(fileStruct)
        % Get the test image
        image_test = imread(...
            fullfile(fileStruct(i).folder, fileStruct(i).name));

        % Find the path of the retrieved image from db
        if preserve_perc == 100
            image_db_paths(i) = retr_func(image_test, ...
                db_path);
        else
            image_db_paths(i) = retr_func(image_test, ...
                            db_path, preserve_perc);
        end
        
        % Display the two
        figure(1);
        subplot(1,2,1);
        imshow(image_test);
        title("Original Image");
        subplot(1,2,2);
        imshow(imread(image_db_paths(i)));
        title("Image retrieved from DB");
        
        % Request the user provide an answer to whether the image retrieved
        % is the correct one or not
        res = questdlg('Is the image retrieved correct?', ...
            'User Decision', "Yes", "No", "No");
        if res == "No"
            user_decisions(i) = 0;
        elseif res == "Yes"
            user_decisions(i) = 1;
        else
            close all;
            error("Error: User did not make a decision!");
        end
    end

    % Close last figure that is left open
    close all;
    % Get the percentage of correct retrievals, based on users decisions
    correct_perc = sum(user_decisions)/length(user_decisions);
end

