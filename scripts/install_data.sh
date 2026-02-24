#!/usr/bin/env bash
#
# Download and extract the MNIST dataset into ./data/
# Source: https://yann.lecun.com/exdb/mnist/
# Mirror: https://ossci-datasets.s3.amazonaws.com/mnist/
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="${SCRIPT_DIR}/../data"

MIRROR="https://ossci-datasets.s3.amazonaws.com/mnist"

FILES=(
    "train-images-idx3-ubyte.gz"
    "train-labels-idx1-ubyte.gz"
    "t10k-images-idx3-ubyte.gz"
    "t10k-labels-idx1-ubyte.gz"
)

mkdir -p "$DATA_DIR"

echo "Downloading MNIST dataset into ${DATA_DIR}..."
echo

for f in "${FILES[@]}"; do
    if [ -f "${DATA_DIR}/${f%.gz}" ]; then
        echo "  [skip] ${f%.gz} already exists"
        continue
    fi

    echo "  [download] ${f}"
    curl -sS -L -o "${DATA_DIR}/${f}" "${MIRROR}/${f}"

    echo "  [extract]  ${f} -> ${f%.gz}"
    gunzip -f "${DATA_DIR}/${f}"
done

echo
echo "Done. Contents of ${DATA_DIR}:"
ls -lh "$DATA_DIR"
