close all;
%%
cases = {'zeros','noMeasures','cutOff','cutOffMultiple'};
for caseNum = 1 : length(cases)
	load(['Outputs\x-' cases{caseNum} '.mat']);
	xS = x(1:4:end,:);
	xE = x(2:4:end,:);
	xI = x(3:4:end,:);
	xR = x(4:4:end,:);
	plotColors = {'#0072BD','#D95319','#EDB120','#7E2F8E'};
	
	%% Plot all neighborhood proportions
	figure(1);
	t1 = tiledlayout(5,3);
	t1.TileSpacing = 'compact';
	for i = 1 : 13
		nexttile;
		nh = [xS(i,:)' xE(i,:)' xI(i,:)' xR(i,:)'];  % SEIR for neighborhood i
		area(nh)
		title(sprintf('Neighborhood %i',i));
		axis tight;
		ylabel('# Individuals');
		xlabel('Days');
		if i == 1
			legend('S','E','I','R')
		end
	end
	% set(gcf,'position',[20 334 1850 431]); % 3 x 7
	set(gcf,'position',[10 61 857 910]);  % 5 x 3
	
	%% Plot time evolution for all neighborhoods
	figure(2);
	t2= tiledlayout(5,3);
	t2.TileSpacing = 'compact';
	tVec = dt*(1:size(xS,2));
	for nb = 1:13
		nexttile;
		plot(tVec,xS(nb,:),'LineWidth',1.5,'Color',plotColors{1}); hold on;
		plot(tVec,xE(nb,:),'LineWidth',1.5,'Color',plotColors{2});
		plot(tVec,xI(nb,:),'LineWidth',1.5,'Color',plotColors{3});
		plot(tVec,xR(nb,:),'LineWidth',1.5,'Color',plotColors{4}); hold off;
		ylabel('# Individuals');
		xlabel('Days');
		if i == 1
			legend('S','E','I','R')
		end
		title(sprintf('Neighborhood %d',nb));
	end
	set(gcf,'position',[920 61 857 910]);  % 5 x 3
	%% Plot animation for a single neighborhood
	nb = 2; % 1:13
	figure(3);
	t2= tiledlayout(5,3);
	t2.TileSpacing = 'compact';
	s1 = animatedline('color','#0072BD','LineWidth',1.5); % Blue
	e1 = animatedline('color','#D95319','LineWidth',1.5); % Orange
	i1 = animatedline('color','#EDB120','LineWidth',1.5); % Yellow
	r1 = animatedline('color','#7E2F8E','LineWidth',1.5); % Purple
	ylabel('# Individuals');
	xlabel('Days');
	legend('S','E','I','R')
	tVec = dt*(1:size(xS,2));
	xlim([0,max(tVec)]);
	ylim([0,max(max(xS))]);
	step = 1/dt;
	for i = 1 : step : size(xS,2)
		addpoints(s1,tVec(i),xS(nb,i));
		addpoints(e1,tVec(i),xE(nb,i));
		addpoints(i1,tVec(i),xI(nb,i));
		addpoints(r1,tVec(i),xR(nb,i));
		title(sprintf('Neighborhood %i, t = %.1f days',nb,(i+step-1)*dt));
		pause(0.033); % ~30 updates/sec
	end
	%% Geobubble visualization
	% Plot initial population
	% figure(4)
	% cambridge = readtable('Cambridge/cam.xlsx');
	% b1 = geobubble(cambridge.lat,cambridge.lon,cambridge.pop,'Basemap','topographic');
	% grid off;
	% title('Cambridge, MA')
	% b1.SizeLegendTitle = 'Population (2019)';
	
	%% Geobubble time evolution
	figure(5)
	cambridge = readtable('Cambridge/cam.xlsx');
	b2 = geobubble(cambridge.lat,cambridge.lon,xI(:,1),'BubbleColorList',[0.9290, 0.6940, 0.1250]);
	sizeMax = max(max(xI));
	sizeMin = min(min(xI));
	b2.SizeLimits = [floor(sizeMin) floor(sizeMax)];
	b2.BubbleWidthRange = [1 20];
	% geolimits(lat,long);
	frameCnt = 1;
	for i = 1:(1/dt):size(xS,2)
		b2.SizeData = xI(:,i);
		b2.SizeLegendTitle = '# Infected';
		title(sprintf(['Cambridge, MA: ' cases{caseNum} ', t = %.1f days'],(i+step-1)*dt));
		grid off;
		drawnow;
		frame(frameCnt) = getframe(gcf);             % Low resolution
		frameCnt = frameCnt + 1;
	end
	
	%% Write frames
	writerObj = VideoWriter(['Outputs\Cambridge-' cases{caseNum} '.mp4'],'MPEG-4');
	writerObj.FrameRate = size(frame,2)/10; % Frames/sec
	writerObj.Quality = 100;
	open(writerObj);
	for i=1:length(frame)
		frameWrite = frame(i);
		writeVideo(writerObj, frameWrite);
	end
	close(writerObj);
end

%% Plot validation data
formatFig(f2,[321   114   725   411],[0 20000 40000 60000 80000 100000 120000]);
