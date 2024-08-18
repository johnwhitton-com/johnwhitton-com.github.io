---
title: Celestia
category: dataAvailability
date: 2023-06-19
---

- [Overview](#overview)
- [Functionality](#functionality)
  - [Modular](#modular)
- [Code Review](#code-review)
  - [Celestia Node](#celestia-node)
  - [RollKit](#rollkit)
- [Deployment](#deployment)
- [Cryptographic Primitives](#cryptographic-primitives)
  - [Namespaced Merkle Tree Wrapper](#namespaced-merkle-tree-wrapper)
- [Appendices](#appendices)
- [References](#references)
- [Footnotes](#footnotes)

## Overview

 Celestia[^ov-1] is a modular consensus and data network, built to enable anyone to easily deploy their own blockchain with minimal overhead.

## Functionality

### Modular

## Code Review

### Celestia Node

### RollKit

## Deployment

## Cryptographic Primitives

- [whitepaper](https://arxiv.org/pdf/1809.09044.pdf)
  - 2.2 Merkle Trees and Sparse Merkle Trees
  - 2.3 Erasure Codes and Reed-Solomon Codes
  - 5 Data Availability Proofs
    - 5.1 Strawman 1D Reed-Solomon Availability Scheme
    - 5.2 2D Reed-Solomon Encoded Merkle Tree Construction
    - 5.3 Random Sampling and Network Block Recovery
    - 5.4 Selective Share Disclosure
    - 5.5 Fraud Proofs of Incorrectly Generated Extended Data
- [Celestia App Architecture](https://github.com/celestiaorg/celestia-app/tree/main/docs/architecture)
- [Implementation celestia-app pkg](https://github.com/celestiaorg/celestia-app/tree/main/pkg)

### Namespaced Merkle Tree Wrapper

- [code](https://github.com/celestiaorg/celestia-app/tree/main/pkg/wrapper)

## Appendices

## References

- [Learn Modular](https://celestia.org/learn/)
- [Fraud and Data Availability Proofs](https://arxiv.org/pdf/1809.09044.pdf): Maximising Light Client Security and Scaling Blockchains with Dishonest Majorities
- [Celestia App Specifications](https://celestiaorg.github.io/celestia-app/index.html)
- [Celestia App Architecture](https://github.com/celestiaorg/celestia-app/tree/main/docs/architecture)
- [Rollkit Docs](https://rollkit.dev/docs/intro/)
- [Rollkit Architecture Design Records](https://github.com/rollkit/rollkit/tree/main/docs/lazy-adr)
- [Rollkit Dependency Graph](https://github.com/rollkit/rollkit/blob/main/docs/specification/rollkit-dependency-graph.md)
- [Quantum Gravity Bridge](https://github.com/celestiaorg/quantum-gravity-bridge/tree/master)

## Footnotes

[^ov-1]: [Celestia](https://celestia.org/): the first modular blockchan network.
