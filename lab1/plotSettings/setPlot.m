function setPlot()
    fontAxes   = 12;
    fontLabels = 14;
    fontTitle  = 16;
    fontLegend = 12;

    %% background
    set(groot, 'defaultFigureColor', 'w');
    set(groot, 'defaultAxesColor', 'w');

    %% latex
    set(groot, 'defaultTextInterpreter', 'latex');
    set(groot, 'defaultAxesTickLabelInterpreter', 'latex');
    set(groot, 'defaultLegendInterpreter', 'latex');
    set(groot, 'defaultConstantLineInterpreter', 'latex');

    %% fonts
    set(groot, 'defaultAxesFontSize', fontAxes);
    set(groot, 'defaultLegendFontSize', fontLegend);

    set(groot, 'defaultAxesLabelFontSizeMultiplier', fontLabels / fontAxes);
    set(groot, 'defaultAxesTitleFontSizeMultiplier', fontTitle / fontAxes);

    %% colors
    set(groot, 'defaultAxesXColor', 'k');
    set(groot, 'defaultAxesYColor', 'k');
    set(groot, 'defaultTextColor', 'k');
    set(groot, 'defaultLegendTextColor', 'k');
    set(groot, 'defaultLegendColor', 'w');

    %% xline / yline / plot
    set(groot, 'defaultConstantLineColor', 'k');
    set(groot, 'defaultConstantLineLineWidth', 1.1);
    set(groot, 'defaultLineLineWidth', 1.1);
    set(groot, 'defaultConstantLineLabelVerticalAlignment', 'bottom');

    %% legend
    set(groot, 'defaultLegendLocation', 'northeast');

    %% grid
    set(groot, 'defaultAxesGridColor', 'k');
    set(groot, 'defaultAxesMinorGridColor', 'k');

end