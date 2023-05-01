---
title: Polkadot
category: chain
date: 2023-02-04
---

## Overview

*Note: The majority of this research was done in early 2019 and has been updated recently with some notes on consenus and signing. In 2021 John built and deployed a Parachain called [Eave Network](https://eave.network/) codebase is [here](https://github.com/EaveNetwork). The parachain was deployed to the Rococo Testnet. John self funded this initiative, but failed to raise seed funding, due to this and other priorities this project was never fully developed and deployed on Kusama or Polkadot. Polkadot is one of John's favourite development frameworks and he is extremely grateful for Gavin Wood and Tomasz Drwięga who he was fortunate enough to collaborate with briefly on the Parity Ethereum Client in early 2016 as he began his blockchain journey.*

Polkadot substrate is a chain layer which allows pluggable consensus, definition of storage through the seperation of "extrinsics" and abstracts the runtime design allowing for blockchain providers to decide which runtime best suits there application needs. It also has been built with light client protocol in mind with a number of storage and pruning options giving the ability to clearly seperated different actors requirements for infrastructure (e.g. participants can run a light client on a mobile device and validators can run full nodes with gauranteed performance and uptime). On top of this Polkadot sits as a relay chain (built on Substrate) which allows private chains to share infrastucture such as validators.

## Consensus Mechanism

Following is an excerpt from [Polkadot learn consensus](https://github.com/w3f/polkadot-wiki/blob/master/docs/learn/learn-consensus.md)

> **Nominated Proof of Stake**

> In traditional PoS systems, block production participation is dependent on token holdings as opposed to computational power. While PoS developers usually have a proponent for equitable participation in a decentralized manner, most projects end up proposing some level of centralized operation, where the number of validators with full participation rights is limited. These validators are often seen to be the most wealthy, and, as a result, influence the PoS network as they are the most staked. Usually, the number of candidates to maintain the network with the necessary knowledge (and equipment) is limited; this can directly increase operational costs as well. Systems with a large number of validators tend to form pools to decrease the variance of their revenue and profit from economies of scale. These pools are often off-chain.

> A way to alleviate this is to implement pool formation on-chain and allow token holders to vote with their stake for validators to represent them.

> Polkadot uses NPoS (Nominated Proof-of-Stake) as its mechanism for selecting the validator set. It is designed with the roles of **validators** and **nominators**, to maximize chain security. Actors who are interested in maintaining the network can run a validator node.

> Validators assume the role of producing new blocks in [BABE](#block-production-babe), validating parachain blocks, and guaranteeing finality. Nominators can choose to back select validators with their stake. Nominators can approve candidates that they trust and back them with their tokens.

## References

**Consensus**

* [NPoS](https://wiki.polkadot.network/docs/learn-consensus): Polkadot Nominated Proof of Stake Documentation
* [Polkadot Consensus](https://wiki.polkadot.network/docs/learn-consensus): Polkadot's documentation on consenus.

* [Hybrid Consensus Slide](http://slides.com/paritytech/paritysubstrate#/17)
* [Generalized Consensus Pull Request](https://github.com/paritytech/substrate/pull/883)
* [Consensus Code](https://github.com/paritytech/substrate/tree/master/core/consensus)
* [Rhododendron - Asynchronously safe BFT consensus, implementation in Rust](https://github.com/paritytech/rhododendron)
* [Random Number Generation CSPRNG](https://en.wikipedia.org/wiki/Cryptographically_secure_pseudorandom_number_generator)
  * [Rust-Random](https://github.com/rust-random/rand)
* Block Finality
  * [GRANDPA (GHOST-based Recursive Ancestor Deriving Prefix Agreement)](https://medium.com/polkadot-network/grandpa-block-finality-in-polkadot-an-introduction-part-1-d08a24a021b5)
    * [Finality GANDPA Code](https://github.com/paritytech/finality-grandpa)
    * [Substrate using GRANDPA](https://github.com/paritytech/substrate/blob/master/core/finality-grandpa/src/lib.rs)
    * [Full nodes should store a GRANDPA commit message](https://github.com/paritytech/substrate/issues/1026)
    * [Dynamic Authority sets in GRANDPA](https://github.com/paritytech/substrate/pull/1014)

**Signing**

* [Sr25519 Documentation](https://wiki.polkadot.network/docs/learn-cryptography#what-is-sr25519-and-where-did-it-come-from): Polkadots sr25519 Documentation. *The implementation of Schnorr signatures that is used in Polkadot and implements the Schnorrkel protocols over the Ristretto compression of the Curve25519 is known as sr25519.*
* [Substrate sr25519 codebase](https://github.com/paritytech/substrate/blob/master/primitives/application-crypto/src/sr25519.rs): Polkadot's sr25519 code (rust).
* [ED25519](https://ed25519.cr.yp.to/)

**Staking**

* [Polkadot Staking Documentation](https://wiki.polkadot.network/docs/learn-staking): Documentation on Polkadot including staking validators and Nominiated Pools
* [Staking Polkadot Application](https://staking.polkadot.network/?utm_source=polkadot.network#/validators): Polkadot Staking Application validator view.

**Parachains**

* [Subscan Explorer](https://polkadot.subscan.io/parachain): Block Explorer built for Polkadot and supporting all Parachains
* [parachains](https://wiki.polkadot.network/docs/learn-parachains): Polkadot documentation on Parachains

**Additional**

* Blockchain Explorers
  * [polkadash.io](http://polkadash.io/)
  * [polkascan.io](https://polkascan.io/)
    * [BBQ Birch - Testnet](https://polkascan.io/n-pre/bbqbirch/)
  * [poc-2.plokadot.io](https://poc-2.polkadot.io/#/explorer)
  * [Substrate Explorer](https://polkadot.js.org/apps/next/#/explorer)
  * [Telemetry.polkadot.io](https://telemetry.polkadot.io/#/Krumme%20Lanke)
* Substrate Overview
  * [What is Substrate](https://www.parity.io/what-is-substrate/)
    * Substrate [Video](https://www.youtube.com/watch?v=iUMZyL5kTwc) - [Slides](http://slides.com/paritytech/paritysubstrate#/)
      * [Potential Runtime Designs](http://slides.com/paritytech/paritysubstrate#/29)
    * [Parity Substrate Wiki](https://wiki.parity.io/Parity-Substrate)
  * [What is PolKadot](https://polkadot.network/#whatisit)
    * Polkadot Governance [Video](https://www.youtube.com/watch?v=VsZuDJMmVPY&t=24735s&list=PL6-IF807eaBG5sH-SQXlosqKRM2BZkrqw&index=4) - [Slides](https://slides.com/paritytech/polkadot-governance#/)
    * [Polkadot Whitepaper](https://polkadot.network/PolkaDotPaper.pdf)
    * Polkadot [Video](https://youtu.be/lIghiCmHz0U?list=PLaZFi8ZkzUvKGyWTQ999rbHUXfDQv2LRF) [Slides](https://www.slideshare.net/gavofyork/polkadot-presentation)
    * Substrate : A Rustic Vision of Polkadot by Gavin Wood [Video](https://www.youtube.com/watch?v=0IoUZdDi5Is&feature=youtu.be) - [Slides](https://slides.com/paritytech/substrate_web3summit#/1)
    * [Gavin Wood Podcast on Polkadot, Sharding and Substrate](https://www.zeroknowledge.fm/46)
    * [Polkadot runtime Environment : Alternative Implementation Grant](https://docs.google.com/document/d/1iaIWmfV-uA7Uv1O4yt9G2t_86q18h_r7i5T1t-_EZ-s/edit) - [Github](https://github.com/w3f/Web3-collaboration/issues/12)
  * [Token Economics - DOTS](https://polkadot.network/memorandum)
  * [Secret Store](https://wiki.parity.io/Secret-Store.html) shard key generation
  * [Parity Ethereum IPFS](https://wiki.parity.io/IPFS)
  * [Cosmos vs Polkadot](https://medium.com/@davekaj/blockchain-interoperability-cosmos-vs-polkadot-48097d54d2e2)
  * [Polkadot POC Tutorials](https://medium.com/coinmonks/polkadot-hello-world-3-poc-3-on-substrate-is-here-c45d100f72e3)
  * [Polkadot on Reddit](https://www.reddit.com/r/dot/)
  * [substrate.readme.io](https://substrate.readme.io/) - Substrate Developers Hub
  * [Substrate Workshop - Video](https://www.youtube.com/watch?time_continue=278&v=26ucTSSaqog)
  * [Substrate Web 3 Summit - Slides](http://slides.com/paritytech/substrate_web3summit#/)
  * [Building on Substrate](https://hackmd.io/p_v1M8WGRyy9PggYiKA_Xw#)
  * [Polkadot 2018 Recap](https://medium.com/@gavofyork/polkadot-2018-recap-677dab3e995b)
* Relevant Code Links
  * Key Repositories
    * [ParityTech](https://github.com/paritytech)
      * [Substrate](https://github.com/paritytech/substrate)
        * [Generalize the Consensus Infrastructure](https://github.com/paritytech/substrate/pull/883)
          * [Pluggable Consensus Import Queue](https://github.com/paritytech/substrate/issues/784)
      * [Polkadot](https://github.com/paritytech/polkadot)
      * [WASMI](https://github.com/paritytech/wasmi)
  * [Web Assembly (WASM)](https://webassembly.org/)
    * [GO - support for WASM](https://github.com/golang/go/issues/18892)
    * [GO WAGON](https://github.com/go-interpreter/wagon)
    * [GO Perlin](https://github.com/perlin-network/life)
    * [Rust Parity Tech WASMI](https://github.com/paritytech/wasmi)
* Functional Breakdown
  * Persistence
    * Storage
      * [RocksDB](https://rocksdb.org/)
      * [DB Code](https://github.com/paritytech/substrate/tree/master/core/client/db)
      * Data Overview - Light Client
        * Block Structure [Slide 17](http://slides.com/paritytech/paritysubstrate#/17) to [28](http://slides.com/paritytech/paritysubstrate#/28)
      * [decl_storage - macro](https://wiki.parity.io/decl_storage)
      * [Get and Set Storage](http://slides.com/paritytech/paritysubstrate#/14)
    * Light Client
      * [DB Code](https://github.com/paritytech/substrate/blob/master/core/client/db/src/light.rs)
      * [Light Client Code](https://github.com/paritytech/substrate/tree/master/core/client/src/light)
      * [Protocol Light Client Storage](https://github.com/paritytech/substrate/issues/131)
    * Node
      * [Client Code](https://github.com/paritytech/substrate/tree/master/core/client/src)
  * Gossip
    * [libp2p](https://github.com/ethereum/wiki/wiki/libp2p-Whitepaper)
    * [Substrate Code - network libp2p](https://github.com/paritytech/substrate/tree/master/core/network-libp2p)
    * [Get and Set Storage](http://slides.com/paritytech/paritysubstrate#/14)
    * Message Format
      * [Substrate Primitives](https://github.com/paritytech/substrate/tree/master/core/primitives)
      * [Polkadot Parachain Primitives](https://github.com/paritytech/polkadot/blob/master/primitives/src/parachain.rs)
      * [Polkadot Collator - Logic](https://github.com/paritytech/polkadot/blob/master/collator/src/lib.rs#L17)
  * [Execution](http://slides.com/paritytech/paritysubstrate#/15)
    * [Runtime](https://wiki.parity.io/impl_stubs)
    * [impl-stubs](https://wiki.parity.io/impl_stubs)
    * [SRML](https://github.com/paritytech/substrate/tree/master/srml)
    * [SRML Node Template](https://github.com/paritytech/substrate-node-template)
  * Polkadot - Relay Chain
    * [Whitepaper Overview - Participation in Polkadot](https://polkadot.network/PolkaDotPaper.pdf) - Page 4 gives an overview of the actors
    * [Collator](https://github.com/paritytech/substrate/blob/v0.2/polkadot/collator/src/lib.rs)
      * A collator node lives on a distinct parachain and submits a proposal fora state transition, along with a proof for its validity (what we might call a witness or block data).
    * [Pokadot Parachain](https://github.com/paritytech/substrate/blob/v0.2/polkadot/parachain/src/lib.rs) - Defines primitive types for creating or validating a parachain.
    * [Statement Table](https://github.com/paritytech/substrate/blob/v0.2/polkadot/statement-table/src/lib.rs) - This stores messages other authorities issue about candidates.
    * [Network](https://github.com/paritytech/substrate/tree/v0.2/polkadot/network) - Does the heavy lifting of routing the statements and gaining consensus across the relay chain (and associated parachains)
      * [Consensus](https://github.com/paritytech/substrate/blob/v0.2/polkadot/network/src/consensus.rs) - The "consensus" networking code built on top of the base network service. This fulfills the `polkadot_consensus::Network` trait, providing a hook to be called each time consensus begins on a new chain head.
      * [Consensus Pool](https://github.com/paritytech/substrate/blob/v0.2/polkadot/network/src/collator_pool.rs) - Bridge between the network and consensus service for getting collations to it.
      * [Router](https://github.com/paritytech/substrate/blob/v0.2/polkadot/network/src/router.rs) - Statement routing and consensus table router implementation.
    * [Fisherman (Misbehaviour check)](https://github.com/paritytech/substrate/blob/v0.2/substrate/misbehavior-check/src/lib.rs) - Utility for substrate-based runtimes that want to check misbehavior reports.
  * Hashing
    * [Substrate Code - hashing.rs](https://github.com/paritytech/substrate/blob/master/core/primitives/src/hashing.rs)
    * [Blake2](https://blake2.net/) [use in substrate](https://github.com/paritytech/substrate/search?q=blake2&unscoped_q=blake2)
    * [XXHASH](https://cyan4973.github.io/xxHash/) [use in substrate](https://github.com/paritytech/substrate/search?q=TWOX&unscoped_q=TWOX)
  * Chaincode (See WASM above)
    * [Rust Parity Tech WASMI](https://github.com/paritytech/wasmi)
    * [Use in Substrate Code](https://github.com/paritytech/substrate/search?q=wasmi&unscoped_q=wasmi)
  * Deployment
    * Substrate
      * [Locally on Mac](https://github.com/paritytech/substrate#on-mac)
      * [From Code Base](https://github.com/paritytech/substrate#on-mac)
  * Polkadot Developer Tools
    * API
      * [Polkadot Javascript API](https://polkadot.js.org/api/)
    * RPC
      * [Substrate Code](https://github.com/paritytech/substrate/tree/master/core/rpc)
    * CLI
      * [CLI](https://github.com/paritytech/substrate/tree/master/core/cli)
    * SDK
  * Polkadot Chain Tools
    * Governance
      * [Democracy - Github](https://github.com/paritytech/substrate/blob/master/srml/democracy/src/lib.rs)
  * Substrate Prototyping
    * [Background Material](https://medium.com/coinmonks/polkadot-hello-world-3-poc-3-on-substrate-is-here-c45d100f72e3)
    * Deploying a Substrate Chain
      * [Overview](https://hackmd.io/y-E9Q9jTRreni6z9EU0kkA#)
      * [Locally](https://github.com/paritytech/substrate#on-mac)
      * [From Code Base](https://github.com/paritytech/substrate#on-mac)
      * [Current Issue with BBQ Birch](https://github.com/paritytech/substrate/issues/949) - [cause](https://github.com/paritytech/substrate/pull/900)
  * Deploying Polkadot
    * [Overview](https://github.com/paritytech/polkadot#4-hacking-on-polkadot)
  * Deploying a simple contract
    * [Preparing to build on Polkadot](https://medium.com/polkadot-network/preparing-to-build-on-polkadot-349ff5002885)
    * [Writing a WASM Contract](https://wiki.parity.io/WebAssembly-Home)
  * Running a Transaction
    * [Balance Transfer via API](https://polkadot.js.org/api/examples/promise/07_transfer_dots/)
