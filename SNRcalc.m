function SNRcalc

M = imread('X:\AlexData\Torsten\UPLOAD\NMrevision\mask_021508_100x#06_t75.tif');

% I =imread(['X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_01\images\060829_RCC4-CMV93-LMP_01_T000.tif']);
% I = imread(['X:\AlexData11\EB3-Clip\080417_RPE1_transient_tiff\080417_RPE1_NZ-ns_CLIP170_03\images\080417_RPE1_NZ-ns_CLIP170_03_T000.tif']);
I = imread(['X:\AlexData\Torsten\UPLOAD\NMrevision\021508_100x#06_t75.tif']);
% I = imread(['X:\AlexData\Torsten\xy_resolution\cell1\100x\images\021508_100x#06_t75.tif']);
i = 1;

N = [ 34 60 105 149 184 216 248 277 309 338 367] ; % Torsten original + 10 noise
% N = [960 960 961 964 957 963 960 969 966 981 996]; 
% N = [95 93]; % Clip170 1st and last 

% F = 1743;
% B = 1220;
% S = F - B;

sigma = 4;coef = 2.4;

I=double(I);
aux = Gauss2D(I,1);%1
I2 = Gauss2D(I,sigma);
I3 = aux - I2;
[cutoffInd, cutoffV] = cutFirstHistMode(I3,0);
I4 = I3>cutoffV*coef; % REMOVE THE NOISE FEATURES %no 3

I5 = I4.*I; % signal = EBmask * I
I4 = I4(10:end-40,10:end-10);
M = M(10:end-40,10:end-10);
I = I(10:end-40,10:end-10);

list = find(I5(:));
F = mean(I5(list))

% find the region of immediate bkgr
Id2 = bwmorph(I4,'dilate');
Id2 = bwmorph(Id2,'dilate');
Id2 = bwmorph(Id2,'dilate');
Id3 = Id2 - I4;
figure,imshow(Id3,[])
Id4 = Id3.*I;
list2 = find(Id4(:));
F2 = mean(Id4(list2))

% M = I> 102;
% figure,imshow(M,[])

II = M - I4;
II(II==-1)=0;

figure,imshow(II,[])
Id5 = II.*I;
figure,imshow(Id5,[])
Id5 = Id5(10:end-40,10:end-10);
listD = find(Id5(:));
B_mean = mean(Id5(listD))
B = std(Id5(listD))

S = F - B
% B = M - I4;
% I6 = B.*I;
% N = std(I6(:))

SNR = (F-B)/N(i)

SNR = [ 15.1 9.0 5.4 3.9 3.3 2.9 2.6 2.4 2.2 2.0 2.0] 
FP = [ 9.0  13.0  2.1    4.1    5.7  3.3    0.0    3.8    0.0    0.0  5.7 ]
FN = [ 4.7  2.8   11.3  11.3  6.6  17.0  28.3  29.2  30.2  51.9   37.7  ]

figure,plot(SNR,FP)
hold on
plot(SNR,FN,'r')
legend('FP','FN')
xlabel('SNR')

