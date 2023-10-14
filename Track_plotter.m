% load sprintf('IST_plots-%d',seq);
% load 06-IS_2
track=tracks;
imageDir = 'D:\Cell Tracking\Data0919\set3_images\';
outputfolder='D:\Cell Tracking\Data0919\Results'
List = dir([imageDir '\*.tif']);
cols1 = colormap(jet);
cols=flipud(cols1);
cols2=colormap(lines);
% frameNum = 24
stFrame = 0;
endFrame = 338;

%xdata=[-1.2625e+03 1.1209e+04] %dataset 2
%ydata=[-682.1626 1.4215e+04]


% xdata=[-3.1354e+03 1.7104e+04] %dataset 1
% ydata=[1 1.7504e+04]
% figure('Position',[scrsz(1)+ 50 scrsz(2) + 50 scrsz(3)-25 scrsz(4)-25])
for frameNum = stFrame:endFrame % loop over frame in video
    
    %I = imread([imageDir '\' List(frameNum+1).name]);
    I = imread([imageDir '\' List(frameNum+1).name]);
    %     I=imread
    %     figure
    %load(['D:\Cell Tracking\Data0919\set2_detections\' sprintf('feats%.4d.mat',frameNum)]);
    %    imshow(I,'XData',xdata,'YData',ydata')
    imshow(I)
    %     set(gca, 'XLim',[2500 4500], 'YLim', [10000 12000])
    % set(gca, 'XLim',[5150 5800], 'YLim', [3300 4100])%702
    % set(gca, 'XLim',[5300 5800], 'YLim', [3300 4000]) %800
    % set(gca, 'XLim',[5000 5800], 'YLim', [3300 4000]) %718
    % set(gca, 'XLim',[5100 5600], 'YLim', [4250 4850]) %380
    % set(gca, 'XLim',[5250 5500], 'YLim', [4550 4850])  %394
    % set(gca, 'XLim',[4500 6500], 'YLim', [3000 5000]) %imp
    %set(gca, 'XLim',[5000 7000], 'YLim', [4000 6000])%imp2
    % set(gca, 'XLim',[4500 5500], 'YLim', [4000 5000])
    % set(gca, 'XLim',[5000 5500], 'YLim', [4500 5000])
    % set(gca, 'XLim',[5000 6000], 'YLim', [3000 4000])
    % set(gca, 'XLim',[1200 2700], 'YLim', [500 2300])
    % set(gca, 'XLim',[5500 7500], 'YLim', [8000 10000])
    % set(gca, 'XLim',[1250 2000], 'YLim', [9700 10550])
    % set(gca, 'XLim',[8250 9250], 'YLim', [8250 9000])
    % set(gca, 'XLim',[1000 2000], 'YLim', [9200 10200])
    %set(gca, 'XLim',[2500 3300], 'YLim', [8700 9700])
    
    %     figure;
    hold on;
    %   plot(3461,11374,'r*','Linewidth',5)
    % for i=1:size(feats.pos,1)
    % % for i=1:size(predicted_destinations,1)
    % rectangle('Position',[feats.pos(i,1)-3,feats.pos(i,2)-3,6,6],'EdgeColor', 'r');
    % end
    %     hold on;
    % k=430;
    % k=702;
    % k=1863;1887N
    % k=2363;
    % k=4236 %4656
    % k=3615;
    % k=2719
    n=1
    %     for m = 1:2
    %         if m==1
    %             k=392
    %         else
    %             k=430
    %         end
    %  for l=11:length(track{k}.candidate);
    for k=1:length(track)
        % k=718
        l=1
        % for l=length(track{k}.candidate):-1:1
        T = track{k}.candidate{l}.track;
        btypes = track{k}.candidate{l}.blobTypes;
        %         F=length(track{k}.candidate{1});
        %F = find(track{k}.candidate{l}.blobIndFrameNums == frameNum );
        F = find(track{k}.candidate{l}.blobIndFrameNums == frameNum )-1;
        if isempty(F), continue; end;
        if length(find(btypes==2 | btypes==3))/size(T,1) > 0.5, continue; end; %changed by SH from 0.5
        %          if length(find(btypes==3))/size(T,1) > 0.5, continue; end;
        if size(T,1) < 2, continue; end;
        %         if F>size(T,1), continue; end;
        
        P(n)=k;
        n=n+1;
        assert(length(F) == 1);
        %
        if F<=5
            J=1;
        else
            J=F-2;
        end
        %         J=1;
        %plot(T(J:F,1), T(J:F,2), 'r-', 'color', cols2(mod(k,64)+1,:),'LineWidth',2);
        p  = patchline(T(1:F,1),T(1:F,2),'linestyle','-','edgecolor',cols2(mod(k,64)+1,:),'linewidth',2,'edgealpha',0.3);
        %           plot(T(1:F,1), T(1:F,2), '-rs', 'color', cols(mod(k,6)+1,:),'LineWidth',2,'MarkerEdgeColor','k');
        %           plot(T(J:F,1), T(J:F,2), 'r-', 'color', cols(l*25,:),'LineWidth',2);
        %           plot(T(J:F,1), T(J:F,2), 'r-', 'color', 'red','LineWidth',2);
        %         for i=1:F
        %         rectangle('Position',[T(F,1)-10,T(F,2)-10,20,20],'EdgeColor', cols2(mod(k,64)+1,:));
        %         end
        %         text(T(F,1),T(F,2),sprintf('%.d',k), 'color', cols(mod(k,6)+1,:))
        %         text(T(F,1),T(F,2),sprintf('%.d',l), 'color', cols(mod(l,6)+1,:))
        %         plot(T(J:F,1), T(J:F,2), 'r-', 'color', 'red');
        %             track2Plot = [ finalTS.track(k).x(1:F); finalTS.track(k).y(1:F) ]';
        %             plot(track2Plot(:,1), track2Plot(:,2),'r-', 'color', cols(mod(k,64)+1,:))
        %             ... % display as a line (no marker)
        %             plot(track2Plot(end, 1), track2Plot(end, 2), 'bs')
        
        %         end
        
        % end
    end
    hold off
    
    
    drawnow;
    %     pause;
    print(gcf, '-dbmp',[outputfolder '\results_set3\' sprintf('pana4-%.2d.bmp',frameNum)]);
    % end
end