---
title: Snowbridge
category: bridge
date: 2023-02-24
---


## Overview

Snowbridge is a general purpose, trustless and decentralized bridge between Polkadot and Ethereum. The goal is to launch as common-good bridge on the proposed BridgeHub parachain.
**Quick Links**

* Bridge Type : Proof Based Validity Proofs
* [Design](https://docs.snowbridge.network/architecture/overview): bridge has a layered architecture, inspired by networking protocols such as TCP/IP. At the lowest level we have channels, which send messages across the bridge. At the highest level, we have apps, which can invoke methods on apps living on foreign chains.
* [Docs](https://docs.snowbridge.network/): Snowbridge documentation
* [Implementation snowfork snowbridge](https://github.com/Snowfork/snowbridge): A trustless bridge between Polkadot and Ethereum.
* FronteEnd: Still Under Development
* [Explorer](https://polkadot.subscan.io/parachain): Can be used to review if a common good parachain is deployed. Bridge messages will be displayed as Cross Chain Messages (XCM) on this [xcm dashboard](https://polkadot.subscan.io/xcm_dashboard).
* [Roadmap](https://gateway.pinata.cloud/ipfs/QmfYGxQvyjVrgm9ajfzCysbuvLXdsRxP5R5HFjWcrj2yYY): The [Snowbridge Funding Proposal](https://polkadot.polkassembly.io/post/1341) includes a link to the [roadmap]((<https://gateway.pinata.cloud/ipfs/QmfYGxQvyjVrgm9ajfzCysbuvLXdsRxP5R5HFjWcrj2yYY>)) which details the milestones and rollout.

## Design Notes

**[light-client verification polkadot](https://docs.snowbridge.network/architecture/verification/polkadot)**

We use Polkadot’s BEEFY gadget to implement an efficient light client that only needs to verify a very small subset of relay chain validator signatures. BEEFY is live on Rococo, and is awaiting deployment on Kusama and Polkadot.
Fundamentally, the BEEFY light client allows the bridge to prove that a specified parachain header was finalized by the relay chain.

**[BEEFY light client](https://github.com/paritytech/parity-bridges-common/blob/master/modules/beefy/src/lib.rs)**

> BEEFY bridge pallet.
>
> This pallet is an on-chain BEEFY light client for Substrate-based chains that are using the following pallets bundle: `pallet-mmr`, `pallet-beefy` and `pallet-beefy-mmr`.
>
> The pallet is able to verify MMR leaf proofs and BEEFY commitments, so it has access to the following data of the bridged chain:
>
> * header hashes
> * changes of BEEFY authorities
> * extra data of MMR leafs
>
> Given the header hash, other pallets are able to verify header-based proofs (e.g. storage proofs, transaction inclusion proofs, etc.).

**[light-client verification ethereum](https://docs.snowbridge.network/architecture/verification/ethereum)**

We have implemented a Proof-of-Stake (PoS) light client for the Beacon chain. This  client deprecates the older PoW light client we developed in 2020.

The beacon client tracks the beacon chain, the new Ethereum chain that will replace Ethereum's Proof-of-Work consensus method around mid-September, called the Merge. The work we have done consists of the following parts:

* Beacon Client pallet
  * Initial chain snapshot (forms part of the Genesis Config)
  * Sync committee updates
  * Finalized beacon header updates
  * Execution header updates
  * Message verification
* Beacon Relayer
  * Sends data from a beacon node to the beacon client

## Code Review

### Signing Mechanisms

* [secp256k1](https://www.secg.org/sec2-v2.pdf)
  * [snowbridge secp256k1](https://github.com/Snowfork/snowbridge/tree/main/relayer/crypto/secp256k1)
* [sr25519](https://wiki.polkadot.network/docs/learn-cryptography#what-is-sr25519-and-where-did-it-come-from): schnorr over ristretto25519
  * [snowbridge sr25519](https://github.com/Snowfork/snowbridge/tree/main/relayer/crypto/secp256k1)

### Cryptographic Primitives

* [keccak256](https://keccak.team/keccak.html) hash function
  * [snowbridge keccak](https://github.com/Snowfork/snowbridge/blob/main/relayer/crypto/keccak/keccak.go)
* [merkle trees](https://en.wikipedia.org/wiki/Merkle_tree)
  * [snowbridge merkle.go](https://github.com/Snowfork/snowbridge/blob/main/relayer/crypto/merkle/merkle.go)
  * [snowbridge merkleization.rs](https://github.com/Snowfork/snowbridge/blob/main/parachain/pallets/ethereum-beacon-client/src/merkleization.rs)
* [merkle_proof](https://github.com/ethereum/consensus-specs/blob/dev/ssz/merkle-proofs.md) [explainer](https://soliditydeveloper.com/merkle-tree)
  * [snowbridge simplified_mmr_proof.go](https://github.com/Snowfork/snowbridge/blob/main/relayer/crypto/merkle/simplified_mmr_proof.go)
  * [snowbridge merkle-proof rust](https://github.com/Snowfork/snowbridge/tree/main/parachain/pallets/basic-channel/merkle-proof)
  * [snowbridge MerkleProof.sol](https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/utils/MerkleProof.sol)
* [Merkle Mountain Range](https://docs.grin.mw/wiki/chain-state/merkle-mountain-range/)
  * [snowbridge MMRProof.sol](https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/utils/MMRProof.sol)
  * [snowfork merkle-mountain-range](https://github.com/Snowfork/merkle-mountain-range)
* [Simple Serialize](https://ethereum.org/en/developers/docs/data-structures-and-encoding/ssz/)
  * [snowbridge ssz.rs](https://github.com/Snowfork/snowbridge/blob/main/parachain/pallets/ethereum-beacon-client/src/ssz.rs)

### Proving Mechanisms

* [Beefy](https://wiki.polkadot.network/docs/learn-consensus#bridging-beefy)
  * [snowbridge BeefyClient.sol](https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/BeefyClient.sol)

* [snowbridge ethereum-beacon-client rust](https://github.com/Snowfork/snowbridge/tree/main/parachain/pallets/ethereum-beacon-client)
* [snowbridge ethereum-light-client rust](https://github.com/Snowfork/snowbridge/tree/main/parachain/pallets/ethereum-light-client)

### Relayer Mechanisms

The [relays folder](https://github.com/Snowfork/snowbridge/tree/main/relayer/relays) has multiple relayers controlled by [execution](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/execution/main.go). All written in go.

* Relaying from Ethereum to Polkadot
  * [beacon](https://github.com/Snowfork/snowbridge/tree/main/relayer/relays/beacon): Responsible for retrieving state from the beacon chain including
    * [synching](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go):
      * [Header](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L47)
      * [CurrentSyncCommittee](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L55)
      * [SyncAggregate](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#LL60C12-L60C12)
    * functions include
      * [GetSyncPeriodsToFetch](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L65)
      * [GetInitialSync](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L83)
      * [GetSyncCommitteePeriodUpdate](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L118)
      * [GetBlockRoots](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L187)
      * [GetFinalizedUpdate](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L252)
      * [HasFinalizedHeaderChanged](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L305)
      * [GetLatestFinalizedHeader](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L326)
      * [getNextBlockRootBySlot](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L379)
      * [GetNextHeaderUpdateBySlotWithAncestryProof](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L425)
      * [GetNextHeaderUpdateBySlot](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L434)
      * [GetHeaderUpdateWithAncestryProof](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L457)
      * [getBlockHeaderAncestryProof](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L495)
      * [GetSyncAggregate](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L520)
      * [GetSyncAggregateForSlot](https://github.com/Snowfork/snowbridge/blob/main/relayer/relays/beacon/header/syncer/syncer.go#L534)
  * [ethereum](https://github.com/Snowfork/snowbridge/tree/main/relayer/relays/ethereum): Responsible for retreiving block headers from the execution chain.
* Relaying from Polkadot to Etherem
  * [parachain](https://github.com/Snowfork/snowbridge/tree/main/relayer/relays/parachain)
  * [beefy](https://github.com/Snowfork/snowbridge/tree/main/relayer/relays/beefy)

### Light Client Functionality

* [Beefy](https://wiki.polkadot.network/docs/learn-consensus#bridging-beefy)
  * [snowbridge BeefyClient.sol](https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/BeefyClient.sol)

* [snowbridge ethereum-beacon-client rust](https://github.com/Snowfork/snowbridge/tree/main/parachain/pallets/ethereum-beacon-client)
* [snowbridge ethereum-light-client rust](https://github.com/Snowfork/snowbridge/tree/main/parachain/pallets/ethereum-light-client)

### Token Lockers

* [snowbridge ERC20Vault.sol](https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/ERC20Vault.sol)

## References

## Appendices
