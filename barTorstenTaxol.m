function barTorstenTaxol

load('X:\AlexData\Torsten\0609_taxol_titration\no_Tax#03\groups1\parser.mat');
p(1) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\no_Tax#06\groups1\parser.mat');
p(2) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\no_Tax#07\groups1\parser.mat');
p(3) = parser;
clear parser
gr100 = cat(2,p.growth_speeds_tracks);  
ga100 = cat(2,p.growth_speeds_gaps);  
s100 = cat(2,p.shirnk_speeds_gaps);  
clear p
%--------------------------------------------------------------------------
load('X:\AlexData\Torsten\0609_taxol_titration\1nM_Tax#01\groups1\parser.mat');
p(1) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\1nM_Tax#03\groups1\parser.mat');
p(2) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\1nM_Tax#04\groups1\parser.mat');
p(3) = parser;
clear parser
gr60 = cat(2,p.growth_speeds_tracks);  
ga60 = cat(2,p.growth_speeds_gaps);  
s60 = cat(2,p.shirnk_speeds_gaps);  
clear p
%--------------------------------------------------------------------------
load('X:\AlexData\Torsten\0609_taxol_titration\3p3nM_Tax#01\groups1\parser.mat');
p(1) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\3p3nM_Tax#02\groups1\parser.mat');
p(2) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\3p3nM_Tax#04\groups1\parser.mat');
p(3) = parser;
clear parser
gr50 = cat(2,p.growth_speeds_tracks);  
ga50 = cat(2,p.growth_speeds_gaps);  
s50 = cat(2,p.shirnk_speeds_gaps);  
clear p
%---------------------------------------------------------------------
load('X:\AlexData\Torsten\0609_taxol_titration\10nM_Tax#02\groups1\parser.mat');
p(1) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\10nM_Tax#03\groups1\parser.mat');
p(2) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\10nM_Tax#04\groups1\parser.mat');
p(3) = parser;
clear parser
gr30 = cat(2,p.growth_speeds_tracks);  
ga30 = cat(2,p.growth_speeds_gaps);  
s30 = cat(2,p.shirnk_speeds_gaps);  
clear p
%--------------------------------------------------------------------------
load('X:\AlexData\Torsten\0609_taxol_titration\33nM_Tax#02\groups1\parser.mat');
p(1) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\33nM_Tax#05a\groups1\parser.mat');
p(2) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\33nM_Tax#05b\groups1\parser.mat');
p(3) = parser;
clear parser
gr20 = cat(2,p.growth_speeds_tracks);  
ga20 = cat(2,p.growth_speeds_gaps);  
s20 = cat(2,p.shirnk_speeds_gaps);  
clear p
%-------------------------------------------------------------------
load('X:\AlexData\Torsten\0609_taxol_titration\100nM_Tax#01\groups1\parser.mat');
p(1) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\100nM_Tax#03\groups1\parser.mat');
p(2) = parser;
clear parser
load('X:\AlexData\Torsten\0609_taxol_titration\100nM_Tax#04\groups1\parser.mat');
p(3) = parser;
clear parser
gr10 = cat(2,p.growth_speeds_tracks);  
ga10 = cat(2,p.growth_speeds_gaps);  
s10 = cat(2,p.shirnk_speeds_gaps);  
clear p
%---------------------------growth------------------------------------------
% grsi = max([size(gr100,2),size(gr60,2),size(gr50,2),size(gr30,2),size(gr20,2),size(gr10,2)]);
% 
% grN00(1:grsi - size(gr100,2))=nan;
% gr100b = [gr100,grN00];
% grN60(1:grsi - size(gr60,2))=nan;
% gr60b = [gr60,grN60];
% grN50(1:grsi - size(gr50,2))=nan;
% gr50b = [gr50,grN50];
% grN30(1:grsi - size(gr30,2))=nan;
% gr30b = [gr30,grN30];
% grN20(1:grsi - size(gr20,2))=nan;
% gr20b = [gr20,grN20];
% grN10(1:grsi - size(gr10,2))=nan;
% gr10b = [gr10,grN10];
% 
% figure, boxplot([gr100b',gr60b',gr50b',gr30b',gr20b',gr10b'],'notch','on','whisker',1.5,  ...
%     'widths', 0.8, 'labels', {'0','1', '3.3', '10', '33', '100'},...
%      'positions' , [ 1, 3, 5, 7, 9, 11])
% ylabel('Microtubule Growth Speeds');
% %----------------------gap-------------------------------------------------
% gasi = max([size(ga100,2),size(ga60,2),size(ga50,2),size(ga30,2),size(ga20,2),size(ga10,2)]);
% 
% gaN00(1:gasi - size(ga100,2))=nan;
% ga100b = [ga100,gaN00];
% gaN60(1:gasi - size(ga60,2))=nan;
% ga60b = [ga60,gaN60];
% gaN50(1:gasi - size(ga50,2))=nan;
% ga50b = [ga50,gaN50];
% gaN30(1:gasi - size(ga30,2))=nan;
% ga30b = [ga30,gaN30];
% gaN20(1:gasi - size(ga20,2))=nan;
% ga20b = [ga20,gaN20];
% gaN10(1:gasi - size(ga10,2))=nan;
% ga10b = [ga10,gaN10];
% 
% figure, boxplot([ga100b',ga60b',ga50b',ga30b',ga20b',ga10b'],'notch','on','whisker',1.5,  ...
%     'widths', 0.8, 'labels', {'0','1', '3.3', '10', '33', '100'},...
%      'positions' , [ 1, 3, 5, 7, 9, 11])
% ylabel('Microtubule Gap Speeds');
%------------------------------shrink--------------------------------------------
[cutoffInd, cutoffV] = cutFirstHistMode(ga100,1);
CUTOFF_SPEED = cutoffV
cutoffV = 9.33

