# Analysis of MAMDC2 Muscle Cultures using Deep Learning

This repository contains the code and scripts developed for the Master's Thesis "Deep Learning-based image analysis of MAMDC2 muscle cultures".
![image](https://github.com/user-attachments/assets/46ad1525-ff81-4575-8b51-99243eb39a73)


## Project Description

This project focuses on the study of a muscular dystrophy variant associated with mutations in the **MAMDC2** protein. The main goal was twofold:

1.  **To develop a robust computational pipeline** based on Deep Learning for the automated segmentation and morphometric analysis of myotube cultures and nuclei from microscopy images.
2.  **To use this pipeline to quantitatively characterize** the cellular phenotype caused by the MAMDC2 alteration, comparing it against wild-type controls.

The analysis revealed that the MAMDC2 mutation does not cause atrophy but rather a **paradoxical phenotype of hypertrophic yet disorganized development** , driven by hyperactive cell fusion.

## Workflow Pipeline

The automated workflow processes confocal microscopy images to extract quantitative metrics. The general process is as follows:

1.  **Image Pre-processing**: Fiji/ImageJ macros are used to prepare the original images (e.g., 8-bit conversion, channel splitting).
2.  **Myotube Segmentation**: A **2D ResU-Net** model, trained using the BiaPy library on manually curated data, is used to obtain myotube masks.
3.  **Nuclei Segmentation**: Pre-trained models such as **StarDist 3D** or **SAM-Cellpose** are employed for the detection and segmentation of all nuclei in the images.
4.  **Post-processing and Feature Extraction**: A MATLAB script refines the segmentations (filtering by size, filling holes) and extracts a comprehensive set of **morphological and organizational features** (e.g., diameter, area, fiber count, fusion index).
5.  **Statistical Analysis and Visualization**: Finally, an R script performs statistical tests (Mann-Whitney U-test) and generates plots to compare the phenotypes.

## 📂 Repository Structure

This section describes the purpose of the key files in this repository:

* `main.m`: **Main MATLAB script**. This orchestrates the post-processing of segmentation masks and the extraction of all quantitative features from both myotubes and nuclei.
* `Features_analysis.Rmd`: **R Markdown script**. Contains the code for the statistical analysis of the data extracted by MATLAB and for generating the plots presented in the thesis.
* `create_initialDataset.ijm`: **ImageJ/Fiji Macro**. This script was used to process the raw images and generate the initial dataset (cropped images and automatic masks) that was later manually curated to train the myotube segmentation model.
* `stardist_nuclei.txt`: A text file likely containing parameters or a list of files to be processed by the StarDist model.
* `*.ijm`, `*.java`: Various ImageJ/Fiji macros and plugins for pre-processing tasks, such as image type conversion (`8Bits_casting.ijm`) or channel splitting (`saveAsTifsPerChannel.ijm`).
* `lib/`:The lib/ directory houses the library of custom functions developed for this project. Following modular programming practices, each script within this folder is responsible for a specific and fundamental task in the image analysis pipeline. This includes routines for post-processing and refining the segmentation masks (`segmentation_postprocessing.m`), calculating key morphological features like fiber diameter (`diameter_measurement.m`), and other high-level analysis functions (`myotubes_analysis.m`). The main project script calls these functions to orchestrate the entire workflow, from the raw segmentation data to the final extraction of results.

## Requirements

To run this pipeline in its entirety, you will need the following software:

* **Fiji** or **ImageJ**: To run the pre-processing macros (`.ijm`).
* **MATLAB (R2022b)**: With the *Image Processing Toolbox* for feature extraction.
* **R (v4.4.2)**: Along with the **Tidyverse** ecosystem (`dplyr`, `ggplot2`) for statistical analysis.
* A **Python** environment with the corresponding Deep Learning libraries for model inference (BiaPy, StarDist, Cellpose).


## Usage
1.  **Pre-processing**: Use the ImageJ macros (`*.ijm`) to prepare your images.
2.  **Segmentation**: Apply your trained models or pre-trained models (StarDist, SAM-Cellpose) to segment myotubes and nuclei.
3.  **Feature Extraction**: Run the `main.m` script in MATLAB, ensuring the paths to the input files (segmentation masks) are correct. This will generate an output file with all the metrics.
4.  **Statistical Analysis**: Open `Features_analysis.Rmd` in RStudio, load the output file from MATLAB, and run the code to replicate the analysis and figures.


