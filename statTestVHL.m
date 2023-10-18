function statTestVHL



data_set1=bootstrapingRCC4_00;
data_set2=bootstrapingRCC4_93;

size_data_set1=size(data_set1,2);
size_data_set2=size(data_set2,2);

minSiz = min(size_data_set1,size_data_set2);

% maxSiz = size_data_set%max(siz); % all together


for i = 1:50
    indexList1 = ceil(rand(minSiz,1)*size_data_set1);
    data1 = data_set1(indexList1);
    mean1 = mean(data1);
       
    indexList2 = ceil(rand(minSiz,1)*size_data_set2);
    data2 = data_set2(indexList2);
    mean2 = mean(data2);
    
    % compare distributions: KS-test. Subtract means
    [dummy,pValue] = kstest2(data1-mean1, data2-mean2);

    p(i) = pValue;
end
p_value = mean(p)

p