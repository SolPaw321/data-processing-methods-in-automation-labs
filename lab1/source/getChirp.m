function out=getChirp(f_low, f_high, duration)
    cfg=getConfig();
    f_delta=f_high-f_low;
    tVec=(1:duration*cfg.Fs)/cfg.Fs;
    out=exp(tVec.*(f_low+0.5*f_delta*tVec/duration)*j*2*pi);
end
