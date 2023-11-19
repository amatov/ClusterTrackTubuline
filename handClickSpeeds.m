function handClickSpeeds

tor = xlsread('X:\AlexData\Torsten\trackingValidation\tracking_data2.xls'); %\tracking_data1.xls');
pixelSize = 0.107;% microns
samplingRate = 0.62; % seconds
scaleFactor = pixelSize * 60 / samplingRate ;

aux = tor(:,8);
flagBeginGrowth = find(aux==-1);
flagEndGrowth = find(aux==-11);
flagSingleGrowth = find(aux==-111);
flagBeginPause = find(aux==-2);
flagEndPause = find(aux==-22);
flagSinglePause = find(aux==-222);
flagBeginShrink = find(aux==-3);
flagEndShrink = find(aux==-33);
flagSingleShrink = find(aux==-333);

for i = 1:length(flagBeginGrowth)
    i_b = flagBeginGrowth(i);
    i_e = flagEndGrowth(i);
    x1 = tor(i_b-1,4);
    y1 = tor(i_b-1,5);
    x2 = tor(i_e,4);
    y2 = tor(i_e,5);
    dY = x2-x1;
    dX = y2-y1;
    GrLe(i) = i_e-i_b+1;
    GrSp(i) = sqrt(dY^2+dX^2)/GrLe(i)*scaleFactor;
end
for i = 1:length(flagSingleGrowth)
    i_g = flagSingleGrowth(i);
    x1 = tor(i_g-1,4);
    y1 = tor(i_g-1,5);
    x2 = tor(i_g,4);
    y2 = tor(i_g,5);
    dY = x2-x1;
    dX = y2-y1;
    GrLe_s(i) = 1;
    GrSp_s(i) = sqrt(dY^2+dX^2)*scaleFactor;
end
GrSp = [GrSp,GrSp_s];
GrLe = [GrLe,GrLe_s];

for i = 1:length(flagBeginPause)
    i_b = flagBeginPause(i);
    i_e = flagEndPause(i);
    x1 = tor(i_b-1,4);
    y1 = tor(i_b-1,5);
    x2 = tor(i_e,4);
    y2 = tor(i_e,5);
    dY = x2-x1;
    dX = y2-y1;
    PaLe(i) = i_e-i_b+1;
    PaSp(i) = sqrt(dY^2+dX^2)/PaLe(i)*scaleFactor;
end
for i = 1:length(flagSinglePause)
    i_g = flagSinglePause(i);
    x1 = tor(i_g-1,4);
    y1 = tor(i_g-1,5);
    x2 = tor(i_g,4);
    y2 = tor(i_g,5);
    dY = x2-x1;
    dX = y2-y1;
    PaLe_s(i) = 1;
    PaSp_s(i) = sqrt(dY^2+dX^2)*scaleFactor;
end
PaSp = [PaSp,PaSp_s];
PaLe = [PaLe,PaLe_s];

for i = 1:length(flagBeginShrink)
    i_b = flagBeginShrink(i);
    i_e = flagEndShrink(i);
    x1 = tor(i_b-1,4);
    y1 = tor(i_b-1,5);
    x2 = tor(i_e,4);
    y2 = tor(i_e,5);
    dY = x2-x1;
    dX = y2-y1;
    ShLe(i) = i_e-i_b+1;
    ShSp(i) = sqrt(dY^2+dX^2)/ShLe(i)*scaleFactor;
end
for i = 1:length(flagSingleShrink)
    i_g = flagSingleShrink(i);
    x1 = tor(i_g-1,4);
    y1 = tor(i_g-1,5);
    x2 = tor(i_g,4);
    y2 = tor(i_g,5);
    dY = x2-x1;
    dX = y2-y1;
    ShLe_s(i) = 1;
    ShSp_s(i) = sqrt(dY^2+dX^2)*scaleFactor;
end
ShSp = [ShSp,ShSp_s];
ShLe = [ShLe,ShLe_s];

GRO_SPEED_STD = [mean(GrSp),std(GrSp)]
PAU_SPEED_STD = [mean(PaSp),std(PaSp)]
PAU_LENGTH = mean(PaLe)*0.62
SHR_SPEED_STD = [mean(ShSp),std(ShSp)]

figure,hist(GrSp,20)
title('GROWTH micron/min')
figure,hist(PaSp,20)
title('PAUSE micron/min')
figure,hist(ShSp,20)
title('SHRINK micron/min')

a