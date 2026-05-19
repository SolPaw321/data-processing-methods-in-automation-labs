clear; close all; clc;

%% paths
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir)
    scriptDir = pwd;
end

addpath(fullfile(scriptDir, 'plotSettings'));

setPlot();

%% antenna array parameters
M = 8;
ArrayPattern = 0:M-1;

%% angle vector
angleStep = 0.01;
angleVec = -90:angleStep:90;

%% single target angle
phi0 = 30;
a0 = a(phi0, ArrayPattern, []);

%% beam pattern for one target
beamPattern = zeros(size(angleVec));

for k = 1:length(angleVec)
    beamPattern(k) = a(angleVec(k), ArrayPattern) * a0';
end

beamPatternAbs = abs(beamPattern);
beamPatternNorm = beamPatternAbs / max(beamPatternAbs);
beamPattern_dB = 20*log10(beamPatternNorm + eps);

%% plot one target
fig1 = figure();
plot(angleVec, beamPattern_dB, ...
    'DisplayName', '$|y(\varphi)|_{\mathrm{norm}}$');
grid on;

xlabel('$\varphi$ [$^\circ$]');
ylabel('$|y(\varphi)|_{\mathrm{norm}}$ [dB]');

title(sprintf(['Normalized antenna directivity pattern\n']));

xline(phi0, '--', sprintf('$\\varphi_0=%d^\\circ$', phi0), 'HandleVisibility', 'off');
legend();
xlim([min(angleVec), max(angleVec)]);
ylim([-60, 1]);

savePng(fig1, 'ex1_beam_pattern_single_target.png');

%% multiple target angles
targetAngles = [-30 15 42];

a0Multi = zeros(size(ArrayPattern));

for k = 1:length(targetAngles)
    a0Multi = a0Multi + a(targetAngles(k), ArrayPattern);
end

%% beam pattern for multiple targets
beamPatternMulti = zeros(size(angleVec));

for k = 1:length(angleVec)
    beamPatternMulti(k) = a(angleVec(k), ArrayPattern) * a0Multi';
end

beamPatternMultiAbs = abs(beamPatternMulti);
beamPatternMultiNorm = beamPatternMultiAbs / max(beamPatternMultiAbs);
beamPatternMulti_dB = 20*log10(beamPatternMultiNorm + eps);

%% plot multiple targets
fig2 = figure();
plot(angleVec, beamPatternMulti_dB, ...
    'DisplayName', '$|y(\varphi)|_{\mathrm{norm}}$');
grid on;

xlabel('$\varphi$ [$^\circ$]');
ylabel('$|y(\varphi)|_{\mathrm{norm}}$ [dB]');

title(sprintf(['Normalized antenna directivity pattern for multiple targets\n']));

for k = 1:length(targetAngles)
    xline(targetAngles(k), '--', ...
        sprintf('$\\varphi_%d=%d^{\\circ}$', k, targetAngles(k)), ...
        'HandleVisibility', 'off');
end

legend();
xlim([min(angleVec), max(angleVec)]);
ylim([-60, 1]);

savePng(fig2, 'ex1_beam_pattern_multiple_targets.png');
