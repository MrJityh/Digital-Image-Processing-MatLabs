% color_histogram.m
function color_hist(rgbImage)
    % Defining each color plane
    red = rgbImage(:, :, 1);
    green = rgbImage(:, :, 2);
    blue = rgbImage(:, :, 3);
    levels = 256; % 8-bit images

    % Determine the maximum value of all 3 planes and use as y-limit
    [~,Fred] = mode(red,'all');
    [~,Fgreen] = mode(green, 'all');
    [~,Fblue] = mode(blue, 'all');
    ylimit = max([Fblue,Fgreen,Fred]);
    
    %## Histogram for Red (3 rows, 1 column, x subplot)
    imhist(red, levels); title('Red');
    % change graph color to red
    myHist = findobj(gca, 'Type', 'Stem'); myHist.Color = [1 0 0];
    % change plot limits
    xlim([0 levels-1]); ylim([0 ylimit]);

    %## Histogram for Green
    figure; imhist(green, levels); title('Green');
    % change graph color to green
    myHist = findobj(gca, 'Type', 'Stem'); myHist.Color = [0 1 0];
    % change plot limits
    xlim([0 levels-1]); ylim([0 ylimit]);

    %## Histogram for Blue
    figure; imhist(blue, levels); title('Blue');
    % change graph color to blue
    myHist = findobj(gca, 'Type', 'Stem'); myHist.Color = [0 0 1];
    % change plot limits
    xlim([0 levels-1]); ylim([0 ylimit]);
end