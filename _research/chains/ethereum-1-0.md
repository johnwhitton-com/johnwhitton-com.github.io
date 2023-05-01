---
title: Ethereum 1.0
category: chain
date: 2023-02-04
---


## Overview

## Consensus Mechanism

### Ethereum 1.0 Proof Of Work

> Existing Blockchain technology is working on the core concept of 'Proof Of Work' (POW). A proof-of-work (PoW) is a protocol that is difficult to compute but easy to verify. It can be verified in far less time than it took to compute in first place. The process involves scanning for a value that when hashed, (such as with SHA-256), the hash begins with a number of zero bits. The average work required is exponential in the number of zero bits required and can be verified by executing a single hash. In simple words, Proof of work is an expensive computation done by all miners to compete to find a number that, when added to the block of transactions, causes this block to hash to a code with certain rare properties. Finding such a rare number is hard (based on the cryptographic features of the hash function used in this process), but verifying its validity when it's found is relatively easy. One can take the challenge, the proof string and hash them together and check if the hash begins with a number of zero bits. This requires to apply the hash function just once and verify the output indeed has requisite numbers of 0's in front. If so, then the proof of work is considered valid under the application of that cryptographic hash function. Every block in the participating network should contain such rare number.

![Proof Of Work](/assets/research/pow.png "Proof Of Work")

