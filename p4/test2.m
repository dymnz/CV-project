% Target
xImg1 = imread('./data/q3.jpg');
xImg1 = Preprocessing(xImg1);
% Photo
xImg2 = imread('./data/q4.jpg');
xImg2 = Preprocessing(xImg2);

imwrite(xImg1, './histeq_q3.jpg');
imwrite(xImg2, './histeq_q4.jpg');