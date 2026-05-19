function out = a(PhiDeg, ArrayPattern, ArrayTaper)
    if nargin < 3
        ArrayTaper = [];
    end
    if isempty(ArrayTaper)
        out = exp(1i * ArrayPattern * pi * sind(PhiDeg));
        return;
    end
    out = ArrayTaper .* exp(1i * ArrayPattern * pi * sind(PhiDeg));

end