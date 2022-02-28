clc; clear;
echo off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Signal Generation
% load reference signal
[ref,fs]= audioread('ref_signal.wav');

% load mic signal (real nonlinearity)
[mic,~]= audioread('mic_signal.wav');

% shorten both signals to a 9s duration
ref=ref(1:9*fs);
mic=mic(1:9*fs);

% load RIR
N = 256;
h = audioread('h.wav');
h = h(1:N); % limit the length of the RIR

% convolve to get reverb. nonlinearly distorted s, i.e., y
y= fftfilt(h,mic);

% add noise
snr_level = 30;
y = awgn(y,30,'measured');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% NL-AEC
P=3; % can be changed

% apply NL-AEC (usign power filters)
[ e_NL ] = NLAEC();

% apply AEC (Linear part only) %use P=1 to include only one basis functions, the linear one x^1 
[ e_L ] = NLAEC();

% evaluate both algorithms using the residual to calculate the ERLE (both
% the avg. ERLE and the instant. ERLE)
ERLE = 10 * log10(filter(0.1, [1 -0.9994], y.^2) ./ filter(0.1, [1 -0.9994], (e_NL)'.^2));
ERLE_avg= mean(ERLE)


ERLE_linear = 10 * log10(filter(0.1, [1 -0.9994], y.^2) ./ filter(0.1, [1 -0.9994], (e_L)'.^2));
ERLE_avg_linear= mean(ERLE_linear)

figure
subplot(2,1,1)
plot(ERLE); grid on ; hold on; plot(y)
title('NLAEC')
legend('ERLE','speech')
subplot(2,1,2)
plot(ERLE_linear); grid on ; hold on; plot(y)
title('AEC')
legend('ERLE','speech')


