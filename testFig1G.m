function testFig1G


[tr_sp_ns,mTr_sp_ns,ga_sp_ns,mGa_sp_ns,gr_sp_ns,mGr_sp_ns,sh_sp_ns,mSh_sp_ns]=bootstrapingRPE1_ns;

[tr_sp_sh,mTr_sp_sh,ga_sp_sh,mGa_sp_sh,gr_sp_sh,mGr_sp_sh,sh_sp_sh,mSh_sp_sh]=bootstrapingRPE1_shVHL;


% figure,hist(tr_sp_ns)
% figure,hist(mTr_sp_ns)
% figure,hist(tr_sp_sh)
% figure,hist(mTr_sp_sh)
% aux = sort(mTr_sp_ns);
% mTr_sp_ns = aux(1:end-1);

[h,p,ci] = ttest2(mTr_sp_ns,mTr_sp_sh)%MEANS ONLY

for i = 1:200

    inL_ns = randsample(length(tr_sp_ns),400);
    Xns=tr_sp_ns(inL_ns);
    Mns = mean(Xns);

    inL_sh = randsample(length(tr_sp_sh),400);
    Xsh=tr_sp_sh(inL_sh);
    Msh = mean(Xsh);



    % compare distributions: KS-test. Subtract means
    [dummy,pValue] = kstest2(Xns-Mns, Xsh-Msh);
    [dummy1,pValue1] = kstest2(Xns, Xsh);
    
    p(i) = pValue;
    p1(i) = pValue1;
end
p_value = mean(p)
p_value_w_mean = mean(p1)

% figure,hist(p)
% figure,hist(p1)

p

