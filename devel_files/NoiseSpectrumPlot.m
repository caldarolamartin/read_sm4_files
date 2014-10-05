
[FULL_DATA META_DATA]=read_sm4('NoiseSpectrum_0001.sm4');

NoiseSpectrumRAW = transpose(FULL_DATA{1,1}.z);
Freq = FULL_DATA{1,1}.x./1e3;

figure(1)
set(gcf,'color','white')
plot(Freq,NoiseSpectrumRAW)
xlim([0 125])
xlabel('Frequency (kHz)')
ylabel('Current FFT (A/sqrt(Hz))')
