function info = getMainLobeWidth3dB(rAbs, lags, Fs)
    rAbs = rAbs(:);
    lags = lags(:);

    [peakValue, peakIdx] = max(rAbs);
    threshold = peakValue * 10^(-3/20);

    leftIdx = find(rAbs(1:peakIdx) <= threshold, 1, 'last');
    rightRelIdx = find(rAbs(peakIdx:end) <= threshold, 1, 'first');

    if isempty(leftIdx) || isempty(rightRelIdx)
        error('The 3 dB crossings were not found. Use a wider lag range.');
    end

    rightIdx = peakIdx + rightRelIdx - 1;

    leftLagSamples = interpolateCrossing(lags(leftIdx), rAbs(leftIdx), ...
                                         lags(leftIdx + 1), rAbs(leftIdx + 1), ...
                                         threshold);

    rightLagSamples = interpolateCrossing(lags(rightIdx - 1), rAbs(rightIdx - 1), ...
                                          lags(rightIdx), rAbs(rightIdx), ...
                                          threshold);

    widthSamples = rightLagSamples - leftLagSamples;
    widthSeconds = widthSamples / Fs;

    info.peakValue = peakValue;
    info.peakLagSamples = lags(peakIdx);
    info.threshold = threshold;
    info.leftLagSamples = leftLagSamples;
    info.rightLagSamples = rightLagSamples;
    info.widthSamples = widthSamples;
    info.widthSeconds = widthSeconds;
    info.widthMilliseconds = 1e3 * widthSeconds;
end

function xCross = interpolateCrossing(x1, y1, x2, y2, yCross)
    if y2 == y1
        xCross = 0.5 * (x1 + x2);
    else
        xCross = x1 + (yCross - y1) * (x2 - x1) / (y2 - y1);
    end
end
