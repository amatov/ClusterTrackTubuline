function makeMovieTorsten

MakeQTMovie('start', QTMovieName{q_idx});

    for time_idx = 1:nColumn
        pixel_list = this_pixel_edge{time_idx};
        round_pixel_list = round(pixel_list);
        pixelNum = size(round_pixel_list,1);

        nfold = SEG_NR;
        binsize = floor(pixelNum/nfold);
        start_idx = 0;
        idx{1} = mod(start_idx:(start_idx+binsize-1), pixelNum)+1;
        start_idx = mod(start_idx+binsize, pixelNum)+1;
        for w=2:(nfold-mod(pixelNum, nfold))
            idx{w} = start_idx:(start_idx+binsize-1);
            start_idx  = start_idx+binsize;
        end
        for w=(nfold+1-mod(pixelNum, nfold)):nfold
            idx{w} = start_idx:(start_idx+binsize);
            start_idx  = start_idx+binsize+1;
        end
        sector_idx = [];
        for j=1:nfold
            sector_idx = [sector_idx; j*ones(length(idx{j}),1)];
        end

        if isfield(handles, 'imgDir')
            img_edge_rgb = imread([handles.imgDir filesep imgDir(time_idx).name]);
            img_edge_rgb = repmat(mat2gray(img_edge_rgb), [1,1,3]);
        else
            img_edge_rgb = zeros(rowSize,colSize,3);
        end
        for j=1:pixelNum
            if round_pixel_list(j,1) > 0 & round_pixel_list(j,1) <= colSize & round_pixel_list(j,2) > 0 & round_pixel_list(j,2) <= rowSize
                img_edge_rgb(round_pixel_list(j,2),round_pixel_list(j,1),1)=cmap_edge_evolution(MAP_COLOR(sector_idx(j),time_idx),1);
                img_edge_rgb(round_pixel_list(j,2),round_pixel_list(j,1),2)=cmap_edge_evolution(MAP_COLOR(sector_idx(j),time_idx),2);
                img_edge_rgb(round_pixel_list(j,2),round_pixel_list(j,1),3)=cmap_edge_evolution(MAP_COLOR(sector_idx(j),time_idx),3);

                img_edge_rgb(1+25:MAP_SCALE+25,[1:10]+10,:) = scalebar;
            end
        end

        h_QT = figure(101); % FIGURE
        imshow(img_edge_rgb, []);
        title('Protrusion/Retraction in Sectors');
        text(5,10, ['#' num2str(time_idx)], 'Color', 'white', 'FontSize', 12);
        text(22,25, [num2str(round(MAX_COLOR_VAL_PROT*10)/10)], 'Color', 'yellow', 'FontSize', 9);
        text(22,25+MAP_SCALE, [num2str(-round(MAX_COLOR_VAL_PROT*10)/10)], 'Color', 'yellow', 'FontSize', 9);
        hold on;
        plot(round_pixel_list(1,1), round_pixel_list(1,2),'ro','MarkerFaceColor','r','MarkerSize',5); % PLOT TRACKS
        hold off;

        MakeQTMovie addfigure
        if snapShot
            print(h_QT, [output_dir filesep 'snapShot' filesep 'snap' num2str(time_idx) '.eps'],'-depsc2');
        end
    end
    close(h_QT);

    MakeQTMovie('finish');
    fprintf(1,'%s has been generated.\n',QTMovieName{q_idx});

end
