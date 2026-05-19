function [sidelobeLevel, sidelobeDistance, phiSidelobe, phiCenter] = getSidelobeLevel(beamPattern, angleVec)
%GETSIDELOBELEVEL Calculates the maximum sidelobe level of a beam pattern.
%
%   [sidelobeLevel, sidelobeDistance] = getSidelobeLevel(beamPattern, angleVec)
%
%   [sidelobeLevel, sidelobeDistance, phiSidelobe, phiCenter] = ...
%       getSidelobeLevel(beamPattern, angleVec)
%
%   Inputs:
%       beamPattern - complex gain vector y(phi)
%       angleVec    - vector of angles corresponding to beamPattern [deg]
%
%   Outputs:
%       sidelobeLevel    - maximum sidelobe level in linear scale
%                          normalized to the main beam maximum
%       sidelobeDistance - angular distance from the main beam center [deg]
%       phiSidelobe      - angle of the maximum sidelobe [deg]
%       phiCenter        - angle of the main beam maximum [deg]

    if nargin < 2
        error('getSidelobeLevel requires beamPattern and angleVec.');
    end

    beamPattern = beamPattern(:).';
    angleVec = angleVec(:).';

    if length(beamPattern) ~= length(angleVec)
        error('beamPattern and angleVec must have the same length.');
    end

    beamAbs = abs(beamPattern);
    maxBeam = max(beamAbs);

    if maxBeam == 0
        sidelobeLevel = NaN;
        sidelobeDistance = NaN;
        phiSidelobe = NaN;
        phiCenter = NaN;
        return;
    end

    beamNorm = beamAbs / maxBeam;

    [~, idxMax] = max(beamNorm);
    phiCenter = angleVec(idxMax);

    n = length(beamNorm);

    %% find first local minimum on the left side of the main beam
    idxLeftNull = 1;
    for k = idxMax-1:-1:2
        if beamNorm(k) <= beamNorm(k-1) && beamNorm(k) <= beamNorm(k+1)
            idxLeftNull = k;
            break;
        end
    end

    %% find first local minimum on the right side of the main beam
    idxRightNull = n;
    for k = idxMax+1:n-1
        if beamNorm(k) <= beamNorm(k-1) && beamNorm(k) <= beamNorm(k+1)
            idxRightNull = k;
            break;
        end
    end

    %% exclude main beam area
    sidelobeMask = true(size(beamNorm));
    sidelobeMask(idxLeftNull:idxRightNull) = false;

    if ~any(sidelobeMask)
        sidelobeLevel = NaN;
        sidelobeDistance = NaN;
        phiSidelobe = NaN;
        return;
    end

    %% prefer local maxima outside the main beam
    localMaxMask = false(size(beamNorm));
    for k = 2:n-1
        if beamNorm(k) >= beamNorm(k-1) && beamNorm(k) >= beamNorm(k+1)
            localMaxMask(k) = true;
        end
    end

    candidateMask = sidelobeMask & localMaxMask;

    %% if no local maximum is found, use the maximum outside the main beam
    if ~any(candidateMask)
        candidateMask = sidelobeMask;
    end

    candidateValues = beamNorm;
    candidateValues(~candidateMask) = -inf;

    [sidelobeLevel, idxSidelobe] = max(candidateValues);

    phiSidelobe = angleVec(idxSidelobe);
    sidelobeDistance = abs(phiSidelobe - phiCenter);
end
