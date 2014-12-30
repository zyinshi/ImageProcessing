%% part 1: find mickey
img = imread( 'example.png');
filter = imread('filter.jpg');

filter = im2double(filter);
filter = filter - mean(filter(:));
img = im2double(img);
imgp = img - mean(img(:));
cc = conv2(filter,imgp);
% cc(:)=abs(cc(:));
imagesc(cc)
index=find(cc==max(cc(:)));
[ypeak, xpeak] = ind2sub(size(cc),index)
figure, imagesc(img);colormap(gray)
hold on,
rect = zeros(size(xpeak),4);
for i=1:size(xpeak)
    rect(i,:) = [xpeak(i)-size(filter,1),ypeak(i)-size(filter,2),size(filter)];
    rectangle('Position',rect(i,:),'EdgeColor','r','LineWidth',2 );
end

%% part 2: error rate
figure, imshow(img);
gt = ginput(6);

grect = zeros(3,4);
grect(1,:) = [gt(1,:), gt(2,1)-gt(1,1),gt(2,2)-gt(1,2) ];
grect(2,:) = [gt(3,:), gt(4,1)-gt(3,1),gt(4,2)-gt(3,2) ];
grect(3,:) = [gt(5,:), gt(6,1)-gt(5,1),gt(6,2)-gt(5,2) ];
for j = 1:3
    inarea = rectint(rect(1,:),grect(j,:));
    unionCoords=[min(rect(1,1),grect(j,1)),min(rect(1,2),grect(j,2)),max(rect(1,1)+rect(1,4),gt(2,1)),max(rect(1,2)+rect(1,3),gt(2,2))];
    union=(unionCoords(3)-unionCoords(1)+1)*(unionCoords(4)-unionCoords(2)+1);
    acc=inarea/union
end

%% part 3: input groundtruth

img = imread( 'car5.jpg');
filter = imread('cartemplate.jpg');
gt = load('car5.txt');
% preprocess
filter = im2double(filter);
bf = im2bw(filter, 0.4);
[t,l]=find(bf==0);
filter = filter(min(t):max(t),min(l):max(l));
filter = filter - mean(filter(:));
h = fspecial('gaussian',[50,50],10);
filter = imfilter(filter,h);

img = im2double(img);
imgp = img - mean(img(:));
h = fspecial('gaussian',[10,10],5);
imgp = imfilter(imgp,h);

% make a filter pyramid
f=cell(3,1);
f{3,1}=imresize(filter, 0.7*size(img,1)/size(filter,1));
f{2,1}=imresize(filter, 0.5*size(img,1)/size(filter,1));
f{1,1}=imresize(filter, 0.3*size(img,1)/size(filter,1));
cc=cell(3,1);
rectarea = zeros(1,4);
ind=zeros(1,2);
res=zeros(size(img));
center = zeros(3,2);
for i = 1: size(f,1) 
    c = conv2(imgp,f{i,1});
    sz = size(f{i,1});
    c = mat2gray(c);
    
    cc{i,1} = c(sz(1)/2+1:end-sz(1)/2+1,sz(2)/2+1:end-sz(2)/2+1);
    figure,imagesc(cc{i,1});
    res = res + cc{i,1};
    cen=find(cc{i,1}==max(cc{i,1}(:)));
    [center(i,1),center(i,2)] = ind2sub(size(res),cen);

end
res= mat2gray(res);
index=find(res==max(res(:)));
[ypeak, xpeak] = ind2sub(size(res),index);
rescen = [ypeak, xpeak];
diff = repmat(rescen,[3,1])-center;
dis = sum(diff.*diff,2);
[mindis, scale]=min(dis);
bbsz = size(f{scale});
figure, imshow(img);
hold on,
rect = [xpeak-bbsz(2)/2,ypeak-bbsz(1)/2,bbsz(2),bbsz(1)];
rectangle('Position',rect,'EdgeColor','r','LineWidth',2 );
grect = [gt(1,:), gt(2,1)-gt(1,1),gt(2,2)-gt(1,2) ];
inarea = rectint(rect,grect);
union = grect(3)*grect(4)+rect(3)*rect(4)-inarea;
acc=inarea/union








