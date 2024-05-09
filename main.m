image1 = imread("goku1.jpg");
image2 = imread("vista.jpg");
image3 = imread("broly.jpg");
TILE_COUNT = 16;

shuffledImage = shuffleImage(image1, TILE_COUNT);
unshuffledImage = unshuffleImage(shuffledImage, TILE_COUNT, 50);

subplot(1, 2, 1); imshow(shuffledImage);
subplot(1, 2, 2); imshow(unshuffledImage);
