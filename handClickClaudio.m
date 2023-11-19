function handClickClaudio

ns = xlsread('X:\VHL-paper\Supplement\ns.xls'); % speed
ns = abs(ns);
% nt = xlsread('X:\VHL-paper\Supplement\nst.xls'); % time
tn = xlsread('X:\VHL-paper\Supplement\nss.xls'); % switches
sh = xlsread('X:\VHL-paper\Supplement\sh.xls'); % speed
sh = abs(sh);
% st = xlsread('X:\VHL-paper\Supplement\sht.xls'); % time 
th = xlsread('X:\VHL-paper\Supplement\shs.xls'); % switches

flagBeginGrowth = find(tn==1);
flagEndGrowth = find(tn==11);
flagSingleGrowth = find(tn==111);
flagBeginPause = find(tn==2);
flagEndPause = find(tn==22);
flagSinglePause = find(tn==222);
flagBeginShrink = find(tn==3);
flagEndShrink = find(tn==33);
flagSingleShrink = find(tn==333);

for i = 1:length(flagBeginGrowth)
    b = flagBeginGrowth(i);
    e = flagEndGrowth(i);
    GrLeNs(i) = (e-b+1)*2;
    GrSpNs(i) = sum(ns(b:e))/(e-b+1);
end
for i = 1:length(flagSingleGrowth)
    g = flagSingleGrowth(i);
    GrLeNs_s(i) = 2;
    GrSpNs_s(i) = ns(g);
end
GrSpNs = [GrSpNs,GrSpNs_s];
GrLeNs = [GrLeNs,GrLeNs_s];

for i = 1:length(flagBeginPause)
    b = flagBeginPause(i);
    e = flagEndPause(i);
    PaLeNs(i) = (e-b+1)*2;
    PaSpNs(i) = sum(ns(b:e))/(e-b+1);
end
for i = 1:length(flagSinglePause)
    g = flagSinglePause(i);
    PaLeNs_s(i) = 2;
    PaSpNs_s(i) = ns(g);
end
PaSpNs = [PaSpNs,PaSpNs_s];
PaLeNs = [PaLeNs,PaLeNs_s];

for i = 1:length(flagBeginShrink)
    b = flagBeginShrink(i);
    e = flagEndShrink(i);
    ShLeNs(i) = (e-b+1)*2;
    ShSpNs(i) = sum(ns(b:e))/(e-b+1);
end
for i = 1:length(flagSingleShrink)
    g = flagSingleShrink(i);
    ShLeNs_s(i) = 2;
    ShSpNs_s(i) = ns(g);
end
ShSpNs = [ShSpNs,ShSpNs_s];
ShLeNs = [ShLeNs,ShLeNs_s];
%--------------------
flagBeginGrowth=[];flagEndGrowth=[];flagSingleGrowth=[];
flagBeginPause=[];flagEndPause=[];flagSinglePause=[];
flagBeginShrink=[];flagEndShrink=[];flagSingleShrink=[];

flagBeginGrowth = find(th==1);
flagEndGrowth = find(th==11);
flagSingleGrowth = find(th==111);
flagBeginPause = find(th==2);
flagEndPause = find(th==22);
flagSinglePause = find(th==222);
flagBeginShrink = find(th==3);
flagEndShrink = find(th==33);
flagSingleShrink = find(th==333);

for i = 1:length(flagBeginGrowth)
    b = flagBeginGrowth(i);
    e = flagEndGrowth(i);
    GrLeSh(i) = (e-b+1)*2;
    GrSpSh(i) = sum(sh(b:e))/(e-b+1);
end
for i = 1:length(flagSingleGrowth)
    g = flagSingleGrowth(i);
    GrLeSh_s(i) = 2;
    GrSpSh_s(i) = sh(g);
end
GrSpSh = [GrSpSh,GrSpSh_s];
GrLeSh = [GrLeSh,GrLeSh_s];

for i = 1:length(flagBeginPause)
    b = flagBeginPause(i);
    e = flagEndPause(i);
    PaLeSh(i) = (e-b+1)*2;
    PaSpSh(i) = sum(sh(b:e))/(e-b+1);
end
for i = 1:length(flagSinglePause)
    g = flagSinglePause(i);
    PaLeSh_s(i) = 2;
    PaSpSh_s(i) = sh(g);
end
PaSpSh = [PaSpSh,PaSpSh_s];
PaLeSh = [PaLeSh,PaLeSh_s];

