---
title:  Cryptographic Primitives
category: primitive
date: 2023-02-04
---

## Overview

Cryptographic and Mathematic Primitives
  
## Reference Implementations

**general primitives**

* [bloom filter](https://en.wikipedia.org/wiki/Bloom_filter)
  * [geth bloombits](https://github.com/ethereum/go-ethereum/tree/master/core/bloombits) (go): Package bloombits implements bloom filtering on batches of data.

* [int_to_bytes](https://ethereum.github.io/execution-specs/autoapi/ethereum/base_types/index.html)
  * [lighthouse int_to_bytes](https://github.com/sigp/lighthouse/tree/stable/consensus/int_to_bytes) (rust): The Eth 2.0 specification uses `int.to_bytes(2, 'little')`, which throws an error if `int` doesn't fit within 3 bytes. The specification relies upon implicit asserts for some validity conditions, so we ensure the calling function is aware of the error condition as opposed to hiding it with a modulo.
* [leaky bucket](https://en.wikipedia.org/wiki/Leaky_bucket#As_a_meter)
  * [prysm](https://github.com/prysmaticlabs/prysm/blob/develop/container/leaky-bucket/leakybucket.go): leaky bucket as a meter
* linked list
  * [prysm](https://github.com/prysmaticlabs/prysm/tree/develop/container/doubly-linked-list) (go): doubly linked list
* [merkle patrica tries](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/)
  * [geth trie](https://github.com/ethereum/go-ethereum/blob/master/trie/trie.go#L17) (go): Package trie implements Merkle Patricia Tries.
  * [geth database](https://github.com/ethereum/go-ethereum/blob/master/core/state/database.go#L63) (go): Trie is a Ethereum Merkle Patricia trie.
* [merkle trees](https://en.wikipedia.org/wiki/Merkle_tree)
  * [prysm sparse_merkle](https://github.com/prysmaticlabs/prysm/blob/develop/container/trie/sparse_merkle.go) (go): defines utilities for sparse merkle tries for Ethereum consensus.
  * [lighthouse cached_tree_hash](https://github.com/sigp/lighthouse/tree/stable/consensus/cached_tree_hash) (rust): Sparse Merkle tree suitable for tree hashing vectors and lists.
  * [lighthouse tree_hash](https://github.com/sigp/lighthouse/tree/stable/consensus/tree_hash) (rust): Convenience method for `MerkleHasher` which also provides some fast-paths for small trees.`minimum_leaf_count` will only be used if it is greater than or equal to the minimum number of leaves that can be created from `bytes`.
  * [lighthouse tree_hash_derive](https://github.com/sigp/lighthouse/tree/stable/consensus/tree_hash_derive) (rust):
  * [tendermint go](https://github.com/tendermint/tendermint/tree/main/crypto/merkle) (go): Merkle Tree For smaller static data structures that don't require immutable snapshots or mutability; for instance the transactions and validation signatures of a block can be hashed using this simple merkle tree logic.
  * [paritytech binary-merkle-trie](https://github.com/paritytech/substrate/tree/master/utils/binary-merkle-tree) (rust):  implements a simple binary Merkle Tree utilities required for inter-op with Ethereum bridge & Solidity contract.
  * [snowbridge merkle.go](https://github.com/Snowfork/snowbridge/blob/main/relayer/crypto/merkle/merkle.go)
  * [snowbridge merkleization.rs](https://github.com/Snowfork/snowbridge/blob/main/parachain/pallets/ethereum-beacon-client/src/merkleization.rs)
* [merkle_proof](https://github.com/ethereum/consensus-specs/blob/dev/ssz/merkle-proofs.md) [explainer](https://soliditydeveloper.com/merkle-tree)
  * [lighthouse merkle_proof](https://github.com/sigp/lighthouse/tree/stable/consensus/merkle_proof) (rust): efficiently represents a Merkle tree of fixed depth where only the first N indices are populated by non-zero leaves (perfect for the deposit contract tree).
  * [snowbridge simplified_mmr_proof.go](https://github.com/Snowfork/snowbridge/blob/main/relayer/crypto/merkle/simplified_mmr_proof.go)
  * [snowbridge merkle-proof rust](https://github.com/Snowfork/snowbridge/tree/main/parachain/pallets/basic-channel/merkle-proof)
  * [snowbridge MerkleProof.sol](https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/utils/MerkleProof.sol)
  * [npm package eth-proof](https://www.npmjs.com/package/eth-proof)
* [Merkle Mountain Range](https://docs.grin.mw/wiki/chain-state/merkle-mountain-range/)
  * [paritytech merkle-mountain-range](https://github.com/paritytech/substrate/tree/master/primitives/merkle-mountain-range) (rust)
  * [harmony mmr (go)](https://github.com/peekpi/harmony/tree/mmrHardfork/internal/mmr): Adds a merkle mountain range to harmony's core protocol to support light clients  (WIP) [PR4198](https://github.com/harmony-one/harmony/pull/4198/files)
* queues
  * [prysm](https://github.com/prysmaticlabs/prysm/tree/develop/container/queue) (go): priority queue
  * [snowbridge MMRProof.sol](https://github.com/Snowfork/snowbridge/blob/main/core/packages/contracts/contracts/utils/MMRProof.sol)
  * [snowfork merkle-mountain-range](https://github.com/Snowfork/merkle-mountain-range)
* safe-arithmetic
  * [lighthouse safe_arith](https://github.com/sigp/lighthouse/tree/stable/consensus/safe_arith) (rust): Library for safe arithmetic on integers, avoiding overflow and division by zero.
* slice
  * [prysm](https://github.com/prysmaticlabs/prysm/tree/develop/container/slice) (go)
* [tries](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/)
  * [paritytech trie](https://github.com/paritytech/substrate/tree/master/primitives/trie):  Utility functions to interact with Substrate's Base-16 Modified Merkle Patricia tree ("trie").
* [Verifiable Delay Function](https://eprint.iacr.org/2018/623.pdf)
  * [harmony vdf](https://github.com/harmony-one/harmony/tree/main/crypto/vdf) (go): Package vdf is a proof-of-concept implementation of a delay function and the security properties are not guaranteed.
* [Verfiable Random Function](https://en.wikipedia.org/wiki/Verifiable_random_function)
  * [harmony vrf](https://github.com/harmony-one/harmony/tree/main/crypto/vrf) (go): A VRF is a pseudorandom function f_k from a secret key k, such that that knowledge of k not only enables one to evaluate f_k at for any message m, but also to provide an NP-proof that the value f_k(m) is indeed correct without compromising the unpredictability of f_k for any m' != m. [https://ieeexplore.ieee.org/document/814584](https://ieeexplore.ieee.org/document/814584)
  * [paritytech vrf](https://github.com/paritytech/substrate/tree/master/primitives/consensus/vrf): Primitives for VRF-based consensus engines. Schnorrkel-based VRF.
* tree
  * [paritytech fork-tree](https://github.com/paritytech/substrate/tree/master/utils/fork-tree) (rust): Utility library for managing tree-like ordered data with logic for pruning the tree while finalizing nodes.

**Hash functions**

[SHA-2](https://en.wikipedia.org/wiki/SHA-2)

[difference between sha256 and kecakk256](https://www.geeksforgeeks.org/difference-between-sha-256-and-keccak-256/)

* [Argon 2](https://en.wikipedia.org/wiki/Argon2)
  * [Argon2](https://github.com/P-H-C/phc-winner-argon2): eference C implementation of Argon2.
  * [x/crypto Argon2](https://cs.opensource.google/go/x/crypto/+/master:argon2/argon2.go) (go): Package argon2 implements the key derivation function Argon2.
  * [rust-argon2](https://github.com/sru-systems/rust-argon2) (rust): Rust library for hashing passwords using Argon2.
  * [node-argon2](https://www.npmjs.com/package/argon2) (typescript): Bindings to the reference Argon2 implementation.
* [blake](https://en.wikipedia.org/wiki/BLAKE_(hash_function))
  * [blake2](https://www.blake2.net/) hash function
    * [ethereum-go-ethereum](https://github.com/ethereum/go-ethereum/tree/master/crypto/blake2b) (go): Package blake2b implements the BLAKE2b hash algorithm defined by RFC 7693 and the extendable output function (XOF) BLAKE2Xb.
    * [bsc blake2b](https://github.com/bnb-chain/bsc/tree/master/crypto/blake2b) (go): Package blake2b implements the BLAKE2b hash algorithm defined by RFC 7693 and the extendable output function (XOF) BLAKE2Xb.
  * [blake3](https://github.com/BLAKE3-team/BLAKE3)
    * [blake3 rust crate](https://crates.io/crates/blake3) (rust): BLAKE3 is based on an optimized instance of the established hash function BLAKE2 and on the original Bao tree mode.
    * [zeebo blake3](https://github.com/zeebo/blake3) (go) : Pure Go implementation of BLAKE3 with AVX2 and SSE4.1 acceleration.
* [keccak256](https://keccak.team/keccak.html) hash function
  * [prysm](https://github.com/prysmaticlabs/prysm/blob/develop/crypto/hash/hash.go) (go)
  * [lighthouse](https://github.com/sigp/lighthouse/blob/stable/crypto/eth2_hashing/src/lib.rs) (rust): wrapper over two SHA256 crates: `sha2` and `ring`
  * [bsc crypto](https://github.com/bnb-chain/bsc/blob/master/crypto/crypto.go#L91) (go)
  * [harmony hash](https://github.com/harmony-one/harmony/blob/main/crypto/hash/hash.go) (go)
  * [snowbridge keccak](https://github.com/Snowfork/snowbridge/blob/main/relayer/crypto/keccak/keccak.go)
* [sha256](https://pkg.go.dev/crypto/sha256)
  * [tendermint tmhash](https://github.com/tendermint/tendermint/tree/main/crypto/tmhash)

**encryption**

* [ECIES](https://cryptobook.nakov.com/asymmetric-key-ciphers/ecies-public-key-encryption) (go): a hybrid encryption scheme
  * [ethereum-go-ethereum](https://github.com/ethereum/go-ethereum/tree/master/crypto/ecies) (go)
  * [bsc ecies](https://github.com/bnb-chain/bsc/tree/master/crypto/ecies) (go)
* [ascii armored encryption uses ed25519](https://www.rfc-editor.org/rfc/pdfrfc/rfc4880.txt.pdf)
  * [ethereum-go-ethereum](https://github.com/ethereum/go-ethereum/tree/master/crypto/signify) (go)
  * [bsc signify](https://github.com/bnb-chain/bsc/tree/master/crypto/signify) (go)
  * [tenderming armor](https://github.com/tendermint/tendermint/blob/main/crypto/armor/armor.go) (go)
* [ChaCha20-Poly1305](https://en.wikipedia.org/wiki/ChaCha20-Poly1305): an authenticated encryption with additional data (AEAD) algorithm
  * [tendermint xchacha20poly1305](https://github.com/tendermint/tendermint/tree/main/crypto/xchacha20poly1305) (go)
* [XSalsa20](https://libsodium.gitbook.io/doc/advanced/stream_ciphers/xsalsa20) (go): XSalsa20 is a stream cipher based upon Salsa20 but with a much longer nonce: 192 bits instead of 64 bits.
  * [tendermint xsalsa20symmetric](https://github.com/tendermint/tendermint/tree/main/crypto/xsalsa20symmetric) (go): secret must be 32 bytes long. Use something like Sha256(Bcrypt(passphrase)). The ciphertext is (secretbox.Overhead + 24) bytes longer than the plaintext.

**Random number generators**

* [prysm](https://github.com/prysmaticlabs/prysm/blob/develop/crypto/rand/rand.go) (go)

**Serialization/DeSerialization**

* [RECURSIVE-LENGTH PREFIX (RLP) SERIALIZATION](https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/)
  * [ethereum rlp](https://github.com/ethereum/go-ethereum/tree/master/rlp)
  * [harmony rlp](https://github.com/harmony-one/harmony/blob/main/crypto/hash/rlp.go)
* [Simple Serialize](https://ethereum.org/en/developers/docs/data-structures-and-encoding/ssz/)
  * [snowbridge ssz.rs](https://github.com/Snowfork/snowbridge/blob/main/parachain/pallets/ethereum-beacon-client/src/ssz.rs)

* [Merkle Patricia Trie](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/)

**Threading**

* [prysm](https://github.com/prysmaticlabs/prysm/blob/develop/container/thread-safe/map.go): contains generic containers that are protected either by Mutexes or atomics underneath the hood.

**zero knowledge**

* hash functions
  * [Poseidon](https://www.usenix.org/system/files/sec21-grassi.pdf): A New Hash Function for
Zero-Knowledge Proof Systems ([video](https://youtu.be/hUx3WpDV_l0))

## References

* [Bloom Filter Wikipedia](https://en.wikipedia.org/wiki/Bloom_filter): A Bloom filter is a space-efficient probabilistic data structure, conceived by Burton Howard Bloom in 1970, that is used to test whether an element is a member of a set.
* [Bloom Filters Explainer](https://www.jasondavies.com/bloomfilter/): The bloom filter essentially consists of a bit vector of length m, represented by the central column.
* [Bloomfilter Lesson 11 - Blockchain Academy](https://blockchain-academy.hs-mittweida.de/coursesblockchain-introduction-technical-beginner-to-intermediate/lessons/lesson-11-bloomfilter/): Blockchain Introduction Technical – Beginner to Intermediate  Lesson 11 – Bloomfilter.
* [Cuckoo Hashing](https://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.25.4189&rep=rep1&type=pdf): a simple dictionary with worst case constant lookup time, equaling the theoretical performance of the classic dynamic perfect hashing scheme
of Dietzfelbinger et al.
* [Cukoo Hashing Visualization](http://www.lkozma.net/cuckoo_hashing_visualization/): Visualization of Cukoo Hashing  an elegant method for resolving collisions in hash tables.
* [Fast Fourier Transforms](https://vitalik.ca/general/2019/05/12/fft.html): Vitaliks explaniner on Fast Fourier Transforms. Trigger warning: specialized mathematical topic, with
special thanks to Karl Floersch for feedback.
* [Merkle Trees/Merkle Proofs Lesson 10 - Blockchain Academy](https://blockchain-academy.hs-mittweida.de/courses/blockchain-introduction-technical-beginner-to-intermediate/lessons/lesson-10-merkle-trees-merkle-proofs/): Blockchain Introduction Technical – Beginner to Intermediate  Lesson 10 – Merkle Trees/Merkle Proofs.
