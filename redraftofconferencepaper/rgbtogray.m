RGB = imread('ABC.capture3.jpg');
imshow(RGB);
I = rgb2gray(RGB);
figure
imshow(I);
imwrite(I,'ABC.capture3.jpg');