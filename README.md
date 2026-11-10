# Deep learning-based image analysis of MAMDC2 muscle cultures

Code from my MSc thesis (Omics Data Analysis and Systems Biology, University of Seville, 2025), carried out at the Institute of Biomedicine of Seville (IBiS). The project built an image-analysis workflow to segment myotubes and nuclei in confocal images of muscle cell cultures and to compare cultures from donors carrying *MAMDC2* variants with control cultures.

![Workflow overview](https://github.com/user-attachments/assets/46ad1525-ff81-4575-8b51-99243eb39a73)

## Workflow

| Step | Tool | Code |
|---|---|---|
| 1. Channel splitting and max projections of `.lif` files | Fiji/ImageJ | `code/saveAsTifsPerChannel.ijm` |
| 2. Training-set creation (crops and automatic masks, then manual curation) | Fiji/ImageJ | `code/create_initialDataset.ijm`, `code/8Bits_casting.ijm` |
| 3. Myotube segmentation | 2D ResU-Net trained with [BiaPy](https://biapy.readthedocs.io/) | Configuration not included (see below) |
| 4. Nuclei segmentation | Pre-trained StarDist 3D (`3D_versatile_fluo`) | `code/python/stardist_nuclei.py` |
| 5. Mask post-processing and morphometry | MATLAB | `code/main.m`, `code/lib/` |
| 6. Statistics and figures | R Markdown | `code/Features_analysis.Rmd` |

Image channels: desmin (myotubes) and TO-PRO-3 (nuclei).

## What is and is not in this repository

- **Included:** pre-processing macros, the StarDist inference script, the MATLAB post-processing and diameter/branching measurements, and the statistical analysis.
- **Not included:** images, masks, trained model weights and per-image results. The data come from donor-derived cultures and are not public.
- **Partly included:** the thesis also reported the fusion index, nuclear clustering and intensity features. The code for those features is not in this repository, although the R analysis handles them if they are present in the input table.

## How to run

1. **Fiji macros:** open each `.ijm` file in Fiji and run it; it asks for the input folders.
2. **Nuclei segmentation:**
   ```bash
   pip install -r code/python/requirements.txt
   python code/python/stardist_nuclei.py path/to/3D_nuclei_tifs --prob 0.64 --nms 0.2
   ```
3. **Morphometry:** edit the paths at the top of `code/main.m` and run it in MATLAB (Image Processing, Computer Vision, and Statistics and Machine Learning toolboxes). It writes `results/myotube_features.csv`, one row per image.
4. **Statistics:** create `sample_metadata.csv` from `code/sample_metadata_template.csv` (columns `fileName, donor, group, time`, with anonymised donor codes) and knit `code/Features_analysis.Rmd`.

## Statistical design

The experimental unit is the **donor**, not the image: several images come from each donor's culture. The analysis therefore:

- reports image-level medians descriptively, without p-values;
- compares groups using one summary value per donor and time point (Wilcoxon rank-sum test);
- adjusts p-values for the number of features tested (Benjamini-Hochberg);
- plots every image coloured by donor, so the number of independent samples is visible.

## Findings and limitations

Image-level measurements suggested that cultures with *MAMDC2* variants form myotubes that are not atrophic, with differences in size and organisation compared with controls. However, the study included **very few donors** (two in the *MAMDC2* group), so it cannot establish a phenotype or its mechanism: the results are exploratory and need confirmation in more donors.

Other limitations: the myotube model was trained on a small, manually curated dataset from the same experiments, and segmentation accuracy on independent images has not been reported here.

## Revisions after the thesis

This repository was revised in November 2026 to remove hard-coded paths, fix errors in the MATLAB functions (diameters are now twice the distance from the skeleton to the fibre edge), make the morphometry script save its results, and move the statistics from image-level to donor-level comparisons. Numbers produced with this version may therefore differ from those in the thesis.

## Notes

Working notes from the project (in Spanish) are in `docs/working_notes_es.txt`.
