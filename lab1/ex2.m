clear; close all; clc;

%% signal package in Octave
if exist('OCTAVE_VERSION', 'builtin')
    pkg load signal;
end

setPlot();
rng(1000);

%% signal parameters
cfg = getConfig();

f_low = 500;
f_high = 1500;
snr_dB = -30;
snr_lin = 10^(snr_dB / 10);

%% Main LFM signal duration
T = 10e-3;

%% LFM
x = getChirp(f_low, f_high, T);
N = length(x);
t = (1:N) / cfg.Fs;
t_ms = 1e3 * t;

%% complex Gaussian noise scaled to the required SNR
var_lfm = mean(abs(x - mean(x)).^2);

noise_raw = crandn(size(x));
var_noise_raw = mean(abs(noise_raw - mean(noise_raw)).^2);

var_noise_target = var_lfm / snr_lin;
noise = noise_raw * sqrt(var_noise_target / var_noise_raw);

var_noise = mean(abs(noise - mean(noise)).^2);
snr_actual_dB = 10 * log10(var_lfm / var_noise)

%% noisy LFM
x_noisy = x + noise;

%% time plot
fig1 = figure();
plot(t_ms, abs(x_noisy));
grid on;

xlabel('$t$ [ms]');
ylabel('$|x(t)|$');

title(sprintf(['Noisy LFM signal\n' ...
               '$f_{\\min}=%d\\,\\mathrm{Hz}$, ' ...
               '$f_{\\max}=%d\\,\\mathrm{Hz}$, ' ...
               '$T=%.0f\\,\\mathrm{ms}$, ' ...
               '$SNR=%.1f\\,\\mathrm{dB}$'], ...
               f_low, f_high, 1e3*T, snr_actual_dB));

legend('$|x(t)|$');

savePng(fig1, 'ex2_noisy_lfm_time.png');

%% Correlation between the noisy received signal and the original LFM signal
[r, lags] = xcorr(x_noisy, x);
r_abs = abs(r);
lag_ms = 1e3 * lags / cfg.Fs;

fig2 = figure();
plot(lag_ms, r_abs);
grid on;

xlabel('$\tau$ [ms]');
ylabel('$|R_{yx}(\tau)|$');

title(sprintf(['Magnitude of correlation between noisy and original LFM signals\n' ...
               '$T=%.0f\\,\\mathrm{ms}$, ' ...
               '$SNR=%.1f\\,\\mathrm{dB}$'], ...
               1e3*T, snr_actual_dB));

xline(0, '--', '$\tau=0$');
legend('$|R_{yx}(\tau)|$');

savePng(fig2, 'ex2_lfm_correlation.png');

%% correlation peak height for four different durations
T_vec = [2.5 5 10 20] * 1e-3;
N_vec = zeros(size(T_vec));
peak_zero_lag = zeros(size(T_vec));
peak_max = zeros(size(T_vec));
peak_noiseless = zeros(size(T_vec));
snr_actual_vec_dB = zeros(size(T_vec));

for k = 1:length(T_vec)
    Tk = T_vec(k);

    xk = getChirp(f_low, f_high, Tk);
    N_vec(k) = length(xk);

    var_lfm_k = mean(abs(xk - mean(xk)).^2);

    noise_raw_k = crandn(size(xk));
    var_noise_raw_k = mean(abs(noise_raw_k - mean(noise_raw_k)).^2);

    var_noise_target_k = var_lfm_k / snr_lin;
    noise_k = noise_raw_k * sqrt(var_noise_target_k / var_noise_raw_k);
    var_noise_k = mean(abs(noise_k - mean(noise_k)).^2);

    snr_actual_vec_dB(k) = 10 * log10(var_lfm_k / var_noise_k);

    x_noisy_k = xk + noise_k;

    [rk, lags_k] = xcorr(x_noisy_k, xk);
    rk_abs = abs(rk);

    idx_zero = find(lags_k == 0, 1);

    peak_zero_lag(k) = rk_abs(idx_zero);
    peak_max(k) = max(rk_abs);
    peak_noiseless(k) = sum(abs(xk).^2);
end

%% correlation peak vs signal duration
fig3 = figure();
plot(1e3*T_vec, peak_zero_lag, '-o', 'DisplayName', '$|R_{yx}(0)|$');
hold on;
plot(1e3*T_vec, peak_max, '-s', 'DisplayName', '$\max_{\tau}|R_{yx}(\tau)|$');
grid on;

xlabel('$T$ [ms]');
ylabel('$|R_{yx}(\tau)|$');

title(sprintf(['Correlation peak height versus LFM signal duration\n' ...
               '$SNR=%.1f\\,\\mathrm{dB}$'], snr_dB));

legend();

savePng(fig3, 'ex2_correlation_peak_vs_duration.png');
