---
title: Polygon
category: chain
date: 2023-02-04
---

## Overview

Polygon is representative because it uses ECDSA on secp256k1 and a relatively fixed validator set.

The consensus protocol is based on Peppermint<sup>[8](#f8)</sup>, a modified version of Tendermint. Validators sign produced blocks using the ECDSA  signature scheme on secp256k1 curves<sup>[9](#f9)</sup>. Currently, the validator set size is fixed at 100 and only changes when a current validator resigns. This restriction will change when a new auction mechanism is implemented.<sup>[10](#f10)</sup>

## Consensus Mechanism

Polygon uses Peppermint (a modified version of tendermint) Consensus.

Following is an excerpt from [Polygon Architecture](https://github.com/maticnetwork/matic-docs/blob/master/docs/pos/polygon-architecture.md).

**Polygon Architecture**
> Heimdall is the proof of stake validation layer that handles the aggregation of blocks produced by Bor into a Merkle tree and publishes the Merkle root periodically to the root chain. The periodic publishing of snapshots of the Bor sidechain is called checkpoints.
>
> 1. Validates all the blocks since the last checkpoint.
> 2. Creates a Merkle tree of the block hashes.
> 3. Publishes the Merkle root hash to the Ethereum mainnet.
>
> Checkpoints are important for two reasons:
>
> 1. Providing finality on the root chain.
> 2. Providing proof of burn in withdrawal of assets.
>
> An overview of the process:
>
> * A subset of active validators from the pool is selected to act as [block producers](/docs/maintain/glossary#block-producer) for a [span](/docs/maintain/glossary#span). These block producers are responsible for creating blocks and broadcasting the created blocks on the network.
> * A checkpoint includes the Merkle root hash of all blocks created during any given interval. All nodes validate the Merkle root hash and attach their signature to it.
> * A selected [proposer](/docs/maintain/glossary#proposer) from the validator set is responsible for collecting all signatures for a particular checkpoint and committing the checkpoint on the Ethereum mainnet.
> * The responsibility of creating blocks and proposing checkpoints is variably dependent on a validator’s stake ratio in the overall pool.
>
> More details on Heimdall are available on the [Heimdall architecture](/docs/pos/heimdall/overview) guide.

This image from [Bor Architecture](https://wiki.polygon.technology/docs/pos/bor/) helps give a better understanding of how Ethereum, Heimdall and Bor work together.

![Matic Structure](/assets/research/matic_structure.png "Matic Structure")

## Signing Mechanism

Following is an excerpt from and [Peppermint.md](https://github.com/maticnetwork/matic-docs/blob/master/docs/pos/peppermint.md).

> Peppermint is a modified Tendermint. It is changed to make it compatible with Ethereum addresses and verifiable on Ethereum chain.
>
> Overview
>
> 1. Changes to signature scheme
> 2. Changes to `vote` to make it verifiable on Ethereum smart contract
> 3. Changes to `vote` encoding scheme
>
> Peppermint uses `secp256k1` signature scheme to verify Tendermint votes on solidity smart contract.
>
> Source: [https://github.com/maticnetwork/tendermint/blob/peppermint/crypto/secp256k1/secp256k1_nocgo.go](https://github.com/maticnetwork/tendermint/blob/peppermint/crypto/secp256k1/secp256k1_nocgo.go)
>
> It adds `Data` field into `Vote` and `Proposal` struct to get `hash` for transactions in the block. On smart contract, it checks if `Data` matches with checkpoint data hash and majority (⅔+1) of validator signatures. The idea is to verify if majority of the validator set agrees on transaction in the contract.
>
> Peppermint uses RLP to get `Vote` bytes instead of Amino encoding. Here `Data` is `Txs.Hash()` for the block.
>
> Source: [https://github.com/maticnetwork/tendermint/blob/peppermint/types/canonical.go](https://github.com/maticnetwork/tendermint/blob/peppermint/types/canonical.go)

> ```go
> // [peppermint] create RLP vote to decode in contract
> type CanonicalRLPVote struct {
>  ChainID string
>  Type    byte
>  Height  uint
>  Round   uint
>  Data    []byte
> }
> ```
>
> And using RLP encoding lib to get byte data for signature on Vote.
>
> Source: [https://github.com/maticnetwork/tendermint/blob/peppermint/types/vote.go#L75-L82](https://github.com/maticnetwork/tendermint/blob/peppermint/types/vote.go#L75-L82)

> ```go
> func (vote *Vote) SignBytes(chainID string) []byte {
>  // [peppermint] converted from amino to rlp
>  bz, err := rlp.EncodeToBytes(CanonicalizeVote(chainID, vote))
>  if err != nil {
>   panic(err)
>  }
>  return bz
> }
> ```
>
> Complete Source: [https://github.com/maticnetwork/tendermint](https://github.com/maticnetwork/tendermint)

**Note: As of March 12th, 2023 the pepperming votes function now uses amino**

[tendermint/types/vote.go](https://github.com/maticnetwork/tendermint/blob/peppermint/types/vote.go)

```go
func (vote *Vote) SignBytes(chainID string) []byte {
 // [peppermint] converted from amino to rlp
 bz, err := cdc.MarshalBinaryLengthPrefixed(CanonicalizeVote(chainID, vote))
 if err != nil {
  panic(err)
 }
 return bz
}
```

[tendermint/consensus/codec.go](https://github.com/maticnetwork/tendermint/blob/peppermint/consensus/codec.go)

```go
package consensus

import (
 amino "github.com/tendermint/go-amino"
 "github.com/tendermint/tendermint/types"
)

var cdc = amino.NewCodec()

func init() {
 RegisterConsensusMessages(cdc)
 RegisterWALMessages(cdc)
 types.RegisterBlockAmino(cdc)
}

```

[tendermint/p2p/codec.go](https://github.com/maticnetwork/tendermint/blob/peppermint/p2p/codec.go)

```go
package p2p

import (
 amino "github.com/tendermint/go-amino"
 cryptoAmino "github.com/tendermint/tendermint/crypto/encoding/amino"
)

var cdc = amino.NewCodec()

func init() {
 cryptoAmino.RegisterAmino(cdc)
}
```

## Code Review

Polygon's [peppermint fork of tendermint](https://github.com/maticnetwork/tendermint) was forked from [tendermint](https://github.com/tendermint/tendermint) and as such the codebase has similar functions to those documented in [cosmos code review](./cosmos#code-review).

The major changes are to the consensus and signing (see above)

Polygon's [bor](https://github.com/maticnetwork/bor) is cloned from [geth](https://github.com/ethereum/go-ethereum) and as such the codebase has similar functions to those documented in [ethereum 1-0 code review](./ethereum-1-0#code-review).

### Signing

* [Peppermint secp256k1 Codebase](https://github.com/maticnetwork/tendermint/tree/peppermint/crypto/secp256k1): Peppermint ECDSA Secp256k1 curve codebase (go).
  * [Peppermint secp256k1 signing code](https://github.com/maticnetwork/tendermint/blob/peppermint/crypto/secp256k1/secp256k1_nocgo.go#L21): Peppermint sign function (go). *Sign creates an ECDSA signature on curve Secp256k1, using SHA256 on the msg. The returned signature will be of the form R `||` S (in lower-S form).*

### Consensus

* [Peppermint](https://github.com/maticnetwork/tendermint)
  * [state.go](https://github.com/maticnetwork/tendermint/blob/peppermint/consensus/state.go#L886): Modified to support [heimdall](https://wiki.polygon.technology/docs/pos/heimdall/overview).

## References

**Consensus**

* [The latest gossip on BFT consensus](https://arxiv.org/pdf/1807.04938.pdf): The paper presents Tendermint, a new protocol for ordering events in a distributed network under adversarial conditions.
* [Heimdall Documentation](https://wiki.polygon.technology/docs/pos/heimdall/overview/): Heimdall consensus engine uses the Cosmos-SDK and a forked version of Tendermint, called Peppermint.
* [Peppermint Documentation](https://wiki.polygon.technology/docs/pos/peppermint/): Peppermint is a modified Tendermint. It is changed to make it compatible with Ethereum addresses and verifiable on Ethereum chain.
* [Peppermint Codebase](https://github.com/maticnetwork/tendermint/tree/peppermint): Polygon fork of tendermint codebase (go).
  * [Peppermint Consensus Code](https://github.com/maticnetwork/tendermint/blob/peppermint/consensus/state.go#L70): Peppermint Consensus (go). *ConsensusState handles execution of the consensus algorithm. It processes votes and proposals, and upon reaching agreement, commits blocks to the chain and executes them against the application. The internal state machine receives input from peers, the internal validator, and from a timer.*
  * [Peppermint Consenus Configuration Code](https://github.com/maticnetwork/tendermint/blob/master/config/config.go#L443): Peppermint Consensus Configuration(go). *defines the configuration for the Tendermint consensus service, including timeouts and details about the Write Ahead Logs (WAL) and the block structure.*
  * [Peppermint Validator Set Code](https://github.com/maticnetwork/tendermint/blob/peppermint/types/validator_set.go): Peppermint Validators (go). *ValidatorSet represent a set of*Validator at a given height.*
* [Bor Consensus Documentation](https://wiki.polygon.technology/docs/pos/bor/consensus/): Bor consensus is inspired by Clique consensus: <https://eips.ethereum.org/EIPS/eip-225>.
* [EIP-225: Clique proof-of-authority consensus protocol](https://eips.ethereum.org/EIPS/eip-225): Clique is a proof-of-authority consensus protocol. It shadows the design of Ethereum mainnet, so it can be added to any client with minimal effort.
* [Heimdall and Bor Article](https://polygon.technology/blog/heimdall-and-bor): Article explaining Polygon(Matic) hybrid Plasma + Proof-of-Stake (PoS) platform.

**Staking**

* [Hemidall Staking Documentation](https://wiki.polygon.technology/docs/pos/heimdall/modules/staking/)
* [Polygon Staking App](https://staking.polygon.technology/): Polygon Staking Application listing 100 validators

**Additional**

<a name="f8">[8]</a><a name="f9">[9]</a> See notes and links to code in [Peppermint summary](https://wiki.polygon.technology/docs/pos/peppermint/)

<a name="f10">[10]</a> See Polygon validator [documentations](https://wiki.polygon.technology/docs/maintain/validate/validator-responsibilities/)
