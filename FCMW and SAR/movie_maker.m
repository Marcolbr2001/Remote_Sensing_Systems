%23.3.2025%

clc, close all, clear all

% Get data
load data/range_dopp_maps.mat
webcam = importdata('data/webcam.avi');

function cfarDetection = detect_over_frame(rdMap)
    %% CFAR Parameters
    numGuard = 4;   % Number of guard cells
    numTrain = 12;  % Number of training cells
    alpha = 100;    % Soglia fissa (semplificata)

    cfarDetection = zeros(size(rdMap));
    [rows, cols] = size(rdMap);

    for i = numTrain + numGuard + 1 : rows - (numTrain + numGuard)
        for j = numTrain + numGuard + 1 : cols - (numTrain + numGuard)
            refCells = rdMap(i - numTrain - numGuard : i + numTrain + numGuard, ...
                             j - numTrain - numGuard : j + numTrain + numGuard);
            % Rimuovi guard cells & CUT
            refCells(numTrain+1:end-numTrain, numTrain+1:end-numTrain) = 0;
            refCells = refCells(refCells > 0);

            noiseLevel = mean(refCells);
            threshold = alpha * noiseLevel;

            if rdMap(i, j) > threshold
                cfarDetection(i, j) = 1;
            end
        end
    end
end

% Create a Video Writer
outputVideo = VideoWriter('CFAR_Detection_Video_1000.avi');
outputVideo.FrameRate = 1/framePeriod;
open(outputVideo);

numFrames = size(rdmap, 3);

for frame = 1:numFrames
    if mod(frame, 5) == 0
        fprintf('Processing frame %d (multiple of 5)...\n', frame);
    end
    
    Detection1 = detect_over_frame(rdmap(:,:,frame));
    
    figure('Visible', 'off');
    
    % Subplot (1,2,1) - webcam
    subplot(1,2,1)
    image(webcam(frame).cdata)
    axis image
    title('Webcam Frame');
    
    % Subplot (1,2,2) - range-doppler + CFAR
    subplot(1,2,2)
    ax1 = gca;  % asse principale
    imagesc(velvect, rangevect, 10*log10(rdmap(:,:,frame))), axis xy;
    caxis(ax1, [-130 -30]);  % Fissa la scala tra -130 e -30 dB
    xlabel(ax1, 'Velocity [m/s]');
    ylabel(ax1, 'Range [m]');
    colorbar; 
    colormap jet;
    title(ax1, 'CFAR Detection');
    hold(ax1, 'on');
    
    % Disegno i punti rilevati (cerchi neri)
    [detectedRows, detectedCols] = find(Detection1 == 1);
    for k = 1:length(detectedRows)
        plot(ax1, velvect(detectedCols(k)), rangevect(detectedRows(k)), ...
             'ko', 'MarkerSize', 6, 'LineWidth', 0.5);
    end
    hold(ax1, 'off');
    
    % Crea un secondo asse trasparente sovrapposto, solo per l'etichetta a destra
    ax2 = axes('Position', get(ax1, 'Position'), ...
               'Color','none',...
               'YAxisLocation','right',...
               'Box','off',...
               'TickLength',[0 0],...
               'XColor','none',...
               'YTick',[],...
               'XTick',[]);
    set(ax2, 'YLim', get(ax1, 'YLim'));  % Allinea i limiti y con ax1
    
    % Disabilita la linea dell'asse y (nessun colore)
    set(ax2, 'YColor', 'none');
    % Crea la label con colore nero
    ylabel(ax2, 'Magnitude [dB]', 'Color', 'k');
    
    % Cattura e salva il frame video
    frameCapture = getframe(gcf);
    writeVideo(outputVideo, frameCapture);
    close(gcf);
end

fprintf('Video processing completed successfully!\n');
close(outputVideo);