s100 = s100(find(s100>cutoffV));
s60 = s60(find(s60>cutoffV));
s50 = s50(find(s50>cutoffV));
s30 = s30(find(s30>cutoffV));
s20 = s20(find(s20>cutoffV));
s10 = s10(find(s10>cutoffV));

% - test
[h,p_long] = ttest2(gr100,gr60)%MEANS ONLY
for i = 1:200

    i1 = randsample(length(gr100),400);
    v1=gr100(i1);

    i2 = randsample(length(gr60),400);
    v2=gr60(i2);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy1,pV] = ttest2(v1, v2);
    
    p(i) = pV;
end
p_value = mean(p)
figure, hist(p)
[h,p_long] = ttest2(s100,s60)%MEANS ONLY
for i = 1:200

    i1 = randsample(length(s100),400);
    v1=s100(i1);

    i2 = randsample(length(s60),400);
    v2=s60(i2);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy1,pV] = ttest2(v1, v2);
    
    p(i) = pV;
end
p_value = mean(p)
figure, hist(p)

ssi = max([size(s100,2),size(s60,2),size(s50,2),size(s30,2),size(s20,2),size(s10,2)]);

sN00(1:ssi - size(s100,2))=nan;
s100b = [s100,sN00];
sN60(1:ssi - size(s60,2))=nan;
s60b = [s60,sN60];
sN50(1:ssi - size(s50,2))=nan;
s50b = [s50,sN50];
sN30(1:ssi - size(s30,2))=nan;
s30b = [s30,sN30];
sN20(1:ssi - size(s20,2))=nan;
s20b = [s20,sN20];
sN10(1:ssi - size(s10,2))=nan;
s10b = [s10,sN10];

figure, boxplot([s100b',s60b',s50b',s30b',s20b',s10b'],'notch','on','whisker',1.5,  ...
    'widths', 0.8, 'labels', {'0','1', '3.3', '10', '33', '100'},...
     'positions' , [ 1, 3, 5, 7, 9, 11])
 ylim([-2 60])
ylabel('Microtubule Shrinkage Speeds');

a
