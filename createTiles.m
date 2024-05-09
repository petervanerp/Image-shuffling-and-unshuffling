function [tiles, tileSize] = createTiles(imRows,imCols,cellCount)
%CREATETILES Breakes image into cellCount tiles 
%   Returns a cell array, tiles, containing 'cellCount' cells of size 
% 'tileSize'

    cellCountRoot = sqrt(cellCount);
    numRows = floor(cellCountRoot);
    while mod(cellCount, numRows) ~= 0
	    numRows = numRows - 1;
    end
    numCols = cellCount / numRows;
   
    % Create tiles
    tiles = cell(numRows, numCols);
    tileSize = [floor(imRows / numRows), floor(imCols / numCols)];
end