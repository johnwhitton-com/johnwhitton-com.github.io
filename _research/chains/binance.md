---
title: Binance Smart Chain
category: chain
date: 2023-02-04
---


## Overview

Binanace Smart Chain (BSC) has similar signature schemes to Polygon but with a much smaller set of validators and some degree of random (yet predictable and deterministic) perturbation to the active validator set.

The consensus protocol is based on Parlia<sup>[19](#f19)</sup>, a variation that adds staking, validators, and elections to the proof-of-authority consensus protocol Clique, initially proposed in the Ethereum community. The protocol uses 21 validators for producing and signing blocks, with 19 of them picked from stakers with top voting power and 2 randomly chosen every 200 blocks <sup>[20](#f20)</sup>. Blocks are signed using ECDSA on secp256k1 curves, and block headers can be verified following the standard signature verification process<sup>[21](#f21)</sup>.

## Consensus Mechanism

Following is an excerpt from [Binance Consensus Engine documentation](https://github.com/bnb-chain/bnb-chain.github.io/blob/master/docs/learn/consensus.md)

> Although Proof-of-Work (PoW) has been recognized as a practical mechanism to implement a decentralized network, it is not friendly to the environment and also requires a large size of participants to maintain the security.
>
> Ethereum and some other blockchain networks, such as [MATIC Bor](https://github.com/maticnetwork/bor), [TOMOChain](https://tomochain.com/), [GoChain](https://gochain.io/), [xDAI](https://xdai.io/), do use [Proof-of-Authority(PoA)](https://en.wikipedia.org/wiki/Proof_of_authority) or its variants in different scenarios, including both testnet and mainnet. PoA provides some defense to 51% attack, with improved efficiency and tolerance to certain levels of Byzantine players (malicious or hacked). It serves as an easy choice to pick as the fundamentals.
>
> Meanwhile, the PoA protocol is most criticized for being not as decentralized as PoW, as the validators, i.e. the nodes that take turns to produce blocks, have all the authorities and are prone to corruption and security attacks. Other blockchains, such as EOS and Lisk both, introduce different types of [Delegated Proof of Stake (DPoS)](https://en.bitcoinwiki.org/wiki/DPoS) to allow the token holders to vote and elect the validator set. It increases the decentralization and favors community governance.
>
> BSC here proposes to combine DPoS and PoA for consensus, so that:
>
> 1. Blocks are produced by a limited set of validators
> 2. Validators take turns to produce blocks in a PoA manner, similar to [Ethereum's Clique](https://eips.ethereum.org/EIPS/eip-225) consensus design
> 3. Validator set are elected in and out based on a staking based governance
>
> The consensus protocol of BSC fulfills the following goals:
>
> 1. Short Blocking time, 3 seconds on mainnet.
> 2. It requires limited time to confirm the finality of transactions, around 45s for mainnet.
> 3. There is no inflation of native token: BNB, the block reward is collected from transaction fees, and it will be paid in BNB.
> 4. It is 100% compatible with Ethereum system .
> 5. It allows modern proof-of-stake blockchain network governance.

## Signing Mechanism

BSC uses the same signing mechanism as Ethereum 1.0.

Transactions are signed using recoverable ECDSA signatures. This method utilises the SECP-256k1 curve. (see the [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) Appendix F. Signing Transactions). go-ethereum utilizes the [secp256k1](https://github.com/bnb-chain/bsc/tree/master/crypto/secp256k1) package which wraps the bitcoin secp256k1 C library. Signing is handled by the [signer](https://github.com/bnb-chain/bsc/tree/master/signer) receives a request and produces a signature. Note, the produced signature conforms to the secp256k1 curve R, S and V values, where the V value will be 27 or 28 for legacy reasons, if legacyV==true.

**Signing**

* [Signature Documentation](https://docs.bnbchain.org/docs/beaconchain/learn/signature/): Binance overview of how transactions are signed using ECDSA curve Secp256k1.
* [secp256k1 codebase](https://github.com/ethereum/go-ethereum/tree/master/crypto/secp256k1): Binance secp256k1 crytpographic library (go)
* [secp256k1 Public Key](https://github.com/bnb-chain/bsc/blob/03ff2992ab4674c1df8f568ee9a31596f3503c26/crypto/signature_cgo.go#L32): Binance codebase(go) recovering the uncompressed secp256k1 key that created a given signature.

## Code Review

The Binance Smart chain is cloned from [Ethereum 1.0](./ethereum-1-0.md) and thus the majority of code incuding primitives, signing are similar. The key addtions are

* [Consensus - Parlia](https://github.com/bnb-chain/bsc/tree/master/consensus/parlia)
* [systemcontracts](https://github.com/bnb-chain/bsc/tree/master/core/systemcontracts)
* [Mobile](https://github.com/bnb-chain/bsc/tree/master/mobile): Outdated library.

Some ommissions include the majority of work done for Ethereum 2.0 for example BSC has no [beacon/engine](https://github.com/ethereum/go-ethereum/tree/master/beacon/engine).

## References

**Consensus**

* [Parlia Documentation](https://docs.bnbchain.org/docs/learn/consensus/#parlia): Binance Consensus Engine Parlia Documentation
* [Consenus Engine Codebase](https://github.com/bnb-chain/bsc/blob/master/consensus/consensus.go): Binance algorithm agnostic consensus engine. (go)
* [Parlia Consensus Codebase](https://github.com/bnb-chain/bsc/blob/master/consensus/parlia/parlia.go): Binance Parlia codebase (go)
* [Clique Consensus Codebase](https://github.com/bnb-chain/bsc/blob/master/consensus/clique/clique.go): Clique implements the proof-of-authority consensus engine (go). It is what Parlia was based of.
* [Parlia Consensus Verify Seal](https://github.com/bnb-chain/bsc/blob/master/consensus/parlia/parlia.go#L546): Binance seal verification codebase (go). *verifySeal checks whether the signature contained in the header satisfies the consensus protocol requirements. The method accepts an optional list of parent headers that aren't yet part of the local blockchain to generate the snapshots from. The transition rule is described in the eth1/2 merge spec EIP-3675.*
* [EIP-3675: Upgrade consensus to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675): Specification of the consensus mechanism upgrade on Ethereum Mainnet that introduces Proof-of-Stake.

**Staking**

* [BNB Staking Economics](https://docs.bnbchain.org/docs/stake/Staking/#staking-economics): Binance Staking Documentation
* [BNB Chain Staking](https://www.bnbchain.org/en/staking): Binance Staking App

**Additional**

<a name="f19">[19]</a> See [BSC Consensus Engine documentations](https://docs.bnbchain.org/docs/learn/consensus/#consensus-protocol)

<a name="f20">[20]</a> Following BEP-131, see a [summary](https://www.bnbchain.org/en/blog/bep131-introducing-candidate-validators-bnb-smart-chain/) and [detailed specifications](https://github.com/bnb-chain/BEPs/pull/131). Note that the proportion of randomly selected validators may increase, as proposed in the BEP.

<a name="f21">[21]</a> See [code](https://github.com/bnb-chain/bsc/blob/cb9e50bdf62c6b46a71724066d39f9851181a5af/consensus/parlia/parlia.go#L546) for full procedure and how ecrecover is used for signature verification.

* [State of BNB Chain Q4 2022](https://messari.io/report/state-of-bnb-chain-q4-2022)
