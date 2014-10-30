function eyered(I)
%% mode1: manual locating
% I = imread('redeye.JPG');
figure, imshow(I)

eye_points = ginput(4);
I=im2double(I);
region_left = I(eye_points(1,2):eye_points(2,2), eye_points(1,1):eye_points(2,1),:);

R_l = region_left(:,:,1);
G_l = region_left(:,:,2);
B_l = region_left(:,:,3);

% region(:,:,1)=0;
region_left(:,:,1)=0.5*(B_l+G_l);

I(eye_points(1,2):eye_points(2,2), eye_points(1,1):eye_points(2,1),:)=region_left;

region_right = I(eye_points(3,2):eye_points(4,2), eye_points(3,1):eye_points(4,1),:);
R_r = region_right(:,:,1);
G_r = region_right(:,:,2);
B_r = region_right(:,:,3);

% region(:,:,1)=0;
region_right(:,:,1)=0.5*(B_r+G_r);
% region = hsv2rgb(region);

I(eye_points(3,2):eye_points(4,2), eye_points(3,1):eye_points(4,1),:)=region_right;
figure
imshow(I)

%% mode2: automatically by YCbCr representation
clear;
I = imread('redeye.JPG');
figure, imshow(I)
I=im2double(I);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

I_r = rgb2ycbcr(I);
% figure, imshow(I(:,:,3));
mask = I_r(:,:,3)>0.7;
se = strel('rectangle',[10,10]);
mask = imdilate(mask,se);

R(mask)=0.5*(B(mask)+G(mask));

I(:,:,1) = R;
figure, imshow(I);
end