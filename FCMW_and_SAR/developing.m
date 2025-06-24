%23.3.2025%

clc, close all, clear all

%get data%
load data/range_dopp_maps.mat
webcam = importdata('data/webcam.avi')

function cfarDetection = detect_over_frame(rdMap)
    
    %% CFAR Parameters
    numGuard = 5;   % Number of guard cells
    numTrain = 10;   % Number of training cells
    Pfa = 1e-6;     % Desired probability of false alarm
    
    % Calculate threshold scaling factor
    numRefCells = (2*numTrain + 2*numGuard + 1)^2 - (2*numGuard + 1)^2;
    alpha = numRefCells * (Pfa^(-1/numRefCells) - 1);
    
    % Initialize Detection Map
    cfarDetection = zeros(size(rdMap));
    
    %% CFAR Detection Process
    [rows, cols] = size(rdMap);
    
    for i = numTrain + numGuard + 1 : rows - (numTrain + numGuard)
        for j = numTrain + numGuard + 1 : cols - (numTrain + numGuard)
            % Extract reference cells
            refCells = rdMap(i - numTrain - numGuard : i + numTrain + numGuard, ...
                            j - numTrain - numGuard : j + numTrain + numGuard);
    
            % Remove guard cells & CUT
            refCells(numTrain+1:end-numTrain, numTrain+1:end-numTrain) = 0;
            refCells = refCells(refCells > 0);
    
            % Estimate noise level
            noiseLevel = mean(refCells);
            threshold = alpha * noiseLevel;
    
            % Compare CUT with threshold
            if rdMap(i, j) > threshold
                cfarDetection(i, j) = 1;
            end
        end
    end
end


frame = 1;
Detection1 = detect_over_frame(rdmap(:,:,frame));
%raw versus detection%
subplot(1,2,1)
imagesc(velvect, rangevect, 10*log10(rdmap(:,:,frame)))
xlabel('Velocity [m/s]')
ylabel('Range [m]')
axis xy
cb = colorbar; ylabel(cb, 'Magnitude [dB]')
subplot(1,2,2)
imagesc(velvect, rangevect, 10*log10(rdmap(:,:,frame)));
hold on;
% Overlay circles on detected points
[detectedRows, detectedCols] = find(Detection1 == 1);
for k = 1:length(detectedRows)
    plot(velvect(detectedCols(k)), rangevect(detectedRows(k)), 'ro', 'MarkerSize', 10, 'LineWidth', 1.5);
end
xlabel('Velocity [m/s]');
ylabel('Range [m]');
axis xy;
cb = colorbar; ylabel(cb, 'Magnitude [dB]');
colormap jet;
title('Detection with Circles Highlighting Objects');
hold off;
%-------------------------


frame = 1;
%choose first frame
figure
%plot first camera frame
subplot(1,2,1)
image(webcam(frame).cdata)
axis image
%plot first range-Doppler frame
subplot(1,2,2)
imagesc(velvect, rangevect, 10*log10(rdmap(:,:,frame)));
hold on;
% Overlay circles on detected points
[detectedRows, detectedCols] = find(Detection1 == 1);
for k = 1:length(detectedRows)
    plot(velvect(detectedCols(k)), rangevect(detectedRows(k)), 'ro', 'MarkerSize', 10, 'LineWidth', 1.5);
end
xlabel('Velocity [m/s]');
ylabel('Range [m]');
axis xy;
cb = colorbar; ylabel(cb, 'Magnitude [dB]');
colormap jet;
title('Detection with Circles Highlighting Objects');
hold off;


