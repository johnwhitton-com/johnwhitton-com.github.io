---
title: Harmony
category: chain
date: 2023-02-04
---


## Overview

Despite relatively lower usage than other candidates, Harmony has a mature, battle-tested implementation for fast consensus using BLS-based signature schemes, which has been in production for over 2 years. Additionally, many other chains are also moving towards using BLS for signing blocks in their consensus protocols.

Harmony follows a two-round Fast Byzantine Fault Tolerance consensus derived from PBFT, where BLS signatures (on the BLS12-381 curve) are used to reduce communication costs[^1]. Blocks are produced by validator leaders, a minimal subset of validators, then further broadcasted to all validators and confirmed when more than 2/3 of validators sign the block with their own BLS signatures. The leader then aggregates the signatures into a single one and broadcasts again. The validators may verify the aggregated signature and sign the block again before sending the signed block back to the leader. Finally, the leader (after receiving signatures from 2/3 of the validators) may aggregate the signature for one last time and finalize the block. In the block header, the leader records which validators' signatures are received in each round.

The protocol uses a slot-bidding mechanism to elect a variable number of validators to fill 800-slots, where each validator may occupy multiple slots if their total delegated stake per slot is greater than the effective median[^2].

## Consensus Mechanism

### Harmony Fast Byzantine Fault Tolerance (FBFT)

