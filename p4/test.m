Image = rgb2gray(imread('./cat/cat (7).jpg'));

Image = imresize(Image, [512 NaN]);
Image = imguidedfilter(Image);
img = edge(Image,'Prewitt');

imshow(img);