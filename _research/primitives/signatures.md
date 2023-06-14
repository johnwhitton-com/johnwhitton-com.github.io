---
title:  Signature Schemes in Consensus Protocols
category: primitive
date: 2023-02-05
---

## Overview

Both sides of the bridge need to verify what happened on the other side. To do that, the verification logic is often encapsulated inside a light client, manifested as a smart contract on the chain which the verification needs to be executed. The light client needs to follow consensus and signature verification mechanisms based on the signing algorithm and the elliptical curve used on the other side. For example, if chain A has 21 validators signing each block using ECDSA algorithm on secp256k1 curves, then chain A's light client, executed on chain B, must extract the signatures from the block headers presented to the light client, and follow the ECDSA signature verification algorithm to verify the content of the block header indeeds produces the 21 signatures contained in the block header, given the public keys of the 21 validators.

Here, we present a reference table for these signature schemes and how they are used in the consensus protocols of different blockchains. We limit our initial scope to Ethereum, Polygon, Avalanche, BSC, Harmony, Cosmos, and Polkadot only (and their undelying technologies). Note that we are only looking at how signatures are used in consensus, not elsewhere in the blockchain stack, as all these protocols use ECDSA on secp256k1 for accounts in EVM interactions.

| Algorithm | Curve | Protocol | Code | Note |
| --------- | ----- | -------- | ---- | ---------- |
| ECDSA | secp256k1 | Polygon | [lib](https://github.com/maticnetwork/tendermint/tree/peppermint/crypto/secp256k1) | [Modified](https://wiki.polygon.technology/docs/pos/peppermint) Tendermint validator signature scheme  |
| | | BSC | [lib](https://github.com/bnb-chain/bsc/tree/master/crypto/secp256k1) [usage](https://github.com/bnb-chain/bsc/blob/cb9e50bdf62c6b46a71724066d39f9851181a5af/consensus/parlia/parlia.go#L546) | Derived from [Clique](https://eips.ethereum.org/EIPS/eip-225), then [improved](https://github.com/bnb-chain/BEPs/pull/131) |
| BLS | BN254 | Ethereum | [EVM](https://github.com/ethereum/go-ethereum/blob/b946b7a13b749c99979e312c83dce34cac8dd7b1/core/vm/contracts.go#L420)  | Added by [EIP-196](https://eips.ethereum.org/EIPS/eip-196),[197](https://eips.ethereum.org/EIPS/eip-197); Mainly for use in smart contracts, such as zk-snark verification. See [explainer](https://hackmd.io/@liangcc/bls-solidity#BLS-Signatures-in-Solidity) |
|  | BLS12-381 | Ethereum | [prysm](https://github.com/prysmaticlabs/prysm/tree/develop/crypto/bls) [lighthouse](https://github.com/sigp/lighthouse/tree/stable/crypto/bls) |  See [PoS design](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/keys/) and [explainer](https://hackmd.io/@benjaminion/bls12-381) |
|  |   | Harmony | [lib](https://github.com/harmony-one/bls/tree/master/ffi/go/bls) [usage](https://github.com/harmony-one/harmony/tree/main/crypto/bls) | See [design](https://docs.harmony.one/home/developers/harmony-specifics/harmony-stack#signatures-and-cryptography) and [protocol review](https://medium.com/harmony-one/2022-harmony-technical-review-88462efba368) |
| RSA | N/A | Avalanche | [verification](https://github.com/ava-labs/avalanchego/blob/51c5edd85ccc7927443b945b427e64d91ff99f67/vms/proposervm/block/block.go#L119) [generation](https://github.com/ava-labs/avalanchego/blob/51c5edd85ccc7927443b945b427e64d91ff99f67/staking/tls.go#L121) | Uses X.509 certificate which potentially allows many algorithms; Moving towards BLS12-381 and added implementations recently
| EdDSA | Curve25519 | IBC | [lib](https://github.com/tendermint/tendermint/tree/main/crypto/ed25519) [usage](https://github.com/tendermint/tendermint/blob/main/spec/core/encoding.md#public-key-cryptography) | Used by all chains in Cosmos network, including [Cosmos Hub](https://hub.cosmos.network/main/validators/overview.html) |
| Schnorr | Curve25519 | Substrate | [lib](https://github.com/paritytech/substrate/blob/master/primitives/application-crypto/src/sr25519.rs) | See also brief [intro](https://wiki.polkadot.network/docs/learn-cryptography#what-is-sr25519-and-where-did-it-come-from) from Polkadot

## Resources

### Algorithms

#### ECDSA

- [Wikipedia](https://www.wikiwand.com/en/Elliptic_Curve_Digital_Signature_Algorithm)
- Standard: [SEC 2: Recommended Elliptic Curve Domain Parameters](https://www.secg.org/sec2-v2.pdf)

#### BLS

- [Wikipedia](https://en.wikipedia.org/wiki/BLS_digital_signature)
- Paper: [Short Signatures from the Weil Pairing](https://www.iacr.org/archive/asiacrypt2001/22480516.pdf)
- Tutorial: [BLS signatures: better than Schnorr](https://medium.com/cryptoadvance/bls-signatures-better-than-schnorr-5a7fe30ea716)
- Analysis: [Secret Sharing and Threshold Signatures with BLS](https://www.dash.org/blog/secret-sharing-and-threshold-signatures-with-bls/)
- Deep dive: [BLS Signatures in Solidity](https://hackmd.io/@liangcc/bls-solidity)

#### EdDSA

- [Wikipedia](https://en.wikipedia.org/wiki/EdDSA)
- [GoLang](https://pkg.go.dev/golang.org/x/crypto/ed25519)

### Curves

- [Curve database](https://neuromancer.sk/std/)

#### secp256k1

- [Bitcoin Wiki](https://en.bitcoin.it/wiki/Secp256k1)
- Tutorial: [A Bluffer’s Guide to secp256k1](https://medium.com/asecuritysite-when-bob-met-alice/a-bluffers-guide-to-secp256k1-404e423e612)

#### BLS12-381

- Deep dive: [BLS12-381 For The Rest Of Us](https://hackmd.io/@benjaminion/bls12-381)
- Intro: [BLS12-381: New zk-SNARK Elliptic Curve Construction](https://electriccoin.co/blog/new-snark-curve/)
- Paper: [Fast and simple constant-time hashing to the BLS12-381 elliptic curve](https://tches.iacr.org/index.php/TCHES/article/view/8348/7697)
- Benchmark: [BLS: Is it really that slow](https://www.dash.org/blog/bls-is-it-really-that-slow/)
- EIP: [EIP-2537: Precompile for BLS12-381 curve operations](https://eips.ethereum.org/EIPS/eip-2537)
- EVM launch: [Targeting Shanghai upgrade May 2023](https://ethereum-magicians.org/t/eip-2537-bls12-precompile-discussion-thread/4187/16)

#### BN254

- [Definition](https://neuromancer.sk/std/bn/bn254)
- Paper: [Pairing-Friendly Elliptic Curves of Prime Order](https://eprint.iacr.org/2005/133.pdf)
- Deep Dive: [BLS Signatures in Solidity](https://hackmd.io/@liangcc/bls-solidity)
- Speed Optimization: [New software speed records for cryptographic pairings](https://cryptojedi.org/papers/dclxvi-20100714.pdf)

### Usage in ZKP

- [A survey of elliptic curves for proof systems](https://eprint.iacr.org/2022/586.pdf)

<!--Too many links below. Need conslidation and simplify-->

<!--
### Signing Implementations

The [Standard Curve Database](https://neuromancer.sk/std/) is a good starting point for existing signing algorithms. Base implementations such as [golang crypto](https://pkg.go.dev/golang.org/x/crypto) and [rust crypto](https://docs.rs/rust-crypto/latest/crypto/) provide good reference codebases.

* [bcrypt](https://www.usenix.org/legacy/event/usenix99/provos/provos.pdf)
  * [cosmos-sdk bcrypt](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/bcrypt)
* [bip-0039](https://github.com/bitcoin/bips/blob/master/bip-0039.mediawiki)
  * [lighthouse](https://github.com/sigp/lighthouse/tree/stable/crypto/eth2_wallet) (rust)
* [bls](https://en.wikipedia.org/wiki/BLS_digital_signature)
  * [ethereum-prysm](https://github.com/prysmaticlabs/prysm/tree/develop/crypto/bls)
* [bls-12-381](https://hackmd.io/@benjaminion/bls12-381)
  * [ethereum EIP-2537: Precompile for BLS12-381 curve operations](https://eips.ethereum.org/EIPS/eip-2537)
  * [ethereum-go-ethereum](https://github.com/ethereum/go-ethereum/tree/master/crypto/bls12381) (go)
  * [harmony bls](https://github.com/harmony-one/harmony/blob/main/crypto/bls/bls.go) (go): uses [harmony bls repository](https://github.com/harmony-one/bls/blob/master/readme.md)
    * [bls Harmony](https://github.com/harmony-one/bls) forked from [herumi/bls_](https://github.com/herumi/bls_): written in C++, supports Go, Rust, WebAssembly (Node.js)
  * [prysm](https://github.com/prysmaticlabs/prysm/tree/develop/crypto/bls) (go)
  * [lighthouse](https://github.com/sigp/lighthouse/tree/stable/crypto/bls) (rust):  provides a wrapper around several BLS implementations to provide Lighthouse-specific functionality.
  * [lighthouse](https://github.com/sigp/lighthouse/tree/stable/crypto/eth2_key_derivation) (rust): Provides path-based hierarchical BLS key derivation, as specified by [EIP-2333](https://eips.ethereum.org/EIPS/eip-2333).
      * [Aurora Rainbow Bridge Implementation](https://github.com/aurora-is-near/lighthouse/tree/stable/crypto/bls/src/impls): Implementations
          * [blst](https://github.com/aurora-is-near/lighthouse/blob/stable/crypto/bls/src/impls/blst.rs)
          * [fake_crypto](https://github.com/aurora-is-near/lighthouse/blob/stable/crypto/bls/src/impls/fake_crypto.rs)
          * [milagro](https://github.com/aurora-is-near/lighthouse/blob/stable/crypto/bls/src/impls/milagro.rs): support for [Apache Milagro](https://milagro.apache.org/docs/milagro-intro/)
  * [lighthouse](https://github.com/sigp/lighthouse/tree/stable/crypto/eth2_keystore) (rust): Provides a JSON keystore for a BLS keypair, as specified by [EIP-2335](https://eips.ethereum.org/EIPS/eip-2335).
  * [bsc bls12381](https://github.com/bnb-chain/bsc/tree/master/crypto/bls12381) (go)
  * [blst](https://github.com/supranational/blst): blst (pronounced 'blast') is a BLS12-381 signature library focused on performance and security. It is written in C and assembly.
* [bn256](https://cryptojedi.org/papers/dclxvi-20100714.pdf)
  * [ethereum-go-ethereum](https://github.com/ethereum/go-ethereum/tree/master/crypto/bn256) (go)
  * [bsc bn256](https://github.com/bnb-chain/bsc/tree/master/crypto/bn256) (go)
* [ecdsa](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm)
  * [bsc crypto](https://github.com/bnb-chain/bsc/blob/master/crypto/crypto.go#L169) (go): toECDSA creates a private key with the given D value. The strict parameter controls whether the key's length should be enforced at the curve size or it can also accept legacy encodings (0 prefixes).
  * [paritytech ecdsa](https://github.com/paritytech/substrate/blob/master/primitives/application-crypto/src/ecdsa.rs) (rust)
  * [cosmos-sdk ecdsa](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/internal/ecdsa)
* [ed25519](https://ed25519.cr.yp.to/ed25519-20110926.pdf) [golang](https://pkg.go.dev/golang.org/x/crypto/ed25519)
  * [tendermint ed25519](https://github.com/tendermint/tendermint/tree/main/crypto/ed25519) (go): GenPrivKey generates a new ed25519 private key. It uses OS randomness in conjunction with the current global random seed in tendermint/libs/common to generate the private key.
  * [paritytech ed25519](https://github.com/paritytech/substrate/blob/master/primitives/application-crypto/src/ed25519.rs) (rust)
  * [Ed25519](https://en.wikipedia.org/wiki/EdDSA): [Ed25519.sol](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/eth/nearbridge/contracts/Ed25519.sol)
  * [cosmos-sdk ed25519](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/ed25519)
* [secp256k1](https://www.secg.org/sec2-v2.pdf)
  * [ethereum-go-ethereum](https://github.com/ethereum/go-ethereum/tree/master/crypto/secp256k1) (go)
  * [prysm](https://github.com/prysmaticlabs/prysm/tree/develop/crypto/ecdsa) (go)
  * [bsc secp256k1](https://github.com/bnb-chain/bsc/tree/master/crypto/secp256k1)
  * [tendermint secp256k1](https://github.com/tendermint/tendermint/tree/main/crypto/secp256k1) (go): GenPrivKeySecp256k1 hashes the secret with SHA2, and uses that 32 byte output to create the private key.
  * [cosmos-sdk secp256k1](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/secp256k1)
  * [snowbridge secp256k1](https://github.com/Snowfork/snowbridge/tree/main/relayer/crypto/secp256k1)
* [secp256r1](https://www.secg.org/sec2-v2.pdf)
  * [cosmos-sdk secp256r1](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/secp256r1)
* [sr25519](https://wiki.polkadot.network/docs/learn-cryptography#what-is-sr25519-and-where-did-it-come-from): schnorr over ristretto25519
  * [chainsafe go-schnorrkel](https://github.com/ChainSafe/go-schnorrkel) (go): This repo contains the Go implementation of the sr25519 signature algorithm (schnorr over ristretto25519). The existing Rust implementation is here.
  * [paritytech substrate-bip39](https://github.com/paritytech/substrate-bip39) (rust): his is a crate for deriving secret keys for Ristretto compressed Ed25519 (should be compatible with Ed25519 at this time) from BIP39 phrases.
  * [paritytech sr25519](https://github.com/paritytech/substrate/blob/master/primitives/application-crypto/src/sr25519.rs) rust
  * [tendermint sr25519](https://github.com/tendermint/tendermint/tree/main/crypto/sr25519) (go): GenPrivKeyFromSecret hashes the secret with SHA2, and uses that 32 byte output to create the private key.
  * [snowbridge sr25519](https://github.com/Snowfork/snowbridge/tree/main/relayer/crypto/secp256k1)
-->