---
title: Cosmos
category: chain
date: 2023-02-04
---


## Overview

Cosmos is the hub to almost 50 blockchains based on the Tendermint consensus engine and Inter-Blockchain Communication (IBC) protocol. It is also one of the earliest proponents for cross-chain communication and defined the first set of communication specificiations<sup>[24](#f24)</sup>. From a purely technical point of view, the signature scheme for signing blocks, Ed25519, is also often used in many other protocols, such as NEAR.

Cosmos Hub itself has 175 validators<sup>[25](#f25)</sup> and is built upon Tendermint, in which validators sign blocks using EdDSA on Curve25519 (i.e., Ed25519)<sup>[26](#f26)</sup>.

## Consensus Mechanism

For a deep dive on Tendemints Consensus, please read [The latest gossip on BFT consensus](https://arxiv.org/pdf/1807.04938.pdf): The paper presents Tendermint, a new protocol for ordering events in a distributed network under adversarial conditions.

Following is an excerpt from [What is Tendermint](https://github.com/tendermint/tendermint/blob/main/docs/introduction/what-is-tendermint.md)

> Tendermint is an easy-to-understand, mostly asynchronous, BFT consensus protocol. The protocol follows a simple state machine that looks like this:

![consensus-logic](/assets/research/tendermint_consensus_logic.png)

> Participants in the protocol are called **validators**; they take turns proposing blocks of transactions and voting on them. Blocks are committed in a chain, with one block at each **height**. A block may fail to be committed, in which case the protocol moves to the next **round**, and a new validator gets to propose a block for that height. Two stages of voting are required to successfully commit a block; we call them **pre-vote** and **pre-commit**. A block is committed when more than 2/3 of validators pre-commit for the same block in the same round.

> There is a picture of a couple doing the polka because validators are doing something like a polka dance. When more than two-thirds of the validators pre-vote for the same block, we call that a **polka**. Every pre-commit must be justified by a polka in the same round.

> Validators may fail to commit a block for a number of reasons; the current proposer may be offline, or the network may be slow. Tendermint allows them to establish that a validator should be skipped. Validators wait a small amount of time to receive a complete proposal block from the proposer before voting to move to the next round. This reliance on a timeout is what makes Tendermint a weakly synchronous protocol, rather than an asynchronous one. However, the rest of the protocol is asynchronous, and validators only make progress after hearing from more than two-thirds of the validator set. A simplifying element of Tendermint is that it uses the same mechanism to commit a block as it does to skip to the next round.

> Assuming less than one-third of the validators are Byzantine, Tendermint guarantees that safety will never be violated - that is, validators will never commit conflicting blocks at the same height. To do this it introduces a few **locking** rules which modulate which paths can be followed in the flow diagram. Once a validator precommits a block, it is locked on that block. Then,

> 1. it must prevote for the block it is locked on
> 2. it can only unlock, and precommit for a new block, if there is a polka for that block in a later round

## Signing Mechanism

Below is an excerpt from [Tendermint Specification](https://github.com/tendermint/tendermint/blob/main/spec/core/encoding.md#public-key-cryptography)

> Tendermint uses Protobuf [Oneof](https://protobuf.dev/programming-guides/proto3/#oneof) to distinguish between different types public keys, and signatures. Additionally, for each public key, Tendermint defines an Address function that can be used as a more compact identifier in place of the public key.
>
> ### Key Types
>
> Each type specifies it's own pubkey, address, and signature format.
>
> #### Ed25519
>
>The address is the first 20-bytes of the SHA256 hash of the raw 32-byte public key:
>
> ```go
> address = SHA256(pubkey)[:20]
> ```
>
> The signature is the raw 64-byte ED25519 signature.
>
> Tendermint adopted [zip215](https://zips.z.cash/zip-0215) for verification of ed25519 signatures.
>
> Note: This change will be released in the next major release of Tendermint-Go (0.35).

#### Secp256k1

The address is the first 20-bytes of the SHA256 hash of the raw 32-byte public key:

```go
address = SHA256(pubkey)[:20]
```

Following is an excerpt from [Tendermint docs: Validator Keys](https://docs.tendermint.com/v0.34/tendermint-core/validators.html#)

> Currently Tendermint uses Ed25519 (opens new window)keys which are widely supported across the security sector and HSMs.

## Code Review

### Signing

* [ed25519](https://github.com/tendermint/tendermint/tree/main/crypto/ed25519): Sign produces a signature on the provided message. This assumes the privkey is wellformed in the golang format. The first 32 bytes should be random, corresponding to the normal ed25519 private key. The latter 32 bytes should be the compressed public key. If these conditions aren't met, Sign will panic or produce an incorrect signature.
* [secp256k1](https://github.com/tendermint/tendermint/tree/main/crypto/secp256k1)
* [sr25519](https://github.com/tendermint/tendermint/tree/main/crypto/sr25519)
* [codec.go](https://github.com/tendermint/tendermint/blob/main/crypto/encoding/codec.go): Tranforms protobuf publick key to crypto public keys and vice versa. Support secp256k1 and edd25519.

### Consensus

* [consensus](https://github.com/tendermint/tendermint/tree/main/consensus)
  * [state](https://github.com/tendermint/tendermint/blob/main/consensus/state.go): State handles execution of the consensus algorithm. It processes votes and proposals, and upon reaching agreement, commits blocks to the chain and executes them against the application. The internal state machine receives input from peers, the internal validator, and from a timer.

### Cryptographic Primitives

**general primitives**

* [bits](https://github.com/tendermint/tendermint/tree/main/libs/bits): BitArray is a thread-safe implementation of a bit array.
* [bytes](https://github.com/tendermint/tendermint/tree/main/libs/bytes): Byte functions including marshalling and unmarshalling into JSON as well as fingerprint which returns the first 6 bytes of a byte slice.
* [clist](https://github.com/tendermint/tendermint/tree/main/libs/clist): provide a goroutine-safe linked-list. This list can be traversed concurrently by any number of goroutines. However, removed CElements cannot be added back.
* [cmap](https://github.com/tendermint/tendermint/tree/main/libs/cmap): a goroutine-safe map
* [flowrate](https://github.com/tendermint/tendermint/tree/main/libs/flowrate): provides the tools for monitoring and limiting the flow rate of an arbitrary data stream.
* [json](https://github.com/tendermint/tendermint/tree/main/libs/json): provides functions for marshaling and unmarshaling JSON in a format that is backwards-compatible with Amino JSON encoding. This mostly differs from encoding/json in encoding of integers (64-bit integers are encoded as strings, not numbers), and handling of interfaces (wrapped in an interface object with type/value keys).
* [math](https://github.com/tendermint/tendermint/tree/main/libs/math): math functions including fractions and safemath.
* [pubsub](https://github.com/tendermint/tendermint/tree/main/libs/pubsub): implements a pub-sub model with a single publisher (Server) and multiple subscribers (clients).
* [strings](https://github.com/tendermint/tendermint/tree/main/libs/strings): string manipulation functions.

**hash functions**

* [tmhash](https://github.com/tendermint/tendermint/blob/main/crypto/tmhash/hash.go): Tendermint implementation of SHA256 hash.
* [hash](https://github.com/tendermint/tendermint/blob/main/crypto/hash.go): included in tmhash.

**encryption**

* [armor](https://github.com/tendermint/tendermint/blob/main/crypto/armor/armor.go): implementation of [OpenPGP ASCII Armor](https://www.rfc-editor.org/rfc/rfc4880.html).
* [xchacha20poly1305](https://github.com/tendermint/tendermint/tree/main/crypto/xchacha20poly1305): Tendermint implementation of [ChaCha20-Poly1305](https://en.wikipedia.org/wiki/ChaCha20-Poly1305) an authenticated encryption with additional data (AEAD) algorithm, that combines the ChaCha20 stream cipher with the Poly1305 message authentication code.
* [xsalsa20symmetric](https://github.com/tendermint/tendermint/tree/main/crypto/xsalsa20symmetric): Tendermint implementation of [Salsa20](https://en.wikipedia.org/wiki/Salsa20).

**random number generators**

* [random.go](https://github.com/tendermint/tendermint/blob/main/crypto/random.go): only uses the OS's randomness. CRandHex returns a hex encoded string that's floor(numDigits/2) *2 long.*Note: CRandHex(24) gives 96 bits of randomness that are usually strong enough for most purposes.*
* [rand](https://github.com/tendermint/tendermint/tree/main/libs/rand): prng, that is seeded with OS randomness. The OS randomness is obtained from crypto/rand, however none of the provided methods are suitable for cryptographic usage. They all utilize math/rand's prng internally. All of the methods here are suitable for concurrent use. This is achieved by using a mutex lock on all of the provided methods.

**serilization/deserialization**

## References

**Consensus**

* [Tendermint Byzantine Consensus Algorithm Specification](https://github.com/tendermint/tendermint/blob/main/spec/consensus/consensus.md): Specification for Tendermints Consensus including state machine, background gossip (messaging) and proofs.
* [Tendermint Consensus Overview](https://docs.tendermint.com/v0.34/introduction/what-is-tendermint.html#consensus-overview): Tendermint Consensus Overview Documentation.
* [Proposer Selection Procedure Specification](https://github.com/tendermint/tendermint/blob/main/spec/consensus/proposer-selection.md): Specifies the Proposer Selection Procedure that is used in Tendermint to choose a round proposer for its "leader-based-protocol".

**Signing**

* [Ed25519: high-speed high-security signatures](https://ed25519.cr.yp.to/): Ed25519 Signature Information
  * [High-speed high-security signatures](https://ed25519.cr.yp.to/ed25519-20110926.pdf): Paper introducing Ed25519 signatures
* [Tendermint Validator Keys](https://docs.tendermint.com/v0.34/tendermint-core/validators.html): Tendermint Documentation  highlighting the use of Ed25519 keys for validators.
* [Tendermint Public Key Cryptography](https://github.com/tendermint/tendermint/blob/main/spec/core/encoding.md#public-key-cryptography): Documenation on Tendermints Public Key Cryptography.
* [Tendermint Crypto Code Base](https://github.com/tendermint/tendermint/tree/main/crypto): crypto is the cryptographic package adapted for Tendermint's uses (go)
  * [key.go](https://github.com/tendermint/tendermint/blob/main/p2p/key.go#L50): Tendermint Validator Key Management(go). *LoadOrGenNodeKey attempts to load the NodeKey from the given filePath. If the file does not exist, it generates and saves a new NodeKey.*
  * [ed25519.go](https://github.com/maticnetwork/tendermint/blob/peppermint/crypto/ed25519/ed25519.go): Used for signing messages with an ed25519 private key.

**Light Client**

* [Light Client](https://docs.tendermint.com/v0.34/tendermint-core/light-client.html): he objective of the light client protocol is to get a commit for a recent block hash where the commit includes a majority of signatures from the last known validator set. From there, all the application state is verifiable with [merkle proofs](https://github.com/tendermint/spec/blob/master/spec/core/encoding.md#iavl-tree).
* [tendermint light package](https://pkg.go.dev/github.com/tendermint/tendermint/light)(go): Tendermint light clients allow bandwidth & compute-constrained devices, such as smartphones, low-power embedded chips, or other blockchains to efficiently verify the consensus of a Tendermint blockchain. This forms the basis of safe and efficient state synchronization for new network nodes and inter-blockchain communication (where a light client of one Tendermint instance runs in another chain's state machine). ([tendermint light source code](https://github.com/tendermint/tendermint/tree/main/light)(go)).

**Serialization/DeSerialization**

* [Tendermint has four serialization protocols](https://github.com/tendermint/tendermint/issues/608)

**Staking**

**Additional**

<a name="f24">[24]</a> See [Cosmos IBC documentation](https://tutorials.cosmos.network/academy/3-ibc/1-what-is-ibc.html)

<a name="f25">[25]</a> See [Cosmos Hub overview](https://hub.cosmos.network/main/validators/overview.html)

<a name="f26">[26]</a> See [Tendermint Core documentation](https://docs.tendermint.com/v0.34/tendermint-core/validators.html#validator-keys)
