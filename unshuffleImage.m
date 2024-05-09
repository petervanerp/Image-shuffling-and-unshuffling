function unshuffledImage = unshuffleImage(originalImage, cellCount, thresholdValue)% here, originalImage is the image after shuffling
    % Load the image
    %originalImage = imread(imagePath);
    [imRows, imCols, ~] = size(originalImage);
    [tiles, tileSize] = createTiles(imRows,imCols,cellCount);

    thresholdValueX = thresholdValue;
    thresholdValueY = thresholdValue;

    % Create tiles
    [numRows, numCols] = size(tiles);
    for row = 1:numRows
        for col = 1:numCols
            rows = (1:tileSize(1)) + (row-1) * tileSize(1);
            cols = (1:tileSize(2)) + (col-1) * tileSize(2);
            if row == numRows  % Adjust for any uneven division on the last row
                rows = (row-1) * tileSize(1) + 1 : size(originalImage, 1);
            end
            if col == numCols  % Adjust for any uneven division on the last column
                cols = (col-1) * tileSize(2) + 1 : size(originalImage, 2);
            end
            tiles{row, col} = originalImage(rows, cols, :);
        end
    end

    % Get edges for each tile
    edges = cell(numRows, numCols, 4);
    for row = 1:numRows
        for col = 1:numCols
            [edges{row, col, 1}, edges{row, col, 2}, edges{row, col, 3}, edges{row, col, 4}] = findEdges(tiles{row, col});
        end
    end

    % for each tile there are four edges that could be matched up with
    % another tile. so for example, matches{1, 1, 1} is the tile that
    % matched with the left side of the tile in the top left
    matches = cell(numRows, numCols, 4);
    for row = 1:numRows
        for col = 1:numCols
            matches{row, col, 1} = [0, 0, 0];
            matches{row, col, 2} = [0, 0, 0];
            matches{row, col, 3} = [0, 0, 0];
            matches{row, col, 4} = [0, 0, 0];
        end
    end
    for row = 1:numRows
        for col = 1:numCols % go through every tile
            for matchedRow = 1:numRows 
                for matchedCol = 1:numCols % then go through every other tile
                    if row ~= matchedRow || col ~= matchedCol
                        [isMatch, howClose] = compareEdges(edges{row, col, 1}, edges{matchedRow, matchedCol, 2}, thresholdValueX);
                        if isMatch && howClose > matches{row, col, 1}(3) && howClose > matches{matchedRow, matchedCol, 2}(3)
                                matches{row, col, 1} = [matchedRow, matchedCol, howClose];% if you find a match, record that tile's location and its closeness in the corresponding index
                                matches{matchedRow, matchedCol, 2} = [row, col, howClose];% update the corresponding index for the matched tile to match
                        end
                        [isMatch, howClose] = compareEdges(edges{row, col, 2}, edges{matchedRow, matchedCol, 1}, thresholdValueX);
                        if isMatch && howClose > matches{row, col, 2}(3) && howClose > matches{matchedRow, matchedCol, 1}(3)
                                matches{row, col, 2} = [matchedRow, matchedCol, howClose];
                                matches{matchedRow, matchedCol, 1} = [row, col, howClose];
                        end
                        [isMatch, howClose] = compareEdges(edges{row, col, 3}, edges{matchedRow, matchedCol, 4}, thresholdValueY);
                        if isMatch && howClose > matches{row, col, 3}(3) && howClose > matches{matchedRow, matchedCol, 4}(3)
                                matches{row, col, 3} = [matchedRow, matchedCol, howClose];
                                matches{matchedRow, matchedCol, 4} = [row, col, howClose];
                        end
                        [isMatch, howClose] = compareEdges(edges{row, col, 4}, edges{matchedRow, matchedCol, 3}, thresholdValueY);
                        if isMatch && howClose > matches{row, col, 4}(3) && howClose > matches{matchedRow, matchedCol, 3}(3)
                                matches{row, col, 4} = [matchedRow, matchedCol, howClose];
                                matches{matchedRow, matchedCol, 3} = [row, col, howClose];
                        end
                    end
                end
            end
        end
    end

    unshuffledImage = cell(numRows, numCols);

    lastMatched = [0 0]; % the coordinates of the last tile that was successfully placed in its original spot
    for row = 1:numRows
        for col = 1:numCols
            if(matches{row, col, 1}(1) == 0 && matches{row, col, 3}(1) == 0)
                lastMatched = [row, col]
                unshuffledImage{1, 1} = tiles{row, col}; % find the top left tile
            end
        end
    end

    % using the coordinates of the last placed tile, you can find the one
    % that should go to the right/left/below it. then, having placed that
    % tile, you can update lastMatched with the coordinates of that tile, 
    % and the cycle should begin anew, until you run out of tiles
    goingLeft = 0;
    for row = 1:numRows
        for col = 1:numCols
            if (row ~= 1 || col ~= 1)% dont touch the top left tile
                if goingLeft % if going left
                    if matches{lastMatched(1), lastMatched(2), 1}(1) ~= 0 % make sure theres a tile left of the last one placed
                        lastMatched = [matches{lastMatched(1), lastMatched(2), 1}(1), matches{lastMatched(1), lastMatched(2), 1}(2)];
                        unshuffledImage{row, numCols - (col-1)} = tiles{lastMatched(1), lastMatched(2)};
                    elseif matches{lastMatched(1), lastMatched(2), 4}(1) ~= 0 % if not, check below
                        lastMatched = [matches{lastMatched(1), lastMatched(2), 4}(1), matches{lastMatched(1), lastMatched(2), 4}(2)];
                        unshuffledImage{row, 1} = tiles{lastMatched(1), lastMatched(2)};
                        goingLeft = 0; % turn around
                    else
                    end
                else  % if going right
                    if matches{lastMatched(1), lastMatched(2), 2}(1) ~= 0 % make sure theres a tile right of the last one placed
                        lastMatched = [matches{lastMatched(1), lastMatched(2), 2}(1), matches{lastMatched(1), lastMatched(2), 2}(2)];
                        unshuffledImage{row, col} = tiles{lastMatched(1), lastMatched(2)};
                    elseif matches{lastMatched(1), lastMatched(2), 4}(1) ~= 0 % if not, check below
                        lastMatched = [matches{lastMatched(1), lastMatched(2), 4}(1), matches{lastMatched(1), lastMatched(2), 4}(2)];% place the tile found below
                        unshuffledImage{row, numCols} = tiles{lastMatched(1), lastMatched(2)};
                        goingLeft = 1; % turn around
                    else
                    end
                end
            end
        end
    end
    unshuffledImage = cell2mat(unshuffledImage);
    imshowpair(originalImage, unshuffledImage, 'montage');
end