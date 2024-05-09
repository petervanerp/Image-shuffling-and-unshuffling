function [isMatch, howClose] = compareEdges(edge1, edge2, threshold)
    % edge1 and edge2 are matrices representing the RGB values of the edges
    % threshold is the maximum allowable difference between corresponding RGB values
    % below is a constant for the minimum number of pixels edge1 must have
    % in common with edge2
    requiredPixelPercentage = 0.725;
    % Ensure edge1 and edge2 have the same dimensions
    if ~isequal(size(edge1), size(edge2))
        error('Edges must have the same dimensions');
    end
    edge1 = histeq(edge1);
    edge2 = histeq(edge2);
    numPixels = max(size(edge1));
    %
    %
    % Compute the absolute differences between corresponding RGB values
    
    diffRGB = abs(edge1 - edge2);
    %{
    diffRGB = diffRGB.^2;
    diffRGB = sum(diffRGB, 3);
    diffRGB = realsqrt(diffRGB);
    %}
    % Compute the maximum difference for each color channel
    maxDiff = max(diffRGB, [], 3);
    %maxDiff = diffRGB;
    % Check if the maximum difference exceeds the threshold
    pixelsRight = vpa(sum(maxDiff(:) <= threshold));
    howClose = vpa(pixelsRight / numPixels);
    isMatch = pixelsRight / numPixels >= requiredPixelPercentage;
end
