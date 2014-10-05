clear 
close all


addpath('/home/martin/lec/phd/programas/matlab/read_sm4/')


%%
disp('Reading Data')

[FULL_DATA META_DATA]=read_sm4('NoiseSpectrum_0001.sm4');
disp('Done')
disp(' ')
disp(strcat('System Text: ',META_DATA{1}.string_data.System_Text))

%% extract data
NoiseSpectrumRAW = transpose(FULL_DATA{1,1}.z);
Freq = FULL_DATA{1,1}.x./1e3;

%% plot

figure(1)
plot(Freq,NoiseSpectrumRAW,'.')
% xlim([0 125])
xlabel(strcat('Frequency [',META_DATA{1}.string_data.X_Units,']'))
ylabel(strcat('Current FFT [',META_DATA{1}.string_data.Z_Units,']'))
title(META_DATA{1}.string_data.Label)
