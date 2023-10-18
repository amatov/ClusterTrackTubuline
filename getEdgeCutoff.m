function getEdgeCutoff

% dirName = '/mnt/alex10/AlexData/Torsten/trichostatinA/ctrl/cell3/';
dirName = '/mnt/alex10/AlexData/Torsten/020608_nocodazole_titration_EB1/no_Noc#10/';

% img2 = imread([dirName,'cell_mask',filesep,'mask_ctrl_60x#8t01.tif']);% CELL BODY 1-0 MASK
img2 = imread([dirName,'cell_mask',filesep,'mask_0nm_10_t01.tif']);% CELL BODY 1-0 MASK

% I = imread(['/mnt/alex10/AlexData/Torsten/trichostatinA/ctrl/cell3/images/ctrl_60x#8t01.tif']);
I = imread(['/mnt/alex10/AlexData/Torsten/020608_nocodazole_titration_EB1/no_Noc#10/images/0nm_10_t01.tif']);

distance_image = bwdist(~img2);
load([dirName,'point_files',filesep,'config001_4p00_track_bidir.mat']);
% load([dirName,'point_files',filesep,'config001_6p50_track_bidir.mat']);

t = tracks(find([tracks.len]>4)); % default 19
len = length(t);

Cof = 16; % micron - speed cut off
% LINE = 4.4; % (12um for TSA cell_1) (4,4 for control_1)
aux = 0;
%(TSA cell_1 X<420) (CTR cell_1 Y<510) (TSA cell_2 X>130 & Y<355)(TSA cell_3 X>45 & Y<370)
END_CELL = 510;
s = 2;
strg=sprintf('%%.%dd',s);
k = 1;S_L = [];S_D = [];n = 0;m = 0; l = 0;



for i = 1:len %do it for each track
    for j = 1:t(i).len % do it for each point of the concrete track
        %-----------------------ECCENTRICITY------------------------
        indxStr=sprintf(strg,t(i).startID+j-1);

        load([dirName,'cands',filesep,'feats',indxStr,'.mat']); %

        res = feats.pos - repmat(t(i).points(j,1:2),size(feats.pos,1),1);
        res = abs(res);
        res = sum(res,2);
        [dummy,ind]=min(res);

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
        %-----------------------------------------------FLIP ALL CUTOFF-COORDINATES!!!!!!!!!!
        if all(t(i).points(:,1) >230)%> 154) %& all(t(i).points(:,1) > 45)% 1->X horisontal, 2->Y vertical cut off
            S(k) = t(i).points(j,5);
            if S(k) < ( Cof / (60*0.107/0.62) ) % find the indeces depending on speed cut-off
                m = m+1;
                y1(m) = t(i).points(j,1);
                x1(m) = t(i).points(j,2); % TOVA E SAMO J koeto e v konkreten trak a nas ni triabva I sushto???
            else
                l = l+1;
                y2(l) = t(i).points(j,1);
                x2(l) = t(i).points(j,2); % DO IT HEAD TO TAIL!!!
            end
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

S = S * 60*0.107/0.39; % PIXEL SIZE 0.107um /0.39
L = L*0.107;
D = D*0.107;

for LINE = 2:0.1:10%1.8:0.05:6.2  (5:0.1:15-empty band) 

    ind1 = find(D<LINE);
%     [n1,b1]=hist(S(ind1),40);
    ind2 = find(D>=LINE);
%     [n2,b2]=hist(S(ind2),40);
    
%     h2 = figure,bar(b2,n2,'r');
%     hold on
%     bar(b1,n1,'b')
%     xlabel('Speed of tracks, red - further than the cutoff-line, blue close to the cell edge than the cut-off')
%     ylabel('#')
%     hold off

    aux = aux + 1;
    diffMed(aux) = median(S(ind2)) - median(S(ind1));

    clear n1
    clear b1
    clear n2
    clear b2
    clear ind1
    clear ind2
end

aux = [2:0.1:10];%[5:0.1:15];%[1.8:0.05:6.2];
h1 = figure,plot(aux,diffMed,'b-')
% saveas(h1,([dirName,'diffMed','.fig']),'fig');

% this way visual inspection of the cut can be done
figure,imshow(I,[])
hold on
plot(y1,x1,'b.')
hold on
plot(y2,x2,'r.')

diffMed