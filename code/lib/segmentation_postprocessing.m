function [BW_clean, BW_skel] = segmentation_postprocessing(segmentedImg, rawImg, showFigures)
% SEGMENTATION_POSTPROCESSING Clean a myotube segmentation and skeletonise it.
%   [BW_clean, BW_skel] = segmentation_postprocessing(segmentedImg, rawImg, showFigures)
%   segmentedImg : uint8 probability or binary map predicted by the network
%   rawImg       : raw max-projection image (only used for display)
%   showFigures  : true to display intermediate results (default false)
%   BW_clean     : logical mask of myotubes after filtering
%   BW_skel      : logical skeleton of BW_clean

if nargin < 3
    showFigures = false;
end

lengthMin = 600;    % minimum object length in pixels (~150 um): removes myoblasts and debris
areaHoles = 5000;   % holes smaller than this (pixels) are filled

% Binarise the network output and close small gaps along fibres.
BW = imbinarize(segmentedImg, 'adaptive');
BW_close = imclose(BW, strel('disk', 5, 8));

% Remove objects shorter than lengthMin (Feret diameter).
L_img = bwlabel(BW_close);
props = regionprops(L_img, 'MaxFeretProperties');
tooShort = find([props.MaxFeretDiameter] < lengthMin);
BW_filt = BW_close & ~ismember(L_img, tooShort);

% Fill holes smaller than areaHoles.
BW_clean = ~bwareaopen(~BW_filt, areaHoles);

% Skeletonise to describe fibre length and branching.
BW_skel = bwskel(BW_clean, 'MinBranchLength', lengthMin / 2);
BW_skel = bwmorph(BW_skel, 'spur', 10);

if showFigures
    figure;
    imshow([imadjust(rawImg), segmentedImg; uint8(BW_clean) * 255, uint8(imdilate(BW_skel, strel('disk', 5))) * 255]);
    title('Raw | network output  /  cleaned mask | skeleton');
end
end
