%% Myotube post-processing and feature extraction
% Reads the myotube segmentations predicted by the ResU-Net (BiaPy), cleans them,
% measures fibre diameters and saves one row of features per image.
%
% Requirements: Image Processing Toolbox, Computer Vision Toolbox (pointCloud,
% pcdownsample) and Statistics and Machine Learning Toolbox (knnsearch).

clear; close all;
addpath(genpath('lib'))

% --- Configuration: edit these paths for your data ---
inferredImagesPath = fullfile('..', 'biapyModel', 'myotubesInference', 'results', 'myotubesInference_1', 'per_image');
rawImagesPath      = fullfile('..', 'raw images', 'tifs', 'rawMyotubesProjection');
outputFile         = fullfile('..', 'results', 'myotube_features.csv');
showFigures        = false;   % true to inspect each segmentation visually

imageFiles = dir(fullfile(inferredImagesPath, '*.tif'));
if isempty(imageFiles)
    error('No .tif files found in %s', inferredImagesPath);
end

results = cell(numel(imageFiles), 1);
for nImg = 1:numel(imageFiles)
    imageName = imageFiles(nImg).name;
    fprintf('Processing %s (%d/%d)\n', imageName, nImg, numel(imageFiles));

    segmentation = uint8(imread(fullfile(inferredImagesPath, imageName)) * 255);
    rawImg = imread(fullfile(rawImagesPath, imageName));

    [BW_clean, BW_skel] = segmentation_postprocessing(segmentation, rawImg, showFigures);
    params = myotubes_analysis(BW_clean, BW_skel);
    params.fileName = string(imageName);
    results{nImg} = struct2table(params);
end

features = vertcat(results{:});
features = movevars(features, 'fileName', 'Before', 1);
if ~isfolder(fileparts(outputFile)); mkdir(fileparts(outputFile)); end
writetable(features, outputFile);
fprintf('Saved %d images to %s\n', height(features), outputFile);