The following is an excerpt from [Consensus](https://docs.harmony.one/home/general/technology/consensus)
> The consensus algorithm is a key component of any blockchain. It determines the security and performance of a blockchain and is often referred to as the "engine" of a blockchain. Harmony’s consensus algorithm is called Fast Byzantine Fault Tolerance (FBFT), which is an innovative upgrade on the famous PBFT algorithm. FBFT is one order of magnitude faster and more scalable than PBFT because BLS (Boneh–Lynn–Shacham) aggregate signature is used to significantly reduce the communication cost. Specifically, FBFT allows at least 250 validators to reach consensus within 2 seconds.
>
> For every round of consensus in FBFT, one validator serves as the “leader” and there are three phases: the announce phase, the prepare phase and the commit phase. In the announce phase, the leader proposes a new block and broadcasts the block hash to all of the validators. In the prepare phase, validators verify the message and sign on the block hash, as well as sending the signature back to the leader. The prepare phase finishes when signatures with more than 2/3 of the voting power are collected. After that, the leader aggregated the collected signatures into a O(1)-sized BLS aggregate signature and then broadcast it with the whole block to start the commit phase. The commit phase involves validators verifying the block and doing a similar signing process as the prepare phase (i.e. 2/3 voting power collection). The consensus is reached after the commit phase is done. This whole process can be done within 2 seconds in mainnet.

The following is an excerpt from [Epoch Transition](https://docs.harmony.one/home/network/validators/definitions/epoch-transition)
> An epoch is a period of time when the beacon shard (i.e. shard 0, the coordinator for other shards) produces a fixed number of blocks. In Harmony mainnet, an epoch is 32768 blocks (~18.2h with a 2s block time) in the beacon shard

*Note: If the leader fails to produce a block within a certain time frame, then a new leader is elected*

![Harmony FBFT](/assets//research/harmony-consensus.png "Harmony FBFT")

Block Structure from [harmony](https://github.com/harmony-one/harmony/blob/main/block/v3/header.go)

```
type headerFields struct {
 ParentHash          common.Hash    `json:"parentHash"       gencodec:"required"`
 Coinbase            common.Address `json:"miner"            gencodec:"required"`
 Root                common.Hash    `json:"stateRoot"        gencodec:"required"`
 TxHash              common.Hash    `json:"transactionsRoot" gencodec:"required"`
 ReceiptHash         common.Hash    `json:"receiptsRoot"     gencodec:"required"`
 OutgoingReceiptHash common.Hash    `json:"outgoingReceiptsRoot"     gencodec:"required"`
 IncomingReceiptHash common.Hash    `json:"incomingReceiptsRoot" gencodec:"required"`
 Bloom               ethtypes.Bloom `json:"logsBloom"        gencodec:"required"`
 Number              *big.Int       `json:"number"           gencodec:"required"`
 GasLimit            uint64         `json:"gasLimit"         gencodec:"required"`
 GasUsed             uint64         `json:"gasUsed"          gencodec:"required"`
 Time                *big.Int       `json:"timestamp"        gencodec:"required"`
 Extra               []byte         `json:"extraData"        gencodec:"required"`
 MixDigest           common.Hash    `json:"mixHash"          gencodec:"required"`
 // Additional Fields
 ViewID              *big.Int `json:"viewID"           gencodec:"required"`
 Epoch               *big.Int `json:"epoch"            gencodec:"required"`
 ShardID             uint32   `json:"shardID"          gencodec:"required"`
 LastCommitSignature [96]byte `json:"lastCommitSignature"  gencodec:"required"`
 LastCommitBitmap    []byte   `json:"lastCommitBitmap"     gencodec:"required"` // Contains which validator signed
 Vrf                 []byte   `json:"vrf"`
 Vdf                 []byte   `json:"vdf"`
 ShardState          []byte   `json:"shardState"`
 CrossLinks          []byte   `json:"crossLink"`
 Slashes             []byte   `json:"slashes"`
}
```

## Signing Mechanism

Harmony uses BLS12_381 signatures for validators signing blocks. They began work on enhancing the [herumi/bls package](https://github.com/herumi/bls) in Jan 2019 to [support BLS12_381](https://github.com/harmony-one/bls/commit/302fc1eea9d59cecb1a464280944f5b152d7e781). They have added [bls](https://github.com/harmony-one/harmony/blob/main/crypto/bls/bls.go) and [mutibls](https://github.com/harmony-one/harmony/blob/main/multibls/multibls.go) to the [harmony codbase](https://github.com/harmony-one/harmony) leveraging their [harmony-one bls package](https://github.com/harmony-one/bls).

## Light Client Support

Harmony is actively looking at light client support[^3].

Some initial work has been done for the support of [Merkle Mountain Ranges](https://github.com/opentimestamps/opentimestamps-server/blob/master/doc/merkle-mountain-range.md) has been proposed by Harmony in the pull request [[WIP] MMR-HardFork: add go-merklemountainrange and modified merkle proof logic #3872](https://github.com/harmony-one/harmony/pull/3872).

This introduces a new field into the block header populated by [mmr.go](https://github.com/gupadhyaya/harmony/blob/mmr-hard-fork/internal/mmr/mmr.go) which credits [zmitton/go-merklemountainrange](https://github.com/zmitton/go-merklemountainrange).

Updated [Interface.go](https://github.com/gupadhyaya/harmony/blob/mmr-hard-fork/block/interface/header.go)

```
// MMRRoot is the root of the Merkle Mountain Range tree formed
// using the block hashes of the current epoch
MMRRoot() []byte

// SetMMRRoot sets the updated MMR root after appending the parentHash
SetMMRRoot(newMMRRoot []byte)
```

Updated [header.go](https://github.com/gupadhyaya/harmony/blob/mmr-hard-fork/block/v4/header.go)

```
// MMRRoot is the root of the Merkle Mountain Range tree formed
// using the block hashes of the current epoch
func (h *Header) MMRRoot() []byte {
 return append(h.fields.MMRRoot[:0:0], h.fields.MMRRoot...)
}

// SetMMRRoot sets the updated MMR root after appending the parentHash
func (h *Header) SetMMRRoot(newMMRRoot []byte) {
 h.fields.MMRRoot = append(newMMRRoot[:0:0], newMMRRoot...)
}
```

Harmony [MMR PR Review](https://github.com/harmony-one/harmony/pull/3872) and [latest PR](https://github.com/harmony-one/harmony/pull/4198/files) uses Merkle Mountain Ranges to facilitate light client development against Harmony's sharded Proof of Stake Chain.

**Key Core Protocol Changes Include**
Block Structure from [harmony](https://github.com/peekpi/harmony/blob/mmrHardfork/block/v4/header.go) with [Merkle Mountain Range](https://docs.grin.mw/wiki/chain-state/merkle-mountain-range/) support [Mmr hardfork](https://github.com/harmony-one/harmony/pull/3872) [PR 4198](https://github.com/harmony-one/harmony/pull/4198) introduces `MMRoot`

GOAL: Allow verification that previous blocks were valid based on the MMRRoot Passed.

Features

* add receipt proof
* adding MMRRoot field to block header & cross-chain epoch
* add memdb and filedb mmr processing logic
* add GetProof rpc
* relayer rpcs for fetching full header
* adding block signers for rpc response, debug-only
* minor testing bls
* fix merge conflicts
* github.com/zmitton/go-merklemountainrange dependency
* minor fix
* moving mmr root compute/update logic to after the shard state is computed
* fix getting siblings bug
* adding index to mmr-proof and GetProof with respect to a block number
* check if mmr directory exists, if not create it first
* fixing failing test
* fixing config build test failure
* fixing more test failures
* cleanup
* turn of signers
* fix header copy issue and write mmr root directly to node.worker header
* fix nil pointer problems, shard state fetch issue, and refIndex bug
* clean up

```
type headerFields struct {
 ParentHash          common.Hash    `json:"parentHash"       gencodec:"required"`
 Coinbase            common.Address `json:"miner"            gencodec:"required"`
 Root                common.Hash    `json:"stateRoot"        gencodec:"required"`
 TxHash              common.Hash    `json:"transactionsRoot" gencodec:"required"`
 ReceiptHash         common.Hash    `json:"receiptsRoot"     gencodec:"required"`
 OutgoingReceiptHash common.Hash    `json:"outgoingReceiptsRoot"     gencodec:"required"`
 IncomingReceiptHash common.Hash    `json:"incomingReceiptsRoot" gencodec:"required"`
 Bloom               ethtypes.Bloom `json:"logsBloom"        gencodec:"required"`
 Number              *big.Int       `json:"number"           gencodec:"required"`
 GasLimit            uint64         `json:"gasLimit"         gencodec:"required"`
 GasUsed             uint64         `json:"gasUsed"          gencodec:"required"`
 Time                *big.Int       `json:"timestamp"        gencodec:"required"`
 Extra               []byte         `json:"extraData"        gencodec:"required"`
 MixDigest           common.Hash    `json:"mixHash"          gencodec:"required"`
 // Additional Fields
 ViewID              *big.Int    `json:"viewID"           gencodec:"required"`
 Epoch               *big.Int    `json:"epoch"            gencodec:"required"`
 ShardID             uint32      `json:"shardID"          gencodec:"required"`
 LastCommitSignature [96]byte    `json:"lastCommitSignature"  gencodec:"required"`
 LastCommitBitmap    []byte      `json:"lastCommitBitmap"     gencodec:"required"` // Contains which validator signed
 Vrf                 []byte      `json:"vrf"`
 Vdf                 []byte      `json:"vdf"`
 ShardState          []byte      `json:"shardState"`
 CrossLinks          []byte      `json:"crossLink"`
 Slashes             []byte      `json:"slashes"`
 MMRRoot             common.Hash `json:"mmrRoot"`
}
```

**Sample Light Client Implementation: Horizon Bridge Harmony Light Client Deployed on Ethereum**

This enables the validation of previous blocks by implemented by [TokenLockerOnEthereum.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/TokenLockerOnEthereum.sol) to use  [MMRVerifier.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/MMRVerifier.sol) uses `./lib/MMRVerifier.sol` to validate the [Mountain Merkle Ranges](https://github.com/opentimestamps/opentimestamps-server/blob/master/doc/merkle-mountain-range.md)

## Code Review

The [Harmony codebase](https://github.com/harmony-one/harmony) was originally cloned from [Ethereum 1.0](./ethereum-1-0.md) around 2019.Thus the majority of code incuding primitives, signing are similar as at that period. Since then Ethreum has worked siginficantly on Ethreum 2.0 and these modifications were selectively leveraged by Harmony.

[Harmony has significant differences](https://medium.com/harmony-one/2022-harmony-technical-review-88462efba368) from Ethereum 1.0 including sharding, Effective Proof of Stake Consensus Mechanism, [Rosetta support](https://www.rosetta-api.org/docs/welcome.html) and verifiable delay functions and verifiaable random functions.

### Signing

* [bls](https://github.com/harmony-one/harmony/blob/main/crypto/bls/bls.go): An implementation of BLS threshold signature
* [multibls](https://github.com/harmony-one/harmony/blob/main/multibls/multibls.go): Wrapper for a collection of bls private and public keys with dedup functionality and the ability to serialize to a hex string.

### Consensus

* [consensus](https://github.com/harmony-one/harmony/tree/main/consensus): Consensus package includes the Harmony BFT consensus protocol code, which uses BLS-based multi-signature to cosign the new block. (details are [here](https://talk.harmony.one/t/bls-based-practical-bft-consensus/131)).
* [hmy](https://github.com/harmony-one/harmony/tree/main/hmy): implements the Harmony full node service.

### Sharding

* [shard](https://github.com/harmony-one/harmony/tree/main/shard): Trackes the shard state and committee assignment.

### Staking

* [staking](https://github.com/harmony-one/harmony/tree/main/staking): Implements staking for [Harmony's Effective Proof of Stake](https://blog.harmony.one/introducing-harmonys-effective-proof-of-stake-epos/)
  * [apr](https://github.com/harmony-one/harmony/tree/main/staking/apr): Calculates the expected rewards per year and the rewards for Validators.
  * [availablity](https://github.com/harmony-one/harmony/tree/main/staking/availability): Measures the availability of validators.
  * [effective](https://github.com/harmony-one/harmony/tree/main/staking/effective): Calcualates a validators effective proof of stake.
  * [newtwork](https://github.com/harmony-one/harmony/tree/main/staking/network): Calculates the network rewards.
  * [reward](https://github.com/harmony-one/harmony/tree/main/staking/reward): Checks whether rewards are issued and if so calculates the rewards based on total tokens staked.
  * [slash](https://github.com/harmony-one/harmony/tree/main/staking/slash): Slashes validators for malevolent acts such as double signing.
  * [types](https://github.com/harmony-one/harmony/tree/main/staking/types): Type definitions for staking structures.
  * [verify](https://github.com/harmony-one/harmony/tree/main/staking/verify): verifies aggregate signatures

### Rosetta

* [rosetta](https://github.com/harmony-one/harmony/tree/main/rosetta): responsible for staring a [rosetta](https://www.rosetta-api.org/docs/welcome.html) http server.

### Cryptographic Primitives

**hash functions**

* [hash](https://github.com/harmony-one/harmony/tree/main/crypto/hash): Uses kecakk256 and sha256 and provides the abilty to hash the RLP representation of the given object.

**random number generators**

* [VDF](https://github.com/harmony-one/harmony/tree/main/crypto/vdf): Verifiable Random Delay Function. Package vdf is a proof-of-concept implementation of a delay function and the security properties are not guaranteed. A more secure implementation of the [VDF by Wesolowski](https://eprint.iacr.org/2018/623.pdf) is to be implemented.
* [VRF](https://github.com/harmony-one/harmony/tree/main/crypto/vrf): a pseudorandom function f_k from a secret key k, such that that knowledge of k not only enables one to evaluate f_k at for any message m, but also to provide an NP-proof that the value f_k(m) is indeed correct without compromising the unpredictability of f_k for any m' != m. See [Verifiable Random Functions](https://dash.harvard.edu/bitstream/handle/1/5028196/Vadhan_VerifRandomFunction.pdf?sequence=2&isAllowed=y).

## References

**Consensus**

* [Harmony FBFT Consensus Documentation](https://docs.harmony.one/home/general/technology/consensus): Harmony’s consensus algorithm is called Fast Byzantine Fault Tolerance (FBFT), which is an innovative upgrade on the famous PBFT algorithm. As an implementation detail, note that custom [generator points are used](https://github.com/herumi/bls/issues/74).
* [Harmony Slot Bidding and Election](https://docs.harmony.one/home/network/validators/definitions/slots-bidding-and-election)
* [Building a Better Blockchain: The Implementation of External Leader Rotation on Harmony](https://docs.harmony.one/home/network/validators/definitions/slots-bidding-and-election): A proposal to improve the leader rotatation by introducing changes to incldue external validators.
* [Harmony consensus.go Code](https://github.com/harmony-one/harmony/blob/main/consensus/consensus.go): Harmony Consensus logic (go)
* [Harmony quorom.go](https://github.com/harmony-one/harmony/blob/main/consensus/quorum/quorum.go): Harmony's quorom logic responsible for trakcing participants, submitting and aggregating votes.
* [Merkle Mountain Ranges](https://docs.grin.mw/wiki/chain-state/merkle-mountain-range/): Merkle Mountain Ranges1 are an alternative to Merkle trees2. While the latter relies on perfectly balanced binary trees, the former can be seen either as list of perfectly balance binary trees or a single binary tree that would have been truncated from the top right.  
* [Harmony MMR-Hardfork Pull Request 3872](https://github.com/harmony-one/harmony/pull/3872): a MMR hard fork PR that adds mmrRoot to block header, adds logic to compute the MMR tree every epoch, RPCs to fetch the MMR proof for any given transaction.
* [Harmony MMR Hardfork Pull Request 4198](https://github.com/harmony-one/harmony/pull/4198): Follow up MMR pull request. *MMR is a series of perfect Merkle trees, from high to low. Each Merkle tree root we call it peak. Concat all peak hash and hash it, will get MMR root hash.*
* [Harmony MMRHardfork block header](https://github.com/peekpi/harmony/blob/mmrHardfork/block/v4/header.go): Harmony proposed block header including Merkle Mountain range (go).

**Signing**

* [Harmony bls.go codebase](https://github.com/harmony-one/bls/blob/master/ffi/go/bls/bls.go): Harmony's BLS library forked from [herumi/bls](https://github.com/herumi/bls) (go).

**Staking**

* [Harmony Effective Proof of Stake Documentation](https://docs.harmony.one/home/general/technology/effective-proof-of-stake): A staking mechanism for Harmony's sharded blockchain that achieves both security and decentralization using effective stake.
* [Harmony Staking Dashboard](https://staking.harmony.one/validators/mainnet): Staking Dashboard showing approximately 140 Elected Validators from 299 active validators.

## Footnotes

[^1]:  [Harmony consensus documentation](https://docs.harmony.one/home/general/technology/consensus). As an implementation detail, note that custom [generator points are used](https://github.com/herumi/bls/issues/74)

[^2]:  [Harmony Slot Bidding and Election](https://docs.harmony.one/home/network/validators/definitions/slots-bidding-and-election)

[^3]: [Scaling the Harmony Protocol with Light Clients](https://medium.com/harmony-one/scaling-the-harmony-protocol-with-light-clients-66d1eab26bf): a step-by-step guide on how to develop and run a light client on the Harmony Protocol using code examples.
