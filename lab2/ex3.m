clear; close all; clc;

%% paths
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir)
    scriptDir = pwd;
end

addpath(fullfile(scriptDir, 'plotSettings'));

oldDir = pwd;
cleanupObj = onCleanup(@() cd(oldDir));
cd(scriptDir);

setPlot();

%% simulation parameters
MVec = [4 8 16 128];

phi0 = 0;                      % object angle [deg]
angleStep = 0.01;              % angle resolution [deg]
angleVec = -90:angleStep:90;   % angle grid [deg]

%% output vectors
beamwidth3dBVec = zeros(size(MVec));
sidelobeLevelVec = zeros(size(MVec));
sidelobeLevelDbVec = zeros(size(MVec));
sidelobeDistanceVec = zeros(size(MVec));
phiSidelobeVec = zeros(size(MVec));

%% plot all patterns
fig1 = figure();
hold on;

for i = 1:length(MVec)

    %% antenna array
    M = MVec(i);
    ArrayPattern = 0:M-1;

    %% antenna response for target angle phi0
    a0 = a(phi0, ArrayPattern, []);

    %% beam pattern
    beamPattern = zeros(size(angleVec));

    for k = 1:length(angleVec)
        beamPattern(k) = a(angleVec(k), ArrayPattern, []) * a0';
    end

    %% normalization and dB scale
    beamPatternAbs = abs(beamPattern);
    beamPatternNorm = beamPatternAbs / max(beamPatternAbs);
    beamPattern_dB = 20*log10(beamPatternNorm + eps);

    %% measurements from task 2
    [beamwidth3dB, phiLeft3dB, phiRight3dB, phiCenter] = ...
        get3dbBeamwidth(beamPattern, angleVec);

    [sidelobeLevel, sidelobeDistance, phiSidelobe, ~] = ...
        getSidelobeLevel(beamPattern, angleVec);

    %% save results
    beamwidth3dBVec(i) = beamwidth3dB;
    sidelobeLevelVec(i) = sidelobeLevel;
    sidelobeLevelDbVec(i) = 20*log10(sidelobeLevel + eps);
    sidelobeDistanceVec(i) = sidelobeDistance;
    phiSidelobeVec(i) = phiSidelobe;

    %% plot current pattern
    plot(angleVec, beamPattern_dB, ...
        'DisplayName', sprintf('$M=%d$', M));

end

%% finish main plot
xline(phi0, '--', '$\varphi_0=0^\circ$', 'HandleVisibility', 'off');
yline(-3, '--', '$-3\,\mathrm{dB}$', 'HandleVisibility', 'off');

grid on;
xlabel('$\varphi$ [$^\circ$]');
ylabel('$|y(\varphi)|_{\mathrm{norm}}$ [dB]');
title('Normalized antenna directivity patterns for different array sizes');
legend();
xlim([min(angleVec), max(angleVec)]);
ylim([-60, 1]);

savePng(fig1, 'ex3_beam_patterns_different_M.png');

%% zoomed plot around the main beam
fig2 = figure();
hold on;

for i = 1:length(MVec)

    M = MVec(i);
    ArrayPattern = 0:M-1;
    a0 = a(phi0, ArrayPattern, []);

    beamPattern = zeros(size(angleVec));

    for k = 1:length(angleVec)
        beamPattern(k) = a(angleVec(k), ArrayPattern, []) * a0';
    end

    beamPatternAbs = abs(beamPattern);
    beamPatternNorm = beamPatternAbs / max(beamPatternAbs);
    beamPattern_dB = 20*log10(beamPatternNorm + eps);

    plot(angleVec, beamPattern_dB, ...
        'DisplayName', sprintf('$M=%d$', M));

end

xline(phi0, '--', '$\varphi_0=0^\circ$', 'HandleVisibility', 'off');
yline(-3, '--', '$-3\,\mathrm{dB}$', 'HandleVisibility', 'off');

grid on;
xlabel('$\varphi$ [$^\circ$]');
ylabel('$|y(\varphi)|_{\mathrm{norm}}$ [dB]');
title('Main beam comparison for different array sizes');
legend();
xlim([-30, 30]);
ylim([-60, 1]);

savePng(fig2, 'ex3_beam_patterns_different_M_zoom.png');

%% results table
resultsTable = table( ...
    MVec(:), ...
    beamwidth3dBVec(:), ...
    sidelobeLevelVec(:), ...
    sidelobeLevelDbVec(:), ...
    sidelobeDistanceVec(:), ...
    phiSidelobeVec(:), ...
    'VariableNames', { ...
        'M', ...
        'Beamwidth3dB_deg', ...
        'SidelobeLevel_linear', ...
        'SidelobeLevel_dB', ...
        'SidelobeDistance_deg', ...
        'PhiSidelobe_deg' ...
    });

fprintf('\nResults for task 3:\n');
disp(resultsTable);

writetable(resultsTable, fullfile('plots', 'ex3_results.csv'));
