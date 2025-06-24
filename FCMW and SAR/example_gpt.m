
% MATLAB Code for CA-CFAR Detection on Range-Doppler Map

clc;
clear;
close all;

%% Generate a Synthetic Range-Doppler Map
rng(0);  % For reproducibility
rdMap = randn(100, 100);  % Background noise

% Add some synthetic targets
rdMap(20, 30) = rdMap(20, 30) + 52;  % Target 1
rdMap(50, 70) = rdMap(50, 70) + 55;  % Target 2
rdMap(80, 40) = rdMap(80, 40) + 50;  % Target 3

% Apply Gaussian smoothing to mimic realistic radar data
rdMap = imgaussfilt(rdMap, 1.5);

%% CFAR Parameters
numGuard = 2;   % Number of guard cells
numTrain = 6;   % Number of training cells
Pfa = 1e-3;     % Desired probability of false alarm

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

%% Plot Results
figure;
subplot(1,2,1);
imagesc(rdMap); 
colorbar;
%colormap('viridis');
title('Original Range-Doppler Map');

subplot(1,2,2);
imagesc(cfarDetection);
colorbar;
colormap('gray');
title('CFAR Detection Map');
