function [beamwidth3dB, phiLeft3dB, phiRight3dB, phiCenter] = get3dbBeamwidth(beamPattern, angleVec)
%   Inputs:
%       beamPattern - complex gain vector y(phi)
%       angleVec    - vector of angles corresponding to beamPattern [deg]
%
%   Outputs:
%       beamwidth3dB - 3 dB beamwidth [deg]
%       phiLeft3dB   - left 3 dB crossing angle [deg]
%       phiRight3dB  - right 3 dB crossing angle [deg]
%       phiCenter    - angle of the main beam maximum [deg]

    if nargin < 2
        error('get3dbBeamwidth requires beamPattern and angleVec.');
    end

    beamPattern = beamPattern(:).';
    angleVec = angleVec(:).';

    if length(beamPattern) ~= length(angleVec)
        error('beamPattern and angleVec must have the same length.');
    end

    beamAbs = abs(beamPattern);
    maxBeam = max(beamAbs);

    if maxBeam == 0
        beamwidth3dB = NaN;
        phiLeft3dB = NaN;
        phiRight3dB = NaN;
        phiCenter = NaN;
        return;
    end

    beamNorm = beamAbs / maxBeam;

    [~, idxMax] = max(beamNorm);
    phiCenter = angleVec(idxMax);

    level3dB = 1 / sqrt(2);

    %% left 3 dB crossing
    idxLeft = idxMax;
    while idxLeft > 1 && beamNorm(idxLeft) >= level3dB
        idxLeft = idxLeft - 1;
    end

    if idxLeft == 1 && beamNorm(idxLeft) >= level3dB
        phiLeft3dB = NaN;
    else
        phiLeft3dB = interpolateLevel( ...
            angleVec(idxLeft), beamNorm(idxLeft), ...
            angleVec(idxLeft + 1), beamNorm(idxLeft + 1), ...
            level3dB);
    end

    %% right 3 dB crossing
    idxRight = idxMax;
    while idxRight < length(beamNorm) && beamNorm(idxRight) >= level3dB
        idxRight = idxRight + 1;
    end

    if idxRight == length(beamNorm) && beamNorm(idxRight) >= level3dB
        phiRight3dB = NaN;
    else
        phiRight3dB = interpolateLevel( ...
            angleVec(idxRight - 1), beamNorm(idxRight - 1), ...
            angleVec(idxRight), beamNorm(idxRight), ...
            level3dB);
    end

    beamwidth3dB = abs(phiRight3dB - phiLeft3dB);
end

function phiCross = interpolateLevel(phi1, y1, phi2, y2, level)
    if y2 == y1
        phiCross = (phi1 + phi2) / 2;
    else
        phiCross = phi1 + (level - y1) * (phi2 - phi1) / (y2 - y1);
    end
end
