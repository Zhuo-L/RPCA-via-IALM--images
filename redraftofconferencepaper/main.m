%addpath('..\images.images') replace to include any folder by name
clc;
clear all;
close all;
subject = "Images";
z=1;
myDir = subject+".images"; %gets directory
myFiles = dir(fullfile(myDir,'*.jpg')); %gets all wav files in struct
[N,M] = size(imread(fullfile(myDir,myFiles(1).name))); 
%disp(length(myFiles));
Y = zeros(N*M,length(myFiles));
F = zeros(N*3,M*length(myFiles));
%%
for k = 1:length(myFiles)
  baseFileName = myFiles(k).name;
  fullFileName = fullfile(myDir, baseFileName);
  fprintf(1, 'Now reading %s\n', fullFileName);
  [Img] = imread(fullFileName);
  [N,M]=size(Img);
  Y(:,k)=Img(:);
  %imshow(uint8(reshape(Y(:,k),[N,M])));
  F(1:N,((k-1)*M)+1:(k*M)) = reshape(Y(:,k),[N,M]);
end
%%
lambda=0.001;
%lambda=0.080; %for WSNM
c1=.6;
c2=0.2;
mu=0.15;
tol=1e-1000;
max_iter=100;
%%
%[L, S] = WSNM_PCA(Y, c1, c2, lambda, mu, tol, max_iter);
[S,L] = inexact_alm_rpca(Y,lambda);
%%
for k=1:length(myFiles)
    F((N+1:2*N),(((k-1)*M)+1):(k*M)) = reshape(L(:,k),[N,M]);
    F((2*N+1:3*N),((k-1)*M)+1:(k*M)) = reshape(S(:,k),[N,M]);
end
imshow(uint8(F));
disp(rank(L));disp(" and ");disp(rank(S));
ideal = imread(fullfile(myDir,subject+".jpg"));
 sheet=4;
             filename = 'reverse_algo.xls';
         header = {'Image','PSNR','SSIM'};
         xlswrite(filename,header,sheet,'A1');
for i=1:length(myFiles)
PSNR = psnr(uint8(reshape(L(:,i),[N,M])),ideal);
SSIM = ssim(uint8(reshape(L(:,i),[N,M])),ideal);
fprintf('PSNR is =');disp(PSNR);%fprintf('\n');
fprintf('SSIM is =');disp(SSIM);%fprintf('\n');
Array=[i, PSNR,SSIM];
 z=z+1; 
         k= strcat('A',num2str(z));
         xlswrite(filename,Array,sheet,k);
end