Block Structure from [go-ethereum](https://github.com/ethereum/go-ethereum/blob/release/1.9/consensus/ethash/consensus.go)

```
// SealHash returns the hash of a block prior to it being sealed.
func (ethash *Ethash) SealHash(header *types.Header) (hash common.Hash) {
 hasher := sha3.NewLegacyKeccak256()

 rlp.Encode(hasher, []interface{}{
  header.ParentHash,
  header.UncleHash,
  header.Coinbase,
  header.Root,
  header.TxHash,
  header.ReceiptHash,
  header.Bloom,
  header.Difficulty,
  header.Number,
  header.GasLimit,
  header.GasUsed,
  header.Time,
  header.Extra,
 })
 hasher.Sum(hash[:0])
 return hash
}
```

## Signing Mechanism

Transactions are signed using recoverable ECDSA signatures. This method utilises the SECP-256k1 curve. (see the [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf) Appendix F. Signing Transactions). go-ethereum utilizes the [secp256k1](https://github.com/ethereum/go-ethereum/tree/master/crypto/secp256k1) package which wraps the bitcoin secp256k1 C library. Signing is handled by the [signer](https://github.com/ethereum/go-ethereum/tree/master/signer) receives a request and produces a signature. Note, the produced signature conforms to the secp256k1 curve R, S and V values, where the V value will be 27 or 28 for legacy reasons, if legacyV==true.

## Code Review

### Signing

* [bls12381](https://github.com/ethereum/go-ethereum/tree/master/crypto/bls12381): BLS12-381 is a pairing-friendly elliptic curve.
* [bn256](https://github.com/ethereum/go-ethereum/tree/master/crypto/bn256): Package bn256 implements the Optimal Ate pairing over a 256-bit Barreto-Naehrig curve. ([insecure](https://moderncrypto.org/mail-archive/curves/2016/000740.html))
* [secp256k1](https://github.com/ethereum/go-ethereum/tree/master/crypto/secp256k1): Package secp256k1 wraps the bitcoin secp256k1 C library.
* [signer](https://github.com/ethereum/go-ethereum/tree/master/signer): sign receives a request and produces a signature. Note, the produced signature conforms to the secp256k1 curve R, S and V values, where the V value will be 27 or 28 for legacy reasons, if legacyV==true.

### Consensus

* [consensus](https://github.com/ethereum/go-ethereum/tree/master/consensus)
  * [algorithm](https://github.com/ethereum/go-ethereum/blob/master/consensus/ethash/algorithm.go): hashimoto aggregates data from the full dataset in order to produce our final value for a particular header hash and nonce.
  * [api](https://github.com/ethereum/go-ethereum/blob/master/consensus/ethash/api.go): API's include GetWork, SubmitWork, SubmitHashRate and GetHashRate.
  * [ethhash](https://github.com/ethereum/go-ethereum/tree/master/consensus): Package ethash implements the ethash proof-of-work consensus engine.
  * [sealer](https://github.com/ethereum/go-ethereum/blob/master/consensus/ethash/sealer.go): Seal implements consensus.Engine, attempting to find a nonce that satisfies the block's difficulty requirements.
* Additional Consensus Engines
  * [beacon](https://github.com/ethereum/go-ethereum/tree/master/consensus/beacon): Beacon is a consensus engine that combines the eth1 consensus and proof-of-stake algorithm. There is a special flag inside to decide whether to use legacy consensus rules or new rules. The transition rule is described in the eth1/2 merge spec[EIP-3675](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-3675.md).  The beacon here is a half-functional consensus engine with partial functions which is only used for necessary consensus checks. The legacy consensus engine can be any engine implements the consensus interface (except the beacon itself).
  * [clique](https://github.com/ethereum/go-ethereum/blob/master/consensus/clique/clique.go): Package clique implements the proof-of-authority consensus engine.

### Cryptographic Primitives

**general primitives**

* [asm](https://github.com/ethereum/go-ethereum/tree/master/core/asm): Package asm provides support for dealing with EVM assembly instructions (e.g., disassembling them).
* [bitutil](https://github.com/ethereum/go-ethereum/tree/master/common/bitutil): Package bitutil implements fast bitwise operations.
* [bloombits](https://github.com/ethereum/go-ethereum/tree/master/core/bloombits): Package bloombits implements bloom filtering on batches of data.
* [forkid](https://github.com/ethereum/go-ethereum/tree/master/core/forkid): Package forkid implements [EIP-2124](https://eips.ethereum.org/EIPS/eip-2124).
* [hexutil](https://github.com/ethereum/go-ethereum/tree/master/common/hexutil): Package hexutil implements hex encoding with 0x prefix. This encoding is used by the Ethereum RPC API to transport binary data in JSON payloads.
* [lru](https://github.com/ethereum/go-ethereum/tree/master/common/lru): Package lru implements generically-typed Least Recently Used(LRU) caches.
* [math](https://github.com/ethereum/go-ethereum/tree/master/common/math): Package math provides integer math utilities.
* [mclock](https://github.com/ethereum/go-ethereum/tree/master/common/mclock): Package mclock is a wrapper for a monotonic clock source
* [prque](https://github.com/ethereum/go-ethereum/tree/master/common/prque):Package prque implements a priority queue data structure supporting arbitrary value types and int64 priorities.
* [trie](https://github.com/ethereum/go-ethereum/tree/master/trie): Package trie implements Merkle Patricia Tries.

**hash functions**

* [blake2b](https://github.com/ethereum/go-ethereum/tree/master/crypto/blake2b) (go): Package blake2b implements the BLAKE2b hash algorithm defined by RFC 7693 and the extendable output function (XOF) BLAKE2Xb.

**encryption**

* [signify](https://github.com/ethereum/go-ethereum/tree/master/crypto/signify): signFile reads the contents of an input file and signs it (in armored format) with the key provided, placing the signature into the output file.[ascii armored encryption](https://www.rfc-editor.org/rfc/pdfrfc/rfc4880.txt.pdf)
* [ecies](https://github.com/ethereum/go-ethereum/tree/master/crypto/ecies): a hybrid encryption scheme

**random number generators**

**serilization/deserialization**

* [RLP](https://github.com/ethereum/go-ethereum/tree/master/rlp): Package rlp implements the RLP serialization format.([doc](https://github.com/ethereum/go-ethereum/blob/master/rlp/doc.go)) The purpose of RLP (Recursive Linear Prefix) is to encode arbitrarily nested arrays of binary data, and RLP is the main encoding method used to serialize objects in Ethereum.
The only purpose of RLP is to encode structure; encoding specific atomic data types (eg.
strings, ints, floats) is left up to higher-order protocols. In Ethereum integers must be
represented in big endian binary form with no leading zeroes (thus making the integer
value zero equivalent to the empty string). RLP values are distinguished by a type tag. The type tag precedes the value in the input stream and defines the size and kind of the bytes that follow.

**threading**

**virtual machine**

* [vm](https://github.com/ethereum/go-ethereum/tree/master/core/vm) : Package vm implements the Ethereum Virtual Machine. The vm package implements one EVM, a byte code VM. The BC (Byte Code) VM loops over a set of bytes and executes them according to the set of rules defined in the Ethereum yellow paper.

**compiler**

* [compiler](https://github.com/ethereum/go-ethereum/tree/master/common/compiler): Package compiler wraps the ABI compilation outputs. ParseCombinedJSON takes the direct output of a solc --combined-output run and parses it into a map of string contract name to Contract structs. The provided source, language and compiler version, and compiler options are all passed through into the Contract structs. The solc output is expected to contain ABI, source mapping, user docs, and dev docs. Returns an error if the JSON is malformed or missing data, or if the JSON embedded within the JSON is malformed.

## References

**Consensus**

* [Proof of Work (POW), Ethereum Org, 2022](https://ethereum.org/en/developers/docs/consensus-mechanisms/pow/): Ethereum Proof of Work Documentation.
* [Proof Of Work (POW), EtherWorld 2017](https://etherworld.co/2017/04/16/proof-of-work-pow/): Etherworld Proof of Work Guide.
* [EIP-1057: ProgPoW, a Programmatic Proof-of-Work](https://eips.ethereum.org/EIPS/eip-1057): ProgPoW is a proof-of-work algorithm designed to close the efficiency gap available to specialized ASICs.

* [consensus go-ethereum: release 1.9 (codebase)](https://github.com/ethereum/go-ethereum/blob/release/1.9/consensus/consensus.go): Engine is an algorithm agnostic consensus engine. (go)
* [ethash.go, go-ethereum release 1.9 (codebase)](https://github.com/ethereum/go-ethereum/blob/release/1.9/consensus/ethash/ethash.go): Package ethash implements the ethash proof-of-work consensus engine. (go)
* [ethash.sol, horizon (codebase)](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/ethash/ethash.sol): Solidity implementation enableing the verification of ethhash (solidity)
* [ethash.rs, parity-ethereum (codebase)](https://github.com/openethereum/parity-ethereum/blob/v2.7.2-stable/ethash/src/lib.rs): EthashManager implementation by parity (rust).
* [progpow.ps, parity-ethereum (codebase)](https://github.com/openethereum/parity-ethereum/blob/v2.7.2-stable/ethash/src/progpow.rs): EthHash implementation by parity for ASICs (rust). *ProgPoW (Programmatic Proof-of-Work) is the Ethereum network's proposed new Application-Specific Integrated Circuit (ASIC) resistant Proof-of-Work mining algorithm.*

**Staking**

**Additional**

* [Ethereum Yellow Paper](https://ethereum.github.io/yellowpaper/paper.pdf):
* [Ethereum EVM illustrated](https://takenobu-hs.github.io/downloads/ethereum_evm_illustrated.pdf): A technical overview of Ethereum including state, accounts, transactions and messages as well as the EVM. [Appendix E](#appendix-e-data-structures) has links to type definitions for blocks, transactions, state etc in geth.
