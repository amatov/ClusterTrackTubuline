function plotCluster

for j = 2:13

    s = 2;
    strg=sprintf('%%.%dd',s);
    indxStr=sprintf(strg,j);

    v = textread(['C:\Alex\R\R-2.3.1\avgV_786OVHL30_NaCl',indxStr,'.txt'],'%n');
    dx = sort(v);
    le = length(v);

    c = textread(['C:\Alex\R\R-2.3.1\avgV_786OVHL30_NaCl',indxStr,'_distribution_3G.txt'],'%n');
    n = c(1);
    p =zeros(le,1);

    figure,histogram(v,'smooth')
    hold on
    for i = 1:n


        g = le * c(i+1+2*n) * normpdf(dx,c(i+1),sqrt(c(i+1+n)));
        p = p + g;
        plot(dx,g,'r--')
        clear g
        hold on

    end
    plot(dx,p,'r-')
    hold off

end

for j = 1:12

    s = 2;
    strg=sprintf('%%.%dd',s);
    indxStr=sprintf(strg,j);

    v = textread(['C:\Alex\R\R-2.3.1\avgV_786Opar_NaCl',indxStr,'.txt'],'%n');
    dx = sort(v);
    le = length(v);

    c = textread(['C:\Alex\R\R-2.3.1\avgV_786Opar_NaCl',indxStr,'_distribution_3G.txt'],'%n');
    n = c(1);
    p =zeros(le,1);

    figure,histogram(v,'smooth')
    hold on
    for i = 1:n


        g = le * c(i+1+2*n) * normpdf(dx,c(i+1),sqrt(c(i+1+n)));
        p = p + g;
        plot(dx,g,'r--')
        clear g
        hold on

    end
    plot(dx,p,'r-')
    hold off

end