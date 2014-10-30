function histo_equalization(I)

% I = imread('fog.jpg');
subplot(4,4,1), imshow(I);
subplot(4,4,2), imhist(I(:,:,1));
subplot(4,4,3), imhist(I(:,:,2));
subplot(4,4,4), imhist(I(:,:,3));

%% Global equalization
I1 = zeros(size(I),'uint8');
 for ch=1:3
       I1(:,:,ch) = histeq(I(:,:,ch));
 end
subplot(4,4,5), imshow(I1)
subplot(4,4,6), imhist(I1(:,:,1));
subplot(4,4,7), imhist(I1(:,:,2));
subplot(4,4,8), imhist(I1(:,:,3));

%% Adaptive equalization
I2 = zeros(size(I),'uint8');
 for ch=1:3
       I2(:,:,ch) = adapthisteq(I(:,:,ch));
 end
subplot(4,4,9), imshow(I2)
subplot(4,4,10), imhist(I2(:,:,1));
subplot(4,4,11), imhist(I2(:,:,2));
subplot(4,4,12), imhist(I2(:,:,3));

%%  Modification on HSV
hsvI = rgb2hsv(I);
for ch=2:3
       hsvI(:,:,ch) = adapthisteq(hsvI(:,:,ch));
end
hsvI1 = hsv2rgb(hsvI);
subplot(4,4,13), imshow(hsvI1)
subplot(4,4,14), imhist(hsvI(:,:,1));
subplot(4,4,15), imhist(hsvI(:,:,2));
subplot(4,4,16), imhist(hsvI(:,:,3));

%% Hist motification
% case 1: lighter(quatratic CDF)
I3 = zeros(size(I),'uint8');
target = [0:255].^2;
target = target/(max(target)-min(target));
for ch =1:3
    s = I(:,:,ch);
    cdf = getImageCDF(s);
    LU = interp1(target,0:255,cdf);
    res = interp1(0:255, LU, double(s(:)));
    I3(:,:,ch) = uint8(reshape(res, size(s)));
end
figure;
subplot(3,5,1), imshow(I3)
subplot(3,5,2), plot(target),axis([0 256 0 1])
subplot(3,5,3), imhist(I3(:,:,1));
subplot(3,5,4), imhist(I3(:,:,2));
subplot(3,5,5), imhist(I3(:,:,3));

% case 2: darker(quatratic CDF)
I4 = zeros(size(I),'uint8');
target = [0:255].^0.5;
target = target/(max(target)-min(target));
for ch =1:3
    s = I(:,:,ch);
    cdf = getImageCDF(s);
    LU = interp1(target,0:255,cdf);
    res = interp1(0:255, LU, double(s(:)));
    I4(:,:,ch) = uint8(reshape(res, size(s)));
end
% figure;
subplot(3,5,6), imshow(I4)
subplot(3,5,7), plot(target),axis([0 256 0 1])
subplot(3,5,8), imhist(I4(:,:,1));
subplot(3,5,9), imhist(I4(:,:,2));
subplot(3,5,10), imhist(I4(:,:,3));

%case 3: separate
I5 = zeros(size(I),'uint8');
x = [-127:128].^2;
target = cumsum(x);
target = [0 unique(target/(max(target)-min(target)))];
% target = sigmf(z,[100 0]);
% target = target/(max(target)-min(target));
for ch =1:3
    s = I(:,:,ch);
    cdf = getImageCDF(s);
    LU = interp1(target,0:255,cdf);
    res = interp1(0:255, LU, double(s(:)));
    I5(:,:,ch) = uint8(reshape(res, size(s)));
end
% figure;
subplot(3,5,11), imshow(I5)
subplot(3,5,12), plot(target),axis([0 256 0 1])
subplot(3,5,13), imhist(I5(:,:,1));
subplot(3,5,14), imhist(I5(:,:,2));
subplot(3,5,15), imhist(I5(:,:,3));

end
