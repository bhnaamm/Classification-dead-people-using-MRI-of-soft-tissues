close all;
clear all;
clc


%%
%-------------Read images and convert them to double,-picture is in the grayscale format
directory = uigetdir('C:\','Select the Database directory');

images_dir =dir(fullfile(directory,'*.tif'));




%%




length_images= length(images_dir);


wname = 'db1';
% se=strel('disk',4,8);
% fudgeFactor = 1.1;
for i=1:length_images
    currentfilename = images_dir(i).name;
    currentimage = imresize(imread(currentfilename),[408 408]);
    I=medfilt2(im2double(currentimage));   %median filter for denoising
    
    background=imopen(I,strel('disk',20));
    
    I2=imsubtract(I,background);
    
    I3=imadjust(I2,stretchlim(I2),[0 1]);
    
    level=1.6*graythresh(I3);
    bw=im2bw(I3,level);
    bw2=imclose(bw,strel('disk',10));
    
    bw3=bwareaopen(bw2,50,4);
  
    
    features=bw3;
    inputs{i}=imresize(features,[1 166464]);
   
end

inpts=cat(1,inputs{:});
% target= ones(size(inputs, 1));
save('inpts.mat','inpts');
% save('target.mat','target');


    imshow(background),title('bck');
    figure, imshow(I2),title('sbtrct');
    figure, imshow(I3),title('adjust');
    figure, imshow(bw2),title('clse');
    figure, imshow(bw3),title('barea');
    
    BWoutline = bwperim(bw3);
    Segout = I;
    Segout(BWoutline) = 255;
    figure, imshow(Segout)
