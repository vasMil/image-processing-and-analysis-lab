function [data] = readMNIST(path)

% Open the stream
stream = fopen(path, 'r', 'b'); % r -> read only, b -> Big Endian
if (stream < 0)
    error(strcat("Unable to open file at path: ", path));
end

% Decipher the idx coding (in bytes) as
% magic number - 0x00
% magic number - 0x00
% magic number - type of data (ex. int)
% magic number - number of dimensions
% (this last byte determines how many 32 bit numbers are following, 
% specifying the size of each dimension)

% size in dimension 0: 32 bit integer specifying the amount of data 
% (images or items) the file contains
% size in dimension 1: -||-
% size in dimension 2: -||-
% data

magic_number = fread(stream, 4);

% Will just test if the first two bytes of the magic number are 0 and the
% third is an 8 (since this is what my data should look like).
if (~isequal(magic_number(1:3)', [0 0 8]))
    fclose(stream);
    error("Unexpected MNIST magic number");
end

% Find the amount of samples in the file
num_sampl = fread(stream, 1, 'uint32');
% Get the dimensions of each sample
dim_size = fread(stream, magic_number(4) - 1, 'uint32');

if (magic_number(4) == 1)
    dim_size = 1;
end

% Create the cell array in each cell of which you will preserve a matrix or
% an item (this cell array you will be returning)
data = zeros([dim_size', num_sampl]);
for i=1:num_sampl
    if (magic_number(4) == 1)
        data(i) = fread(stream, dim_size');
    else
        data(:,:,i) = fread(stream, dim_size');
    end
end

% Close the stream
fclose(stream);
end

