function EB3surf

Y = [50,374, 374, 50, 50];%[130,374, 374, 130, 130];
X = [210, 210, 830, 830, 210];%[510, 510, 830, 830, 510];

load(['X:\AlexData\Torsten\xy_resolution\cell1\100x\coordEB1may2009.mat'])
eb = size(coordEB1,1);

% 384 not 391
FP = []; FN = []; j = 0;
for coef = 1:0.2:4 % 4*5-3->17 (16!)
    i = 0;
    j = j + 1;
    for sigm = 1.25:0.25:7 % 7*4-5->23 (24!)

        strg2=sprintf('%%.%dd',2);
        strg3=sprintf('%%.%dd',3);
        load(['X:\AlexData\Torsten\xy_resolution\cell1\100x\param\feats',sprintf(strg2,round(coef*10)),sprintf(strg3,sigm*100),'.mat'])

        D=createSparseDistanceMatrix(coordEB1,feats.pos,10);
        [links12, links21] = lap(D,-1,0,1);
        links = links12(1:eb);
        matches = length(find(links<=size(feats.pos,1)));

        listSq = find(feats.pos(:,2)<Y(2) & feats.pos(:,2)>Y(1) & feats.pos(:,1)<X(3) & feats.pos(:,1)>X(1));
        feaSq = length(listSq);

        i = i + 1;
        FP(i,j) = (1-matches/feaSq)*100;
        FN(i,j) = (1-matches/eb)*100;
    end
end

coef = 1:0.2:4;
sigm = 1.25:0.25:7;

% figure, surf(coef, sigm, FP)
% figure, surf(coef, sigm, FN)

figure, [C,h] =contourf(coef, sigm, FP)
axis image
colorbar
figure, [C1,h1] =contourf(coef, sigm, FN)
axis image
colorbar
%
%  FP(17,15)
% ans =
%     3.0000
% FN(17,15)
% ans =
%     8.4906
figure,plot(sigm,FP(:,15))
hold on
plot(sigm,FN(:,15),'r')
xlabel('Sigma 2')
ylabel('Errors')
legend('FP','FN')

figure,plot(coef,FP(17,:))
hold on
plot(coef,FN(17,:),'r')
xlabel('Noise Coef 1')
ylabel('Errors')
legend('FP','FN')

%  FP(12,8)
% ans =
%     9.0090
% FN(12,8)
% ans =
%     4.7170
%
figure,plot(sigm,FP(:,8))
hold on
plot(sigm,FN(:,8),'r')
xlabel('Sigma 2')
ylabel('Errors')
legend('FP','FN')

figure,plot(coef,FP(12,:))
hold on
plot(coef,FN(12,:),'r')
xlabel('Noise Coef 1')
ylabel('Errors')
legend('FP','FN')

coef