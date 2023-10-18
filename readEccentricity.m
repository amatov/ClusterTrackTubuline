function readEccentricity

img2 = imread('X:\AlexData\cell_mask\mask_EB1-GFP-5001.tif');
distance_image = bwdist(~img2);

load(['X:\AlexResults\EB1_Katsu_1s_1_600\point_files\EB1_poster_pooledData.mat']);
t = tracks(find([tracks.len]>5)); 
len = length(t);

s = 3; 
strg=sprintf('%%.%dd',s);

k = 1;S_L = [];S_D = [];n=0;

for i = 1:len %do it for each track

    for j = 1:t(i).len % do it for each point of the concrete track
        %-----------------------ECCENTRICITY------------------------
        if i < 529
            indxStr=sprintf(strg,t(i).startID+j-1);% +200
            load(['X:\AlexResults\EB1_Katsu_1s_1_600\cands\feats',indxStr,'.mat']); % load the feats.mat file corresponding to the point of the track
        elseif i > 528 &  i < 976
            indxStr=sprintf(strg,t(i).startID+j-1+200);% +200
            load(['X:\AlexResults\EB1_Katsu_1s_1_600\cands\feats',indxStr,'.mat']); % load the feats.mat file corresponding to the point of the track
        elseif i > 975
            indxStr=sprintf(strg,t(i).startID+j-1+400);% +200
            load(['X:\AlexResults\EB1_Katsu_1s_1_600\cands\feats',indxStr,'.mat']); % load the feats.mat file corresponding to the point of the track
        else
            disp('somsing rong')
        end
        %         feats.pos = round(feats.pos*1000)/1000; % Yang's SW rounds up after the 3rd digit
        res = feats.pos - repmat(t(i).points(j,1:2),size(feats.pos,1),1);
        res = abs(res);
        res = sum(res,2);
        [dummy,ind]=min(res);

        %         [dummy,ind] = ismember(t(i).points(j,1:2),feats.pos,'rows');
        if dummy < 0.01
            t(i).points(j,3) = feats.ecc(ind);
            t(i).points(j,4) = feats.len(ind);
        else
            disp('correspondance not found')
        end
        %-----------------------SPEED------------------------
        if j > 1
            t(i).points(j,5) = sqrt( (t(i).points(j,1)-t(i).points(j-1,1))^2 +  (t(i).points(j,2)-t(i).points(j-1,2))^2 );
        else
            t(i).points(j,5) = sqrt( (t(i).points(j,1)-t(i).points(j+1,1))^2 +  (t(i).points(j,2)-t(i).points(j+1,2))^2 );
        end
        %----------------------------DISTANCE-TO-EDGE-------------------
        t(i).points(j,6) = distance_image(round(t(i).points(j,2)),round(t(i).points(j,1)));
        %-----------------------------------------------
        if all(t(i).points(:,2) < 300)
            S(k) = t(i).points(j,5);
            L(k) = t(i).points(j,4);
            D(k) = t(i).points(j,6);%
            %       if &
            E(k) = t(i).points(j,3);
            k = k + 1;
        else
            n = n+1;
        end
        %-----------------------------------------------
        clear ind
        clear feats
    end

end

kk = 0;
for i = 1:len

    if all(t(i).points(:,2) < 300)
        front = any(t(i).points(:,6) < 3.5/0.062);
        back = any(t(i).points(:,6) >= 3.5/0.062);

        switch front + 2* back
            case 1 % front only
                frontInd(kk+1:kk+t(i).len) = i;
                crossInd(kk+1:kk+t(i).len) = 0;
                backInd(kk+1:kk+t(i).len) = 0;
            case 2 % back only
                frontInd(kk+1:kk+t(i).len) = 0;
                crossInd(kk+1:kk+t(i).len) = 0;
                backInd(kk+1:kk+t(i).len) = i;
            case 3 % cross
                frontInd(kk+1:kk+t(i).len) = 0;
                crossInd(kk+1:kk+t(i).len) = i;
                backInd(kk+1:kk+t(i).len) = 0;
            otherwise
                error('should not have happened. Oops');
        end

        kk = kk + t(i).len;
    end
end
S = S*60*0.062;
L = L*0.062;
D = D*0.062;

figure, hold on
for i = 1: max(crossInd)
    plot(D(crossInd == i),S(crossInd == i))
end

figure,plot(D(find(crossInd)),S(find(crossInd)),'.')
xlabel('DISTANCE FROM EDGE')
ylabel('SPEED')

cin =find(crossInd);
ind = find(D(cin)<3.5);
figure,subplot(2,2,1),histogram(S(cin(ind)));
ind = find(D(cin)>=3.5);
subplot(2,2,2),histogram(S(cin(ind)));

ind = find(D(cin)<3.5);
[n1,b1]=histogram(S(cin(ind)));
ind = find(D(cin)>=3.5);
[n2,b2]=histogram(S(cin(ind)));
figure,bar(b2,n2,'r')
hold on
bar(b1,n1,'b')

figure,plot(D,S,'.')
xlabel('DISTANCE FROM EDGE')
ylabel('SPEED')

ind = find(D<3.5);
figure,subplot(2,2,1),histogram(S(ind));
ind = find(D>=3.5);
subplot(2,2,2),histogram(S(ind));
title('Speed in different Dist from Edge intervals')

ind = find(D<3.5);
[n1,b1]=histogram(S(ind));
ind = find(D>=3.5);
[n2,b2]=histogram(S(ind));
figure,bar(b2,n2,'r')
hold on
bar(b1,n1,'b')

figure,plot(E,S,'.')
xlabel('ECCENTRICITY')
ylabel('SPEED')

ind = find(E<0.92);
figure,subplot(2,2,1),histogram(S(ind));
ind = find(E>=0.92);
subplot(2,2,2),histogram(S(ind));
title('Speed in different Ecc intervals')

ind = find(E<0.92);
[n1,b1]=histogram(S(ind));
ind = find(E>=0.92);
[n2,b2]=histogram(S(ind));
figure,bar(b1,n1,'r')
hold on
bar(b2,n2,'b')

fin =find(frontInd);
ind = find(E(fin)<0.92);
[n1,b1]=histogram(S(fin(ind)));
ind = find(E(fin)>=0.92);
[n2,b2]=histogram(S(fin(ind)));
figure,bar(b1,n1,'r')
hold on
bar(b2,n2,'b')


figure,histogram(D)
title('#EB1 vs Distance from Edge')

t