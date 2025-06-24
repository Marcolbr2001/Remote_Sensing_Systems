clc, clear all
load data/range_dopp_maps.mat
webcam = importdata('data/webcam.avi')
frame = 1;
%load range-Doppler data
%load camera data
%choose first frame
figure
%plot first camera frame
subplot(1,2,1)
image(webcam(frame).cdata)
axis image
%plot first range-Doppler frame
subplot(1,2,2)
imagesc(velvect, rangevect, 10*log10(rdmap(:,:,frame)))
xlabel('Velocity [m/s]')
ylabel('Range [m]')
axis xy
cb = colorbar; ylabel(cb, 'Magnitude [dB]')
colormap jet