function d = diameter_measurement(L_skel, BW_clean, ptDistance)
% DIAMETER_MEASUREMENT Fibre diameters sampled at roughly equidistant points.
%   d = diameter_measurement(L_skel, BW_clean, ptDistance)
%   L_skel     : labelled skeleton image (one label per fibre)
%   BW_clean   : logical myotube mask
%   ptDistance : approximate spacing (pixels) between sampled points
%   d          : struct with summary diameter statistics, in pixels
%
%   At each sampled skeleton point, the diameter is twice the distance to the
%   nearest background pixel.

D = bwdist(~BW_clean);              % distance of every pixel to the background
numSkel = max(L_skel(:));
if isempty(numSkel); numSkel = 0; end

mean_diameter = nan(1, numSkel);
max_diameter = nan(1, numSkel);
std_diameter = nan(1, numSkel);
allDiameters = [];

for nSkel = 1:numSkel
    % Coordinates of this fibre's skeleton.
    [y_skel, x_skel] = find(L_skel == nSkel);
    skel_pts = [x_skel, y_skel];

    % Downsample to roughly equidistant points, then snap back onto the skeleton.
    pc = pointCloud([x_skel, y_skel, zeros(size(x_skel))]);
    pc_ds = pcdownsample(pc, 'gridAverage', ptDistance);
    snapped = skel_pts(knnsearch(skel_pts, double(pc_ds.Location(:, 1:2))), :);

    % Diameter = 2 x distance to the edge of the fibre.
    diameters = 2 * D(sub2ind(size(D), snapped(:, 2), snapped(:, 1)));

    allDiameters = [allDiameters; diameters(:)]; %#ok<AGROW>
    mean_diameter(nSkel) = mean(diameters);
    max_diameter(nSkel) = max(diameters);
    std_diameter(nSkel) = std(diameters);
end

d.aveg_meanDiam = mean(mean_diameter, 'omitnan');
d.std_meanDiam = std(mean_diameter, 'omitnan');
d.max_maxDiam = max([max_diameter, NaN]);   % NaN if no fibres were found
d.aveg_maxDiam = mean(max_diameter, 'omitnan');
d.std_maxDiam = std(max_diameter, 'omitnan');
d.aveg_stdDiam = mean(std_diameter, 'omitnan');
d.std_stdDiam = std(std_diameter, 'omitnan');
d.avg_diamWholeCulture = mean(allDiameters);
d.std_diamWholeCulture = std(allDiameters);
end
