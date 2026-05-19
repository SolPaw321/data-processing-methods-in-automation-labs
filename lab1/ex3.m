clear; close all; clc;

%% signal package in GNU Octave
if exist('OCTAVE_VERSION', 'builtin')
    pkg load signal;
end

setPlot();

%% signal parameters
cfg = getConfig();

T = 10e-3;
f_low = 500;
f_high = 1500;

%% LFM
x = getChirp(f_low, f_high, T);

%% autocorrelation of the reference LFM
[r, lags] = xcorr(x, x);
r_abs = abs(r);
r_abs_norm = r_abs / max(r_abs);
r_dB = 20*log10(r_abs_norm + eps);
lag_ms = 1e3 * lags / cfg.Fs;

widthInfo = getMainLobeWidth3dB(r_abs, lags, cfg.Fs);

%% autocorrelation plot for the basic frequency range
fig1 = figure();
plot(lag_ms, r_dB, 'DisplayName', '$|R_{xx}(\tau)|$');
grid on;

xlabel('$\tau$ [ms]');
ylabel('$|R_{yx}(\tau)|_{\mathrm{norm}}$ [dB]');

vlineLeft = 1e3 * widthInfo.leftLagSamples / cfg.Fs;
vlineRight = 1e3 * widthInfo.rightLagSamples / cfg.Fs;

title(sprintf(['Normalized LFM autocorrelation\n' ...
               '$f_{\\mathrm{low}}=%d\\,\\mathrm{Hz}$, ' ...
               '$f_{\\mathrm{high}}=%d\\,\\mathrm{Hz}$, ' ...
               '$T=%.0f\\,\\mathrm{ms}$, ' ...
               '$B=%d\\,\\mathrm{Hz}$, ' ...
               '$W_{3\\mathrm{dB}}=%.3f\\,\\mathrm{ms}$'], ...
               f_low, f_high, 1e3*T, f_high - f_low, widthInfo.widthMilliseconds));

legend();
yline(-3, '--', '$-3\mathrm{dB}$','HandleVisibility', 'off');
xline(0, '--', '$\tau=0$','HandleVisibility', 'off');
xline(vlineLeft, ':', '$\tau_L$','HandleVisibility', 'off');
xline(vlineRight, ':', '$\tau_R$', 'HandleVisibility', 'off');

xlim([-3 3]);
ylim([-40 1]);

savePng(fig1, 'ex3_autocorrelation_basic.png');

%% main-lobe width for three different bandwidths
freqRanges = [500 1500;
              500 2500;
              500 4500];

f_low_vec = freqRanges(:, 1);
f_high_vec = freqRanges(:, 2);
bandwidth_vec = f_high_vec - f_low_vec;

width_ms = zeros(size(bandwidth_vec));
width_samples = zeros(size(bandwidth_vec));
peak_values = zeros(size(bandwidth_vec));

fig2 = figure();
hold on;

for k = 1:length(bandwidth_vec)
    fk_low = f_low_vec(k);
    fk_high = f_high_vec(k);

    xk = getChirp(fk_low, fk_high, T);

    [rk, lags_k] = xcorr(xk, xk);
    rk_abs = abs(rk);
    rk_abs_norm = rk_abs / max(rk_abs);
    rk_dB = 20*log10(rk_abs_norm + eps);
    lag_ms_k = 1e3 * lags_k / cfg.Fs;

    info_k = getMainLobeWidth3dB(rk_abs, lags_k, cfg.Fs);

    width_ms(k) = info_k.widthMilliseconds;
    width_samples(k) = info_k.widthSamples;
    peak_values(k) = info_k.peakValue;

    idx_plot = abs(lag_ms_k) <= 3;

    plot(lag_ms_k(idx_plot), rk_dB(idx_plot), ...
        'DisplayName', sprintf('$B=%d\\,\\mathrm{Hz}$', bandwidth_vec(k)));
end

grid on;

xlabel('$\tau$ [ms]');
ylabel('Normalized autocorrelation [dB]');

title(sprintf(['Normalized LFM autocorrelation for different bandwidths\n' ...
               '$T=%.0f\\,\\mathrm{ms}$'], 1e3*T));

legend();
yline(-3, '--', '$-3\,\mathrm{dB}$','HandleVisibility', 'off');
xline(0, '--', '$\tau=0$','HandleVisibility', 'off');

xlim([-3 3]);
ylim([-40 1]);

savePng(fig2, 'ex3_autocorrelation_bandwidth_comparison.png');

%% 3 dB main-lobe width vs bandwidth
fig3 = figure();
plot(bandwidth_vec, width_ms, '-o', 'DisplayName', '$W_{3\mathrm{dB}}$');
grid on;

xlabel('$B$ [Hz]');
ylabel('$W_{3\mathrm{dB}}$ [ms]');

title(sprintf(['$3\\,\\mathrm{dB}$ main-lobe width versus LFM bandwidth\n' ...
               '$T=%.0f\\,\\mathrm{ms}$'], 1e3*T));
legend();
savePng(fig3, 'ex3_main_lobe_width_vs_bandwidth.png');
