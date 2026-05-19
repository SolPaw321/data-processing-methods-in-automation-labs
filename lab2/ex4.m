clear; close all; clc;

%% paths
scriptDir = fileparts(mfilename('fullpath'));
if isempty(scriptDir)
    scriptDir = pwd;
end

addpath(fullfile(scriptDir, 'plotSettings'));

% This makes savePng(...) save plots to lab2/plots,
% even if the script is started from another working directory.
oldDir = pwd;
cleanupObj = onCleanup(@() cd(oldDir));
cd(scriptDir);

setPlot();

%% simulation parameters
M = 16;                       % number of array elements
ArrayPattern = 0:M-1;          % uniform linear array

phi0 = 0;                      % object angle [deg]
angleStep = 0.01;              % angle resolution [deg]
angleVec = -90:angleStep:90;   % angle grid [deg]

windowNames = {'Hamming', 'Hanning', 'Blackman', 'Nuttall'};

%% output vectors
beamwidth3dBVec = zeros(length(windowNames), 1);
sidelobeLevelVec = zeros(length(windowNames), 1);
sidelobeLevelDbVec = zeros(length(windowNames), 1);
sidelobeDistanceVec = zeros(length(windowNames), 1);
phiSidelobeVec = zeros(length(windowNames), 1);

%% antenna response for target angle phi0
a0 = a(phi0, ArrayPattern, []);

%% plot all windowed patterns
fig1 = figure();
hold on;

for i = 1:length(windowNames)

    %% select array taper
    windowName = windowNames{i};

    switch windowName
        case 'Hamming'
            ArrayTaper = hamming(M).';

        case 'Hanning'
            ArrayTaper = hanning(M).';

        case 'Blackman'
            ArrayTaper = blackman(M).';

        case 'Nuttall'
            if exist('nuttallwin', 'file') == 2
                ArrayTaper = nuttallwin(M).';
            else
                % Fallback implementation of the 4-term Nuttall window.
                % This is useful if nuttallwin is unavailable.
                n = 0:M-1;
                a0Nut = 0.355768;
                a1Nut = 0.487396;
                a2Nut = 0.144232;
                a3Nut = 0.012604;
                ArrayTaper = a0Nut ...
                    - a1Nut*cos(2*pi*n/(M-1)) ...
                    + a2Nut*cos(4*pi*n/(M-1)) ...
                    - a3Nut*cos(6*pi*n/(M-1));
            end
    end

    % Normalization of taper maximum is not necessary for the normalized
    % beam pattern, but it makes the taper scale explicit.
    ArrayTaper = ArrayTaper / max(abs(ArrayTaper));

    %% beam pattern with taper
    beamPattern = zeros(size(angleVec));

    for k = 1:length(angleVec)
        beamPattern(k) = a(angleVec(k), ArrayPattern, ArrayTaper) * a0';
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
        'DisplayName', windowName);

end

%% finish main plot
xline(phi0, '--', '$\varphi_0=0^\circ$', 'HandleVisibility', 'off');
yline(-3, '--', '$-3\,\mathrm{dB}$', 'HandleVisibility', 'off');

grid on;
xlabel('$\varphi$ [$^\circ$]');
ylabel('$|y(\varphi)|_{\mathrm{norm}}$ [dB]');
title(sprintf('Influence of array taper windows, M = %d', M));
legend();
xlim([min(angleVec), max(angleVec)]);
ylim([-120, 1]);

savePng(fig1, 'ex4_windowed_beam_patterns.png');

%% zoomed plot around the main beam
fig2 = figure();
hold on;

for i = 1:length(windowNames)

    %% select array taper
    windowName = windowNames{i};

    switch windowName
        case 'Hamming'
            ArrayTaper = hamming(M).';

        case 'Hanning'
            ArrayTaper = hanning(M).';

        case 'Blackman'
            ArrayTaper = blackman(M).';

        case 'Nuttall'
            if exist('nuttallwin', 'file') == 2
                ArrayTaper = nuttallwin(M).';
            else
                n = 0:M-1;
                a0Nut = 0.355768;
                a1Nut = 0.487396;
                a2Nut = 0.144232;
                a3Nut = 0.012604;
                ArrayTaper = a0Nut ...
                    - a1Nut*cos(2*pi*n/(M-1)) ...
                    + a2Nut*cos(4*pi*n/(M-1)) ...
                    - a3Nut*cos(6*pi*n/(M-1));
            end
    end

    ArrayTaper = ArrayTaper / max(abs(ArrayTaper));

    %% beam pattern with taper
    beamPattern = zeros(size(angleVec));

    for k = 1:length(angleVec)
        beamPattern(k) = a(angleVec(k), ArrayPattern, ArrayTaper) * a0';
    end

    %% normalization and dB scale
    beamPatternAbs = abs(beamPattern);
    beamPatternNorm = beamPatternAbs / max(beamPatternAbs);
    beamPattern_dB = 20*log10(beamPatternNorm + eps);

    %% plot current pattern
    plot(angleVec, beamPattern_dB, ...
        'DisplayName', windowName);

end

xline(phi0, '--', '$\varphi_0=0^\circ$', 'HandleVisibility', 'off');
yline(-3, '--', '$-3\,\mathrm{dB}$', 'HandleVisibility', 'off');

grid on;
xlabel('$\varphi$ [$^\circ$]');
ylabel('$|y(\varphi)|_{\mathrm{norm}}$ [dB]');
title(sprintf('Main beam comparison for array taper windows, M = %d', M));
legend();
xlim([min(angleVec), max(angleVec)]);
ylim([-80, 1]);

savePng(fig2, 'ex4_windowed_beam_patterns_zoom.png');

%% results table
resultsTable = table( ...
    windowNames(:), ...
    beamwidth3dBVec(:), ...
    sidelobeLevelVec(:), ...
    sidelobeLevelDbVec(:), ...
    sidelobeDistanceVec(:), ...
    phiSidelobeVec(:), ...
    'VariableNames', { ...
        'Window', ...
        'Beamwidth3dB_deg', ...
        'SidelobeLevel_linear', ...
        'SidelobeLevel_dB', ...
        'SidelobeDistance_deg', ...
        'PhiSidelobe_deg' ...
    });

fprintf('\nResults for task 4:\n');
disp(resultsTable);

writetable(resultsTable, fullfile('plots', 'ex4_results.csv'));
