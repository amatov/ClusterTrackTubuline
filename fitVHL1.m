function X = fitVHL1(i,pR,avgV)


% REAL DATA
% if i == 2
%     load(['X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060824_RCC4-CMVempty-LMP_07\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat']);
% else
%     load(['X:\AlexData11\RCC4\RCC4-CMV93(VHL30)\060829_RCC4-CMV93-LMP_08\point_files\config001_5p00_track_bidir_uni_dir_analysisRecord.mat']);
% end

ds = sort(avgV);
cdfData = [1:length(ds)]/length(ds);
figure, plot(ds, cdfData);

% FITTING DATA
if i == 1
    M1 = 0; % 15;
    S1 = 1;% 3
    M2 = 0;%16;
    S2 = 7; % 6
    LeR = pR/100;
else
    M = 0;%15;
    S = 3;%5;
end

if i == 1
    cdfFit = LeR * normcdf(ds,M1,S1) + (1-LeR) * normcdf(ds,M2,S2);
else
    cdfFit = normcdf(ds,M,S);
end

hold on

plot(ds,cdfFit,'r-')
hold off

% LSQ NON LIN FIT
diffCdf = cdfData - cdfFit;
% figure, plot(diffCdf)


if i == 1
    X=lsqnonlin(@(X)(cdfData-(X(5) * normcdf(ds,X(1),X(2)) + (1-X(5)) * normcdf(ds,X(3),X(4)))),[M1 S1 M2 S2 LeR]);
else
    X = lsqnonlin(@(X)(cdfData - normcdf(ds,X(1),X(2))),[M S]);
end


figure,
plot(ds,cdfData)
hold on
if i == 1
    plot(ds,X(5) * normcdf(ds,X(1),X(2)) + (1-X(5)) * normcdf(ds,X(3),X(4)),'r-')
else
    plot(ds,normcdf(ds,X(1),X(2)),'r-')
end
hold off

X

if i == 1
    pdfFit = length(avgV) * (X(5) * normpdf(ds,X(1),X(2)) + (1-X(5)) * normpdf(ds,X(3),X(4)));
else
    pdfFit = length(avgV) * normpdf(ds,X(1),X(2));
end


figure,histogram(avgV,'smooth')
hold on
if i == 1
    plot (ds,length(avgV) * (X(5) * normpdf(ds,X(1),X(2))),'r-.')
    hold on
    plot(ds,length(avgV) * ((1-X(5)) * normpdf(ds,X(3),X(4))),'r--');
    hold on
end
plot(ds,pdfFit,'r-')

hold off

