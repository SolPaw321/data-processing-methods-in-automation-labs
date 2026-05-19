clear; close all; clc;

%% signal package in GNU Octave
if exist('OCTAVE_VERSION', 'builtin')
    pkg load signal;
end

setPlot();
rng(1000);

%% configuration
cfg = getConfig();

D = [500 800 1300 2000];              
tau = 2 * D / cfg.c;                  
delaySamples = round(tau * cfg.Fs);   
delaySeconds = delaySamples / cfg.Fs;
delayMeters = cfg.c * delaySeconds / 2;
delayErrorMeters = delayMeters - D;

%% required bandwidth for resolving adjacent targets
minDistanceSeparation = min(diff(D));
B_min = cfg.c / (2 * minDistanceSeparation);

%% LFM
T = 10e-3;
f_low = 500e3;
B_used = 1e6;
f_high = f_low + B_used;

x = getChirp(f_low, f_high, T);
N = length(x);
E_ref = sum(abs(x).^2);

rangeResolution = cfg.c / (2 * B_used);

%% received signal simulation
level_dB = -80;
echoAmplitude = 10^(level_dB / 20);

y = zeros(1, N + max(delaySamples));

for k = 1:length(D)
    idxStart = delaySamples(k) + 1;
    idxEnd = delaySamples(k) + N;
    y(idxStart:idxEnd) = y(idxStart:idxEnd) + echoAmplitude * x;
end

%% matched filtering / correlation
[r, lags] = xcorr(y, x);
rangeAxisMeters = cfg.c * lags / (2 * cfg.Fs);
rangeProfile_dB = 20 * log10(abs(r) / E_ref + eps);

idxPlot = (rangeAxisMeters >= 0) & (rangeAxisMeters <= max(D) + 500);

%% range profile plot
fig1 = figure();
plot(rangeAxisMeters(idxPlot), rangeProfile_dB(idxPlot), ...
    'DisplayName', '$20\log_{10}\left(|R_{yx}(d)|/E_x\right)$');
grid on;

xlabel('$d$ [m]');
ylabel('Normalized range profile [dB]');

title(sprintf(['Range profile for four delayed LFM echoes\n' ...
               '$B=%.2f\\,\\mathrm{MHz}$, ' ...
               '$T=%.0f\\,\\mathrm{ms}$, ' ...
               '$A=%.0f\\,\\mathrm{dB}$'], ...
               B_used/1e6, 1e3*T, level_dB));

for k = 1:length(D)
    xline(delayMeters(k), '--', ...
        sprintf('$D_%d=%.0f\\,\\mathrm{m}$', k, delayMeters(k)),'HandleVisibility', 'off');
end

legend();
xlim([0 max(D) + 500]);
ylim([level_dB - 60 level_dB + 10]);

savePng(fig1, 'ex4_range_profile.png');

%% bandwidth comparison for range resolution
B_min = 500000;
bandwidthVec = [1e5 B_min B_used];
bandwidthLabels = {'$B=100\,\mathrm{kHz}$', ...
                   sprintf('$B_{\\min}=%.0f\\,\\mathrm{kHz}$', B_min/1e3), ...
                   '$B=1\,\mathrm{MHz}$'};

fig2 = figure();
hold on;

for k = 1:length(bandwidthVec)
    Bk = bandwidthVec(k);
    xk = getChirp(f_low, f_low + Bk, T);
    Nk = length(xk);
    Ek = sum(abs(xk).^2);

    rxk = zeros(1, Nk + max(delaySamples));

    for m = 1:length(D)
        idxStart = delaySamples(m) + 1;
        idxEnd = delaySamples(m) + Nk;
        rxk(idxStart:idxEnd) = rxk(idxStart:idxEnd) + echoAmplitude * xk;
    end

    [rk, lags_k] = xcorr(rxk, xk);
    rangeAxisMeters_k = cfg.c * lags_k / (2 * cfg.Fs);
    rangeProfile_k_dB = 20 * log10(abs(rk) / Ek + eps);
    idxPlot_k = (rangeAxisMeters_k >= 0) & (rangeAxisMeters_k <= max(D) + 500);

    plot(rangeAxisMeters_k(idxPlot_k), rangeProfile_k_dB(idxPlot_k), ...
        'DisplayName', bandwidthLabels{k});
end

grid on;

xlabel('$d$ [m]');
ylabel('Normalized range profile [dB]');

title(sprintf(['Range profile comparison for different bandwidths\n' ...
               '$T=%.0f\\,\\mathrm{ms}$'], 1e3*T));

for k = 1:length(D)
    xline(delayMeters(k), '--', sprintf('$D_%d$', k),'HandleVisibility', 'off');
end

legend();
xlim([0 max(D) + 500]);
ylim([level_dB - 60 level_dB + 10]);

savePng(fig2, 'ex4_bandwidth_comparison.png');

%% Required pulse duration for echo peak above noise
noisePower = 2;
factorRms = 1;
factorClear = 5;

N_required_rms = ceil(factorRms^2 * noisePower / echoAmplitude^2);
T_required_rms = N_required_rms / cfg.Fs;

N_required_clear = ceil(factorClear^2 * noisePower / echoAmplitude^2);
T_required_clear = N_required_clear / cfg.Fs;

outputSnrCurrent_dB = 20 * log10((echoAmplitude * N) / sqrt(noisePower * N));
