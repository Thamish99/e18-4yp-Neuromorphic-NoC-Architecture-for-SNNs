#!/usr/bin/env python3
"""
make_mnist_csr_1024.py
----------------------
Create CSR hex (conn_index/conn_targets/conn_weights) for a 1024-neuron SNN layout:
  - IDs 0..783   : input sources (MNIST pixels)
  - IDs 784..1013: hidden layer (230 neurons)
  - IDs 1014..1023: output layer (10 neurons)

This fills connections:
  - Input -> Hidden : each input connects to K_in_hidden distinct hidden targets
  - Hidden -> Output: either full or K_hidden_out fixed fan-out
Weights are float32 hex. Target IDs are 32-bit words (HDL uses low AW bits).

Defaults give a modestly sparse net. Tune to taste or replace with trained weights.
"""
import argparse, random, struct

def fhex32(f):
    import struct
    return struct.pack('>f', float(f)).hex().upper()

def word32(x):
    return f"{(x & 0xFFFFFFFF):08X}"

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('--N', type=int, default=1024, help='Total neurons (fixed mapping assumes 1024).')
    ap.add_argument('--AW', type=int, default=10, help='Address width for neuron IDs (default 10 for N=1024).')
    ap.add_argument('--K-in-hidden', type=int, default=32, help='Fan-out from each input to hidden (default 32).')
    ap.add_argument('--hidden-full', action='store_true', help='Connect every hidden to all 10 outputs.')
    ap.add_argument('--K-hidden-out', type=int, default=10, help='If not full, fan-out from hidden to outputs (default 10).')
    ap.add_argument('--w-in-range', type=str, default="0.05,0.2", help='Weight range for Input->Hidden (lo,hi).')
    ap.add_argument('--w-hid-range', type=str, default="0.1,0.5", help='Weight range for Hidden->Output (lo,hi).')
    ap.add_argument('--seed', type=int, default=7, help='RNG seed.')
    ap.add_argument('--out-prefix', type=str, default="", help='Optional filename prefix.')
    args = ap.parse_args()

    if args.N != 1024:
        print("Warning: script assumes fixed ID map for N=1024. Proceeding anyway.")
    assert args.AW >= 10, "AW should be >= 10 for 1024 IDs"

    IN0, IN1 = 0, 784
    H0, H1   = 784, 1014
    O0, O1   = 1014, 1024

    K_in_hidden = args.K_in_hidden
    K_hidden_out = args.K_hidden_out
    w_in_lo, w_in_hi = [float(x) for x in args.w_in_range.split(",")]
    w_h_lo,  w_h_hi  = [float(x) for x in args.w_hid_range.split(",")]

    rng = random.Random(args.seed)

    index = [0]*(args.N + 1)
    targets = []
    weights = []

    # Build edges by source
    for s in range(args.N):
        index[s] = len(targets)
        if IN0 <= s < IN1:
            # Input -> Hidden
            picks = set()
            while len(picks) < min(K_in_hidden, H1-H0):
                picks.add(rng.randrange(H0, H1))
            for d in sorted(picks):
                targets.append(d)
                w = rng.uniform(w_in_lo, w_in_hi)
                weights.append(w)
        elif H0 <= s < H1:
            # Hidden -> Output
            outs = list(range(O0, O1))
            if args.hidden_full:
                chosen = outs
            else:
                rng.shuffle(outs)
                chosen = outs[:min(K_hidden_out, len(outs))]
                chosen.sort()
            for d in chosen:
                targets.append(d)
                w = rng.uniform(w_h_lo, w_h_hi)
                weights.append(w)
        else:
            # outputs or unused sources: no outgoing edges
            pass
    index[args.N] = len(targets)

    # Write hex files
    idx_name = f"{args.out_prefix}conn_index.hex"
    tgt_name = f"{args.out_prefix}conn_targets.hex"
    w_name   = f"{args.out_prefix}conn_weights.hex"

    with open(idx_name, "w") as f:
        for v in index:
            f.write(word32(v) + "\n")
    with open(tgt_name, "w") as f:
        for d in targets:
            f.write(word32(d) + "\n")  # HDL uses low AW bits
    with open(w_name, "w") as f:
        for w in weights:
            f.write(fhex32(w) + "\n")

    M = len(targets)
    print(f"N={args.N} AW={args.AW} edges={M} avg_out_degree={M/args.N:.2f}")
    print(f"Wrote {idx_name}, {tgt_name}, {w_name}")

if __name__ == "__main__":
    main()
