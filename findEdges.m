function [left, right, up, down] = findEdges(image)
    left = image(:, 1, :);
    right = image(:, end, :);
    up = image(1, :, :);
    down = image(end, :, :);
end