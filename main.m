image = imread("vista.jpg");
TILE_COUNT = 16;

shuffledImage = shuffleImage(image, TILE_COUNT);
unshuffledImage = unshuffleImage(shuffledImage, TILE_COUNT, 50);

subplot(1, 2, 1); imshow(shuffledImage);
subplot(1, 2, 2); imshow(unshuffledImage);
