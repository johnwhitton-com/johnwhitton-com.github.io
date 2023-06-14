---
title: Polymer Labs
category: bridge
date: 2023-02-24
---

- [Overview](#overview)
- [Approach](#approach)
- [Sample Process Flow](#sample-process-flow)
- [Design Notes](#design-notes)
- [Code Review](#code-review)
  - [Signing Mechanisms](#signing-mechanisms)
  - [Cryptographic Primitives](#cryptographic-primitives)
  - [Proving Mechanisms](#proving-mechanisms)
  - [Relayer Mechanisms](#relayer-mechanisms)
  - [Light Client Functionality](#light-client-functionality)
  - [Token Lockers](#token-lockers)
- [References](#references)
- [Appendices](#appendices)
- [Footnotes](#footnotes)

## Overview

Polymer’s[^ov-1] modular IBC[^ov-2] design allows for chains, like Ethereum[^ov-3], to easily integrate IBC transport and become interoperable across all ecosystems in a decentralized manner.

Our protocol combines a novel consensus engine[^ov-4], zero knowledge technology[^ov-5], and modular IBC[^ov-6] to create the most efficient and scalable IBC routing solution.
Polymer is the first chain dedicated to the routing of IBC packets.

## Approach

## Sample Process Flow

## Design Notes

## Code Review

- [plonky2](https://github.com/mir-protocol/plonky2): a SNARK implementation based on techniques from PLONK and FRI. It has since expanded to include tools such as Starky, a highly performant STARK implementation.
  - [plonky2-solidity-verifier](https://github.com/polymerdao/plonky2-solidity-verifier)
  - [plonky2-circom](https://github.com/polymerdao/plonky2-circom): Plonky2 verifier in Circom
  - [plonky2-ed25519](https://github.com/polymerdao/plonky2-ed25519): SNARK verification circuits of a digital signature scheme Ed25519 implemented with Plonky2.
  - [plonky2-sha256](https://github.com/polymerdao/plonky2-sha256): SNARK circuits of a cryptographic hash function SHA-256 implemented with Plonky2.
  - [plonky2-sha512](https://github.com/polymerdao/plonky2-sha512):  SNARK circuits of a cryptographic hash function SHA-512 implemented with Plonky2.
  - [plonky2-pairing](https://github.com/polymerdao/plonky2-pairing)

### Signing Mechanisms

### Cryptographic Primitives

### Proving Mechanisms

### Relayer Mechanisms

### Light Client Functionality

### Token Lockers

## References

## Appendices

## Footnotes

[^ov-1]: [An Introduction to Polymer Labs, Cosmos, and IBC (Inter-Blockchain Communication)](https://polymerlabs.medium.com/an-introduction-to-polymer-labs-cosmos-and-ibc-inter-blockchain-communication-b9f941ee2cdb): Polymer Chain provides a seamless way to provide cross chain communication by utilizing IBC to connect chains even when they may not support IBC natively.

[^ov-2]: [INTER‑BLOCKCHAIN COMMUNICATION PROTOCOL](https://ibcprotocol.org/): IBC is an interoperability protocol for communicating arbitrary data between arbitrary state machines.

[^ov-3]: [The Multi-hop IBC upgrade will take IBC to Ethereum and beyond](https://polymerlabs.medium.com/the-multi-hop-ibc-upgrade-will-take-ibc-to-ethereum-and-beyond-b4bee43523e): A discussion on some key areas of improvement that Polymer is tackling to upgrade IBC functionality and expand the IBC network across the industry.

[^ov-4]: [zkMint: The First ZK-friendly Tendermint Consensus Engine](https://polymerlabs.medium.com/zkmint-the-first-zk-friendly-tendermint-consensus-engine-116000b9d4f9): Polymer’s solution that optimizes IBC across all major chains.

[^ov-5]: [Developing the Most Truly Decentralized Interoperability Solution : Polymer ZK-IBC](https://polymerlabs.medium.com/developing-the-most-truly-decentralized-interoperability-solution-polymer-zk-ibc-f0287ea84a2b): ZK-IBC allows different blockchain protocols to communicate with each other without trusting third parties. It does this by verifying the blockchain consensus on-chain.

[^ov-6]: [Modular IBC for the Modular World](https://polymerlabs.medium.com/modular-ibc-for-the-modular-world-9fc021f6322e): IBC network topology is changing from a homogenous and densely connected network to a heterogenous and sparsely connected network. Modular IBC adapts the IBC protocol to this dynamic environment.
