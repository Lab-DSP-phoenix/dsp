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
%P=7,Podd=4; four basis {1,3,5,7}
P=7; % can be changed

% apply NL-AEC (usign power filters)
[ e_NL ] = NLAEC(ref,y,P,N);

% apply AEC (Linear part only) %use P=1 to include only one basis functions, the linear one x^1 
[ e_L ] = NLAEC(ref,y,1,N);

% evaluate both algorithms using the residual to calculate the ERLE (both
% the avg. ERLE and the instant. ERLE)
ERLE = 10 * log10(filter(0.1, [1 -0.9994], y.^2) ./ filter(0.1, [1 -0.9994], (e_NL)'.^2));
ERLE_avg= mean(ERLE)


ERLE_linear = 10 * log10(filter(0.1, [1 -0.9994], y.^2) ./ filter(0.1, [1 -0.9994], (e_L)'.^2));
ERLE_avg_linear = mean(ERLE_linear)

figure

plot(ERLE); grid on ; hold on; plot(ERLE_linear,'--');plot(y)
title('NLAEC & linearAEC')
xlabel("iteration k")
ylabel("ERLE [dB]")
legend('ERLE-nonlinear','ERLE-linear','speech')



