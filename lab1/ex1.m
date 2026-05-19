setPlot();

%% signal parameters
cfg = getConfig();

T = 50e-3;
f_low = 500;
f_high = 1500;

%% LFM
x = getChirp(f_low, f_high, T);
N = length(x);
t = (1:N) / cfg.Fs;
t_ms = 1e3 * t;

%% time plot
fig1 = figure();
plot(t_ms, real(x));
grid on;

xlabel('$t$ [ms]');
ylabel('$\mathrm{Re}\{x(t)\}$');

title(sprintf(['LFM signal in the time domain \n' ...
               '$f_{\\mathrm{low}}=%d\\,\\mathrm{Hz}$, ' ...
               '$f_{\\mathrm{high}}=%d\\,\\mathrm{Hz}$, ' ...
               '$T=%.0f\\,\\mathrm{ms}$'], ...
               f_low, f_high, 1e3*T));

legend('$\mathrm{Re}\{x(t)\}$');

savePng(fig1, 'ex1_lfm_time.png');

%% spectrum
Nfft = 2^nextpow2(8*N);
X = fft(x, Nfft) / N;
f = (0:Nfft-1) * cfg.Fs / Nfft;

f_margin = 1000;
f_min_plot = max(0, f_low - f_margin);
f_max_plot = f_high + f_margin;
idx = (f >= f_min_plot) & (f <= f_max_plot);

fig2 = figure();
plot(f(idx), 20*log10(abs(X(idx)) + eps));
grid on;

xlabel('$f$ [Hz]');
ylabel('$|X(f)|$ [dB]');

title(sprintf(['Amplitude spectrum of the LFM signal\n' ...
               '$f_{\\mathrm{low}}=%d\\,\\mathrm{Hz}$, ' ...
               '$f_{\\mathrm{high}}=%d\\,\\mathrm{Hz}$'], ...
               f_low, f_high));

xline(f_low, '--', '$f_{\mathrm{low}}$');

xline(f_high, '--', '$f_{\mathrm{high}}$');

legend('$|X(f)|$');

savePng(fig2, 'ex1_lfm_spectrum.png');