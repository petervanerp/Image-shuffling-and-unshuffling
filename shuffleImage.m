function [shuffledImage, shuffledOrder] = shuffleImage(originalImage, cellCount)
%SHUFFLEIMAGE Breakes image into evenly sized cells and randomly 
% shuffles their order
%   Takes an input, cellCount, to determine the number of cells the image
%   is to be split. Returns the shuffled image.

    [imRows, imCols, ~] = size(originalImage);
    [tiles, tileSize] = createTiles(imRows,imCols,cellCount);

    % Populate tiles
    [numRows, numCols] = size(tiles);
    for row = 1:numRows
        for col = 1:numCols
            % Calculate tiles from original image
            rows = (1:tileSize(1)) + (row-1) * tileSize(1);
            cols = (1:tileSize(2)) + (col-1) * tileSize(2);
            tiles{row, col} = originalImage(rows, cols, :);
        end
    end

    % Shuffle tiles
    N = numRows * numCols;
    shuffledOrder = randperm(N);
    shuffledTiles = cell(size(tiles));
    for index = 1:N
        [row, col] = ind2sub(size(tiles), index);
        [shuffledRow, shuffledCol] = ind2sub(size(tiles), shuffledOrder(index));
        shuffledTiles{shuffledRow, shuffledCol} = tiles{row, col};
    end

    % Recreate the shuffled image
    shuffledImage = cell2mat(shuffledTiles);
end