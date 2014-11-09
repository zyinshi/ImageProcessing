%input: filename of movie, averaging method type: 'mean' 'median' 'mode', number of processing frames
%output: image of static scene

function temporalAvg( movieFile, type, nFrames)

mov=VideoReader(movieFile);
% vidFrames=read(mov);
if ( nargin < 3 )       %default number : all frames 
    nFrames=mov.NumberOfFrames;
end 

if (strcmp(type, 'mean'))
    tmp = read(mov,1);
    tmp = im2double(tmp);
    for k=2:nFrames
        img = read(mov,k);
        img = im2double(img);
        tmp = (tmp*(k-1)+img)./k;
    end
    figure, imshow(tmp)
    imwrite(tmp,['avg_','mean.png']);
end

if(strcmp(type, 'median'))
    vframes = read(mov,[1 nFrames]);
    img = zeros(size(vframes(:,:,:,1)),'uint8');
    for ch =1:3
      img(:,:,ch) = median(vframes(:,:,ch,:),4);
    end
    imwrite(img,['avg_','median.png']);
    figure, imshow(img)
end


if(strcmp(type, 'mode'))
    vframes = read(mov,[1 nFrames]);
    img = zeros(size(vframes(:,:,:,1)),'uint8');
    for ch =1:3
      img(:,:,ch) = mode(vframes(:,:,ch,:),4);
    end
    imwrite(img,['avg_','mode.png']);
    figure, imshow(img)
end

end

