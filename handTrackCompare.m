
function handTrackCompare


dirName = 'X:\AlexData\Torsten\trackingValidation\';
I = imread([dirName,'EB1\images\EB1\020_crop_c1t01.tif']);

load([dirName,'EB1\point_files\config001_4p00_track_bidir.mat']); %torsten
load([dirName,'EB1\group45-60\group.mat']); %torsten CHANGE TO 15-15

pixelSize = 0.107;%0.107; %0.11; % (microns)
samplingRate = 0.62; %0.39 all but EB1+MTs(0.62) - Noco 1- if not -> 0.5; % (seconds)
scaleFactor = pixelSize * 60 / samplingRate ;

traj=tracks(find([tracks.len]>=4));
leIndx = length(traj);
% calculate trajectory information
for i = 1:leIndx
    traj(i).endID = traj(i).startID + traj(i).len - 1;
    dY = traj(i).points(end,1) - traj(i).points(1,1);
    dX = traj(i).points(end,2) - traj(i).points(1,2);% Y X
    traj(i).vec = [dX; dY];
    traj(i).vel = sqrt(dY^2+dX^2)/traj(i).len;
end
traj = traj(find([traj.vel]>0)); % SOME DONT MOVE!?

leT = length(traj);
leG1 = length(group);
indxFullGr = [];
for i = 1:leG1 % for all groups
    leGi = length([group(i).list]); 
    % more than zero tracks in that group (some groups are empty due to appending during grouping)
    if leGi > 0 
        indxFullGr = [indxFullGr,i]; % BUG
    end
end
group = group(indxFullGr);
gg = 0; ss = 0; piecesInSegment = [];
leG = length(group);
for i = 1:leG % for all groups
    leGi = length([group(i).list]);
    g = 0; s = 0; 
    for j = 1:(leGi-1) % for all member-tracks of a group

        dy = traj(group(i).list(j+1)).points(1,1) - traj(group(i).list(j)).points(end,1); % link
        dx = traj(group(i).list(j+1)).points(1,2) - traj(group(i).list(j)).points(end,2);
        aVec = ([dx; dy])';
        magAvec = sqrt(sum(aVec.^2,2));

        dY = traj(group(i).list(j)).points(end,1) - traj(group(i).list(j)).points(1,1); % track
        dX = traj(group(i).list(j)).points(end,2) - traj(group(i).list(j)).points(1,2);
        traj_vec = [dX; dY];
        magTrajVec = sqrt(sum(traj_vec.^2,1));

        cos_ang = (aVec*traj_vec)./(magAvec*magTrajVec);
        if cos_ang > 0 % growth
            g = g + 1; % local counted
            gg = gg + 1; % global counter
            group(i).direction(j) = 1; % forward
            delta_T_gr_GAP(gg) = traj(group(i).list(j+1)).startID-traj(group(i).list(j)).startID-traj(group(i).list(j)).len+1;
            group(i).meanGrowth_GAP(g) = magAvec/delta_T_gr_GAP(gg);
            speedGrowth_GAP(gg) = group(i).meanGrowth_GAP(g)*scaleFactor;
        end
        if cos_ang < 0 % shrinkage % RATIOS
            s = s + 1; % local counter 
            ss = ss + 1; % global counter
            group(i).direction(j) = -1; % backward
            delta_T_sh(ss) = traj(group(i).list(j+1)).startID-traj(group(i).list(j)).startID-traj(group(i).list(j)).len+1;
            group(i).meanShrink(s) = magAvec/delta_T_sh(ss);
            speedShrink(ss) = group(i).meanShrink(s)*scaleFactor;
        end
    end
end

grNb = length(group);

for i = 1:grNb
    delta_t(i) = traj(group(i).list(end)).endID - traj(group(i).list(1)).startID + 1; 
end

[sort_gr,indx] = sort(delta_t);

for g_i = 109:109

% 
%     movieName = ['X:\AlexData\Torsten\trackingValidation\EB1\movies-data-15-15\movGroup',num2str(g_i), '.mov'];
%     MakeQTMovie('start',movieName  );
%     MakeQTMovie('quality', 1.0);
%     MakeQTMovie('size', [372 233]);
%     MakeQTMovie('framerate',10);
    f = figure;

    for i = 1 : 1%97

        strgI=sprintf('%%.%dd',2);
        indxI=sprintf(strgI,i);
        imgName = [dirName,'EB1\images\EB1\020_crop_c1t',indxI,'.tif'];
%         imgName = [dirName,'EB1\images\MTs\020_crop_c2t',indxI,'.tif'];
        imgTemp = imread(imgName);

        imshow(imgTemp, []);
        %     imagesc(1:300,1:300,imgTemp) % SCALE IMAGE
%         text(20,20,[' frame ',num2str(i)],'Color','w','LineWidth',0.3);
        text(20,20,[' lifetime ',num2str(delta_t(g_i))],'Color','w','LineWidth',0.3);
        colormap gray
        hold on;


        % PLOT ALL TRACKS - also ungrouped
        %------------------------------------------------------------
        h1 = plot(traj(group(g_i).list(1)).points(1,1),traj(group(g_i).list(1)).points(1,2),'wo');
        set(h1, 'LineWidth', 0.01)
        text(20,40,[' start ',num2str(traj(group(g_i).list(1)).startID)],'Color','w','LineWidth',0.3);
        text(20,60,[' end ',num2str(traj(group(g_i).list(end)).endID)],'Color','w','LineWidth',0.3);
        for j = 1:length([group(g_i).list])
            % plot all tracks, head to tail only?
%             plotTransparent(traj(group(g_i).list(j)).points(:,1),traj(group(g_i).list(j)).points(:,2),5,'b',0.1,1);                
            h2 = plot(traj(group(g_i).list(j)).points(:,1),traj(group(g_i).list(j)).points(:,2),'w');
            set(h2, 'LineWidth', 0.01)
            % plot all gaps, both + 1 and -1, length=track-1
            % two colors
            if j<length([group(g_i).list]) & group(g_i).direction(j)==-1
%                 plotTransparent([traj(group(g_i).list(j)).points(end,1),traj(group(g_i).list(j+1)).points(1,1)],[traj(group(g_i).list(j)).points(end,2),traj(group(g_i).list(j+1)).points(1,2)],5,'r',0.1,1);                
                h3 = plot([traj(group(g_i).list(j)).points(end,1),traj(group(g_i).list(j+1)).points(1,1)],[traj(group(g_i).list(j)).points(end,2),traj(group(g_i).list(j+1)).points(1,2)],'r');
                set(h3, 'LineWidth', 0.01)
            elseif j<length([group(g_i).list]) & group(g_i).direction(j)==1
%                 plotTransparent([traj(group(g_i).list(j)).points(end,1),traj(group(g_i).list(j+1)).points(1,1)],[traj(group(g_i).list(j)).points(end,2),traj(group(g_i).list(j+1)).points(1,2)],5,'g',0.1,1);                
                h4 = plot([traj(group(g_i).list(j)).points(end,1),traj(group(g_i).list(j+1)).points(1,1)],[traj(group(g_i).list(j)).points(end,2),traj(group(g_i).list(j+1)).points(1,2)],'g');
                set(h4, 'LineWidth', 0.01)
            end
            % plot catastrophe and rescue - two color (add non-grouped track
            % rescue??)
            %         plot
        end
        %------------------------------------------------------------

        axes(gca(f));
%         MakeQTMovie('addaxes');
        hold off;
        %     waitbar((i - 1) / (length(handles.imageStackList) - 1), h);
    end
    % close(h)
%     MakeQTMovie('finish');


end














