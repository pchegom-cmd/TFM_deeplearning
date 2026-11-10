function params = myotubes_analysis(BW_clean, BW_skel)
% MYOTUBES_ANALYSIS Morphological features of the myotubes in one image.
%   params = myotubes_analysis(BW_clean, BW_skel) returns a struct with one
%   scalar field per feature. Diameters are in pixels.
%
%   Implemented here: fibre diameters, number of fibres, branching and
%   myotube area. Other features reported in the thesis (fusion index,
%   nuclei clusters, intensity) are not included in this repository.

ptDistance = 300;   % spacing (pixels) between sampled points along each skeleton

L_skel = bwlabel(BW_skel, 8);
params = diameter_measurement(L_skel, BW_clean, ptDistance);

% Number of fibres: connected skeletons.
params.nFibres = max(L_skel(:));

% Branching: branch points of the skeleton, in total and per fibre.
branchPoints = bwmorph(BW_skel, 'branchpoints');
params.totalBranches = nnz(branchPoints);
params.meanBranches = params.totalBranches / max(params.nFibres, 1);

% Share of the image covered by myotubes (%).
params.percMyoArea = 100 * nnz(BW_clean) / numel(BW_clean);
end
