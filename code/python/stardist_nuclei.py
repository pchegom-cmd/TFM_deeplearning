"""3D nuclei segmentation with a pre-trained StarDist model.

Segments every 3D TIFF image in a folder and saves one label mask per image.

Usage:
    python stardist_nuclei.py INPUT_DIR [--output OUTPUT_DIR] [--prob 0.64] [--nms 0.2]
"""
import argparse
from pathlib import Path

import numpy as np
from csbdeep.utils import normalize
from stardist.models import StarDist3D
from tifffile import imread, imwrite


def main():
    parser = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument("input_dir", type=Path, help="Folder with 3D TIFF images")
    parser.add_argument("--output", type=Path, default=None,
                        help="Output folder (default: INPUT_DIR/output_segmented_nuclei)")
    parser.add_argument("--prob", type=float, default=0.64,
                        help="Probability threshold: higher values keep fewer, more certain nuclei")
    parser.add_argument("--nms", type=float, default=0.2,
                        help="Non-maximum suppression threshold: higher values allow more overlap")
    args = parser.parse_args()

    images = sorted(args.input_dir.glob("*.tif*"))
    if not images:
        raise SystemExit(f"No TIFF files found in {args.input_dir}")
    output_dir = args.output or args.input_dir / "output_segmented_nuclei"
    output_dir.mkdir(parents=True, exist_ok=True)

    # '3D_versatile_fluo' is the general StarDist model for 3D fluorescence nuclei.
    model = StarDist3D.from_pretrained("3D_versatile_fluo")

    for path in images:
        print(f"Processing {path.name}")
        img = normalize(imread(path), 1, 99.8, axis=(0, 1, 2))
        labels, _ = model.predict_instances(img, prob_thresh=args.prob, nms_thresh=args.nms)
        imwrite(output_dir / f"{path.stem}_segmented.tif", labels.astype(np.uint32), bigtiff=True)
    print(f"Done: {len(images)} images saved to {output_dir}")


if __name__ == "__main__":
    main()
