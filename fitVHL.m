function X = fitVHL(i,j,pR,avgV) 

% avgV - new input param

% s = 2;
% strg=sprintf('%%.%dd',s);
% indxStr=sprintf(strg,j);
% REAL DATA
% if i == 1
%     load(['X:\AlexData11\786Opar\786Opar_NaCl',indxStr,'_R3D\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat']);
% else
%     load(['X:\AlexData11\786OparVHL\786OVHL30_NaCl',indxStr,'_R3D\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat']);
% end

ds = sort(avgV);
cdfData = [1:length(ds)]/length(ds);
figure, plot(ds, cdfData);

% FITTING DATA
if i == 1
    M1 = 15;
    S1 = 5;
    M2 = 25;
    S2 = 8;
    LeR = pR/100;
else
    M = 15;
    S = 5;
end
% R = 2;
% T = 1.1;
% B1 = 1;
% B2 = 20;

% cdfFit = LeR * raylcdf(ds,B1) + (1-LeR) * raylcdf(ds,B2);
if i == 1
    cdfFit = LeR * normcdf(ds,M1,S1) + (1-LeR) * normcdf(ds,M2,S2);
else
    cdfFit = normcdf(ds,M,S);
end
% cdfFit = LeR * gamcdf(ds,R,T) + (1-LeR) * normcdf(ds,M,S);
hold on

plot(ds,cdfFit,'r-')
hold off

% LSQ NON LIN FIT
diffCdf = cdfData - cdfFit;
% figure, plot(diffCdf)

% X=lsqnonlin(@(X)(cdfData-(X(3) * raylcdf(ds,X(1)) + (1-X(3)) * raylcdf(ds,X(2)))),[B1 B2 LeR]);
if i == 1
    X=lsqnonlin(@(X)(cdfData-(X(5) * normcdf(ds,X(1),X(2)) + (1-X(5)) * normcdf(ds,X(3),X(4)))),[M1 S1 M2 S2 LeR]);
else
    X = lsqnonlin(@(X)(cdfData - normcdf(ds,X(1),X(2),[M S])));
end
% X=lsqnonlin(@(X)(cdfData-(X(4) * gamcdf(ds,R,X(1)) + (1-X(4)) * normcdf(ds,X(2),X(3)))),[B M S LeR]);

%  [X,RESNORM,RESIDUAL,EXITFLAG,OUTPUT,LAMBDA,JACOBIAN]=LSQNONLIN(FUN,X0,...)
%
% G = inv(J'*J);

figure,
plot(ds,cdfData)
hold on
if i == 1
    plot(ds,X(5) * normcdf(ds,X(1),X(2)) + (1-X(5)) * normcdf(ds,X(3),X(4)),'r-')
else
    plot(ds,normcdf(ds,X(1),X(2)),'r-')
end
% plot(ds,X(4) * raylcdf(ds,X(1)) + (1-X(4)) * normcdf(ds,X(2),X(3)),'r-')
% plot(ds,X(4) * gamcdf(ds,R,X(1)) + (1-X(4)) * normcdf(ds,X(2),X(3)),'r-')
hold off

X

% pdfFit = length(avgV) * (X(3) * raylpdf(ds,X(1)) + (1-X(3)) * raylpdf(ds,X(2)));
if i == 1
    pdfFit = length(avgV) * (X(5) * normpdf(ds,X(1),X(2)) + (1-X(5)) * normpdf(ds,X(3),X(4)));
else
    pdfFit = length(avgV) * normpdf(ds,X(1),X(2));
end
% pdfFit = length(avgV) * (X(4) * gampdf(ds,R,X(1)) + (1-X(4)) * normpdf(ds,X(2),X(3)));

figure,histogram(avgV,'smooth')
hold on
if i == 1
    plot (ds,length(avgV) * (X(5) * normpdf(ds,X(1),X(2))),'r-.')
    % plot (ds,length(avgV) * (X(4) * gampdf(ds,R,X(1))),'r-.')
    hold on
    plot(ds,length(avgV) * ((1-X(5)) * normpdf(ds,X(3),X(4))),'r--');
    hold on
end
plot(ds,pdfFit,'r-')

hold off

% s