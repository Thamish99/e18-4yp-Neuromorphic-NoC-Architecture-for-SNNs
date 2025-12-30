#!/usr/bin/env python3
"""
mnist_rate_to_masks_noPIL.py
----------------------------
Generate N-bit ext_spikes masks (rate-coded) for MNIST IDX files.
NO PIL REQUIRED.

ID convention:
  Input pixel sources = neuron IDs 0..783

Outputs: stim_masks_XXXX.hex (T lines)

Usage:
  python3 mnist_rate_to_masks_noPIL.py \
      --idx-dir ./mnist_idx --outdir ./stim --T 50 --N 1024 --limit 100
"""

import argparse, os, struct
import numpy as np

def read_idx_images(path_images):
    with open(path_images, 'rb') as f:
        magic, num, rows, cols = struct.unpack('>IIII', f.read(16))
        if magic != 2051:
            raise ValueError(f"Not an IDX3 image file: magic={magic}")
        buf = f.read()
    data = np.frombuffer(buf, dtype=np.uint8).reshape(num, rows, cols)
    return data

def read_idx_labels(path_labels):
    with open(path_labels, 'rb') as f:
        magic, num = struct.unpack('>II', f.read(8))
        if magic != 2049:
            raise ValueError(f"Not an IDX1 label file: magic={magic}")
        buf = f.read()
    labels = np.frombuffer(buf, dtype=np.uint8)
    return labels

def img_to_rate_masks(img01, N=1024, T=50, scale=1.0, seed=1):
    rng = np.random.default_rng(seed)
    x = img01.reshape(-1).astype(np.float32)   # 784
    x = np.clip(x * scale, 0.0, 1.0)

    masks = []
    for t in range(T):
        spikes784 = (rng.random(x.shape) < x).astype(np.uint8)
        word = 0
        for i in range(784):
            if spikes784[i]:
                word |= (1 << i)
        masks.append(f"{word:0{N//4}X}")   # hex for N bits
    return masks

def write_masks_hex(masks, path):
    with open(path, 'w') as f:
        for m in masks:
            f.write(m + "\n")

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--idx-dir', type=str, required=True,
                    help='Directory containing MNIST idx files')
    ap.add_argument('--outdir', type=str, default='stim_out')
    ap.add_argument('--N', type=int, default=1024)
    ap.add_argument('--T', type=int, default=50)
    ap.add_argument('--scale', type=float, default=1.0)
    ap.add_argument('--seed', type=int, default=1)
    ap.add_argument('--limit', type=int, default=10)
    args = ap.parse_args()

    os.makedirs(args.outdir, exist_ok=True)

    # Guess MNIST filenames
    train_imgs = os.path.join(args.idx_dir, "train-images-idx3-ubyte")
    train_lbls = os.path.join(args.idx_dir, "train-labels-idx1-ubyte")

    imgs = read_idx_images(train_imgs)
    labels = read_idx_labels(train_lbls)

    for i in range(min(args.limit, len(imgs))):
        arr01 = imgs[i].astype(np.float32) / 255.0
        masks = img_to_rate_masks(arr01, N=args.N, T=args.T, scale=args.scale, seed=args.seed + i)

        out_hex = os.path.join(args.outdir, f"stim_masks_{i:04d}.hex")
        write_masks_hex(masks, out_hex)

    print("Done. Files written to:", args.outdir)

if __name__ == "__main__":
    main()
