function readEccentricityTorsten

% TSA
% dirName = 'X:\AlexData\Torsten\trichostatinA\1uM_TSA\cell3\';
% dirName = '/mnt/alex10/AlexData/Torsten/trichostatinA/1uM_TSA/cell3/';

%CONTROL
% dirName = 'X:\AlexData\Torsten\trichostatinA\ctrl\cell1\';
dirName = '/mnt/alex10/AlexData/Torsten/trichostatinA/ctrl/cell1/';

% img2 = imread([dirName,'cell_mask',filesep,'mask_1um_tsa#4t01.tif']);% CELL BODY 1-0 MASK
img2 = imread([dirName,'cell_mask',filesep,'mask_ctrl_60x#6_t01.tif']);% CELL BODY 1-0 MASK

I = imread(['/mnt/alex10/AlexData/Torsten/trichostatinA/ctrl/cell1/images/ctrl_60x#6_t01.tif']);
% I = imread(['/mnt/alex10/AlexData/Torsten/trichostatinA/1uM_TSA/cell3/images/1um_tsa#4t01.tif']);

distance_image = bwdist(~img2);

load([dirName,'point_files',filesep,'config001_4p00_track_bidir.mat']);
t = tracks(find([tracks.len]>19)); % default 19
len = length(t);

Cof = 16; % micron - speed cut off
LINE = 4.4; % (12um for TSA cell_1) (4,4 for control_1)
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
        %-----------------------------------------------FLIP ALL CUTOFF
        %COORDINATES!!!!!!!!!!
        if all(t(i).points(:,2) < 370) & all(t(i).points(:,1) > 45)% 1 -> Y / 2 -> X
            S(k) = t(i).points(j,5);
            if S(k) < ( Cof / (60*0.107/0.39) ) % find the indeces depending on speed cut-off
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
 
S = S * 60*0.107/0.39; % PIXEL SIZE!-before 0.062um, now 0.107um
% length
L = L*0.107;
% disntance to edge
D = D*0.107;
% pixelSize = 0.107; (microns)
% samplingRate = 0.39;  (seconds)
% scaleFactor = pixelSize * 60 / samplingRate ;

h1 = figure,plot(D,S,'.')
hold on
plot([LINE,LINE],[min(S),max(S)],'r')
xlabel('DISTANCE FROM EDGE')
ylabel('SPEED')
saveas(h1,([dirName,'distFromEdge','.fig']),'fig');

ind = find(D<LINE);
% [n1,b1]=histogram(S(ind));
[n1,b1]=hist(S(ind),40);
ind = find(D>=LINE);
% [n2,b2]=histogram(S(ind));
[n2,b2]=hist(S(ind),40);
h2 = figure,bar(b2,n2,'r')
hold on
bar(b1,n1,'b')
xlabel('Speed of tracks, red - further than the cut-off-line, blue close to the cell edge than the cut-off')
ylabel('#')
saveas(h2,([dirName,'redBlueHists','.fig']),'fig');

h3 = figure,histogram(D)
title('#EB1 vs Distance from Edge')
saveas(h3,([dirName,'Eb1hist','.fig']),'fig');


h4 = figure,imshow(I,[])
hold on
plot(y1,x1,'b.')
hold on
plot(y2,x2,'r.')
xlabel('Distribution of segments as a function of speed (< or >=15um/min)')
saveas(h4,([dirName,'LastSegmentSlowsDowns','.fig']),'fig');

t