for i = 1:length(flagBeginShrink)
    b = flagBeginShrink(i);
    e = flagEndShrink(i);
    ShLeSh(i) = (e-b+1)*2;
    ShSpSh(i) = sum(sh(b:e))/(e-b+1);
end
for i = 1:length(flagSingleShrink)
    g = flagSingleShrink(i);
    ShLeSh_s(i) = 2;
    ShSpSh_s(i) = ns(g);
end
ShSpSh = [ShSpSh,ShSpSh_s];
ShLeSh = [ShLeSh,ShLeSh_s];
%--------------------
% grNs = ns(find(ns>6));
% grNt = nt(find(ns>6));% time
% paNs = abs(ns(find(ns<=6 & ns>=-6)));
% paNt = nt(find(ns<=6 & ns>=-6));% time
% shNs = abs(ns(find(ns<-6)));
% shNt = nt(find(ns<-6));% time
% 
% grSh = sh(find(sh>6));
% grSt = st(find(sh>6));
% paSh = abs(sh(find(sh<=6 & sh>=-6)));
% paSt = st(find(sh<=6 & sh>=-6));
% shSh = abs(sh(find(sh<-6)));
% shSt = st(find(sh<-6));

GRO_SP_NS = [mean(GrSpNs),std(GrSpNs)]
GRO_TI_NS = [mean(GrLeNs),std(GrLeNs)]
PAU_SP_NS = [mean(PaSpNs),std(PaSpNs)]
PAU_TI_NS = [mean(PaLeNs),std(PaLeNs)]
SHR_SP_NS = [mean(ShSpNs),std(ShSpNs)]
SHR_TI_NS = [mean(ShLeNs),std(ShLeNs)]

GRO_SP_SH = [mean(GrSpSh),std(GrSpSh)]
GRO_TI_SH = [mean(GrLeSh),std(GrLeSh)]
PAU_SP_SH = [mean(PaSpSh),std(PaSpSh)]
PAU_TI_SH = [mean(PaLeSh),std(PaLeSh)]
SHR_SP_SH = [mean(ShSpSh),std(ShSpSh)]
SHR_TI_SH = [mean(ShLeSh),std(ShLeSh)]

% figure,hist(grNt,20)
% title('GROWTH NS micron/min')
% figure,hist(paNt,20)
% title('PAUSE NS micron/min')
% figure,hist(shNt,20)
% title('SHRINK NS micron/min')
% 
% figure,hist(grSt,20)
% title('GROWTH SH micron/min')
% figure,hist(paSt,20)
% title('PAUSE SH micron/min')
% figure,hist(shSt,20)
% title('SHRINK SH micron/min')
n = 1%.645; % 90%
% n = 1.965; % 95%
% n = 2.576; % 99%

p =[];diffMu = [];
gr = [GrLeNs,GrLeSh];
for i = 1:1000

    i1 = randsample(length(gr),length(GrLeNs));
    v1=gr(i1);

    i2 = randsample(length(gr),length(GrLeSh));
    v2=gr(i2);

    diffGr(i) = mean(v1)-mean(v2);
    
    i1=[];i2=[];v1=[];v2=[];
end
% c_g = cdf ('norm', diffGr, 99)
% cdf_gr = normcdf(diffGr,0,1)
diffMu = mean(GrLeNs)-mean(GrLeSh);
if (n*std(diffGr))<abs(diffMu)
    DIFFERENT_gr = 1
else
    DIFFERENT_gr = 0
end

p =[];diffMu = [];
pa = [PaLeNs,PaLeSh];
for i = 1:1000

    i1 = randsample(length(pa),length(PaLeNs));
    v1=pa(i1);

    i2 = randsample(length(pa),length(PaLeSh));
    v2=pa(i2);

    diffPa(i) = mean(v1)-mean(v2);
    i1=[];i2=[];v1=[];v2=[];
end
diffMu = mean(PaLeNs)-mean(PaLeSh);
if (n*std(diffPa))<abs(diffMu)
    DIFFERENT_pa = 1
else
    DIFFERENT_pa = 0
end

p =[];diffMu = [];
sh = [ShLeNs,ShLeSh];
for i = 1:1000

    i1 = randsample(length(sh),length(ShLeNs));
    v1=sh(i1);

    i2 = randsample(length(sh),length(ShLeSh));
    v2=sh(i2);

    diffSh(i) = mean(v1)-mean(v2);
    i1=[];i2=[];v1=[];v2=[];
end
diffMu = mean(ShLeNs)-mean(ShLeSh);
if (n*std(diffSh))<abs(diffMu)
    DIFFERENT_sh = 1
else
    DIFFERENT_sh = 0
end

a