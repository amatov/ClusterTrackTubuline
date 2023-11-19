function pvaluesClip170


[Ebns,cellEbns]=bootstrapingEB3ns;
[Ebsh,cellEbsh]=bootstrapingEB3shVHL;

[Clns,cellClns]=bootstrapingCLIP170ns;
[Clsh,cellClsh]=bootstrapingCLIP170shVHL;

% - test
[h,p_long] = ttest2(Ebns,Ebsh)%MEANS ONLY
for i = 1:200

    i1 = randsample(length(Ebns),400);
    v1=Ebns(i1);

    i2 = randsample(length(Ebsh),400);
    v2=Ebsh(i2);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy,pV] = ttest2(v1, v2);
    
    p(i) = pV;
end
p_value = mean(p)
figure, hist(p)

[h1,p1_long] = ttest2(Clns,Clsh)%MEANS ONLY
for i = 1:200

    i11 = randsample(length(Clns),400);
    v11=Clns(i11);

    i21 = randsample(length(Clsh),400);
    v21=Clsh(i21);

    % compare distributions: KS-test. Subtract means
%     [dummy,pValue] = kstest2(X00-M00, X30-M30);
    [dummy1,pV1] = ttest2(v11, v21);
    
    p1(i) = pV1;
end
p1_value = mean(p1)
figure, hist(p1)

p
