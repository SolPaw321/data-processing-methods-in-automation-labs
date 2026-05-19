function savePng(fig, pngName)

    outDir = 'plots';

    if ~exist(outDir, 'dir')
        mkdir(outDir);
    end

    [~, name, ext] = fileparts(pngName);

    if isempty(ext)
        ext = '.png';
    end

    filePath = fullfile(outDir, [name ext]);

    exportgraphics(fig, filePath, ...
        'Resolution', 300, ...
        'BackgroundColor', 'white');

end