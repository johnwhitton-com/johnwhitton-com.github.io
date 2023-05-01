---
title: NEAR
category: chain
date: 2023-02-04
---

## Overview

Near supports We both secp256k1 and ed25519 for account keys and ed25519 for signing transactions. They currently use the ed25519_dalek and sha2 libraries for crypto.

## Consensus Mechanism

The following is an excerpt from [NEAR Chainspec for Consensus](https://github.com/near/NEPs/blob/master/specs/ChainSpec/Consensus.md)

For the purpose of maintaining consensus, transactions are grouped into *blocks*. There is a single preconfigured block $$G$$ called *genesis block*. Every block except $$G$$ has a link pointing to the *previous block* $$\operatorname{prev}(B)$$, where $$B$$ is the block, and $$G$$ is reachable from every block by following those links (that is, there are no cycles).
>
> The links between blocks give rise to a partial order: for blocks $$A$$ and $$B$$, $$A < B$$ means that $$A \ne B$$ and $$A$$ is reachable from $$B$$ by following links to previous blocks, and $$A \le B$$ means that $$A < B$$ or $$A = B$$. The relations $$>$$ and $$\ge$$ are defined as the reflected versions of $$<$$ and $$\le$$, respectively. Finally, $$A \sim B$$ means that either $$A < B$$, $$A = B$$ or $$A > B$$, and $$A \nsim B$$ means the opposite.
>
> A *chain* $$\operatorname{chain}(T)$$ is a set of blocks reachable from block $$T$$, which is called its *tip*. That is, $$\operatorname{chain}(T) = \{B \mid B \le T\}$$. For any blocks $$A$$ and $$B$$, there is a chain that both $$A$$ and $$B$$ belong to iff $$A \sim B$$. In this case, $$A$$ and $$B$$ are said to be *on the same chain*.
>
> Each block has an integer *height* $$\operatorname{h}(B)$$. It is guaranteed that block heights are monotonic (that is, for any block $$B \ne  G$$, $$\operatorname{h}(B) > \operatorname{h}(\operatorname{prev}(B))$$), but they need not be consecutive. Also, $$\operatorname{h}(G)$$ may not be zero. Each node keeps track of a valid block with the largest height it knows about, which is called its *head*.
>
> Blocks are grouped into *epochs*. In a chain, the set of blocks that belongs to some epoch forms a contiguous range: if blocks $$A$$ and $$B$$ such that $$A < B$$ belong to the same epoch, then every block $$X$$ such that $$A < X < B$$ also belongs to that epoch. Epochs can be identified by sequential indices: $$G$$ belongs to an epoch with index $$0$$, and for every other block $$B$$, the index of its epoch is either the same as that of $$\operatorname{prev}(B)$$, or one greater.
>
> Each epoch is associated with a set of block producers that are validating blocks in that epoch, as well as an assignment of block heights to block producers that are responsible for producing a block at that height. A block producer responsible for producing a block at height $$h$$ is called *block proposer at $$h$$*. This information (the set and the assignment) for an epoch with index $$i \ge 2$$ is determined by the last block of the epoch with index $$i-2$$. For epochs with indices $$0$$ and $$1$$, this information is preconfigured. Therefore, if two chains share the last block of some epoch, they will have the same set and the same assignment for the next two epochs, but not necessarily for any epoch after that.
>
>The consensus protocol defines a notion of *finality*. Informally, if a block $$B$$ is final, any future final blocks may only be built on top of $$B$$. Therefore, transactions in $$B$$ and preceding blocks are never going to be reversed. Finality is not a function of a block itself, rather, a block may be final or not final in some chain it is a member of. Specifically, $$\operatorname{final}(B, T)$$, where $$B \le T$$, means that $$B$$ is final in $$\operatorname{chain}(T)$$. A block that is final in a chain is final in all of its extensions: specifically, if $$\operatorname{final}(B, T)$$ is true, then $$\operatorname{final}(B, T')$$ is also true for all $$T' \ge T$$.

## Light Client Support

[NEAR Light Client Documentation](https://nomicon.io/ChainSpec/LightClient) gives an overview of how light clients work. At a high level the light client needs to fetch at least one block per [epoch](https://docs.near.org/concepts/basics/epoch) i.e. every 42,200 blocks or approxmiately 12 hours. Also Having the LightClientBlockView for block B is sufficient to be able to verify any statement about state or outcomes in any block in the ancestry of B (including B itself).

> The RPC returns the LightClientBlock for the block as far into the future from the last known hash as possible for the light client to still accept it. Specifically, it either returns the last final block of the next epoch, or the last final known block. If there's no newer final block than the one the light client knows about, the RPC returns an empty result.
>
> A standalone light client would bootstrap by requesting next blocks until it receives an empty result, and then periodically request the next light client block.
>
> A smart contract-based light client that enables a bridge to NEAR on a different blockchain naturally cannot request blocks itself. Instead external oracles query the next light client block from one of the full nodes, and submit it to the light client smart contract. The smart contract-based light client performs the same checks described above, so the oracle doesn't need to be trusted.

Following is an exerpt from the [Near Light Client Specification](https://github.com/near/NEPs/blob/master/specs/ChainSpec/LightClient.md)

**Near Light Client**

> The state of the light client is defined by:
>
> 1. `BlockHeaderInnerLiteView` for the current head (which contains `height`, `epoch_id`, `next_epoch_id`, `prev_state_root`, `outcome_root`, `timestamp`, the hash of the block producers set for the next epoch `next_bp_hash`, and the merkle root of all the block hashes `block_merkle_root`);
> 2. The set of block producers for the current and next epochs.
>
> The `epoch_id` refers to the epoch to which the block that is the current known head belongs, and `next_epoch_id` is the epoch that will follow.

> Light clients operate by periodically fetching instances of `LightClientBlockView` via particular RPC end-point described [below](#rpc-end-points).

> Light client doesn't need to receive `LightClientBlockView` for all the blocks. Having the `LightClientBlockView` for block `B` is sufficient to be able to verify any statement about state or outcomes in any block in the ancestry of `B` (including `B` itself). In particular, having the `LightClientBlockView` for the head is sufficient to locally verify any statement about state or outcomes in any block on the canonical chain.
>
> However, to verify the validity of a particular `LightClientBlockView`, the light client must have verified a `LightClientBlockView` for at least one block in the preceding epoch, thus to sync to the head the light client will have to fetch and verify a `LightClientBlockView` per epoch passed.

**Near Rainbow Bridge: NEAR Light Client on Ethereum Sample Implementation**

*The following is an excerpt from a blog by near on [eth-near-rainbow-bridge](https://near.org/blog/eth-near-rainbow-bridge/)*

> NearOnEthClient is an implementation of the NEAR light client in Solidity as an Ethereum contract. Unlike EthOnNearClient it does not need to verify every single NEAR header and can skip most of them as long as it verifies at least one header per NEAR epoch, which is about 43k blocks and lasts about half a day. As a result, NearOnEthClient can memorize hashes of all submitted NEAR headers in history, so if you are making a transfer from NEAR to Ethereum and it gets interrupted you don’t need to worry and you can resume it any time, even months later. Another useful property of the NEAR light client is that every NEAR header contains a root of the merkle tree computed from all headers before it. As a result, if you have one NEAR header you can efficiently verify any event that happened in any header before it.
>
> Another useful property of the NEAR light client is that it only accepts final blocks, and final blocks cannot leave the canonical chain in NEAR. This means that NearOnEthClient does not need to worry about forks.
>
> However, unfortunately, NEAR uses [Ed25519](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-665.md) to sign messages of the validators who approve the blocks, and this signature is not available as an EVM precompile. It makes verification of all signatures of a single NEAR header prohibitively expensive. So technically, we cannot verify one NEAR header within one contract call to NearOnEthClient. Therefore we adopt the [optimistic approach](https://medium.com/@deaneigenmann/optimistic-contracts-fb75efa7ca84) where NearOnEthClient verifies everything in the NEAR header except the signatures. Then anyone can challenge a signature in a submitted header within a 4-hour challenge window. The challenge requires verification of a single Ed25519 signature which would cost about 500k Ethereum gas (expensive, but possible). The user submitting the NEAR header would have to post a bond in Ethereum tokens, and a successful challenge would burn half of the bond and return the other half to the challenger. The bond should be large enough to pay for the gas even if the gas price increases exponentially during the 4 hours. For instance, a 20 ETH bond would cover gas price hikes up to 20000 Gwei. This optimistic approach requires having a watchdog service that monitors submitted NEAR headers and challenges any headers with invalid signatures. For added security, independent  users can run several watchdog services.

## References

**Consensus**

* [Consensus, NEAR Nomicon](https://nomicon.io/ChainSpec/Consensus)
* [NEAR blockchain core, (near)](https://github.com/near/nearcore)

**Signing**

* [Near Signing](https://docs.near.org/integrator/faq#how-are-cryptographic-functions-used): Near documentation on cryptographic functions.
* [nearcore signature.rs (codebase)](https://github.com/near/nearcore/blob/master/core/crypto/src/signature.rs): Near signature code (rust).

**Staking**

**Light Client**

* [Near Light Client](https://nomicon.io/ChainSpec/LightClient): Near Lithg Client Specification document.

**Additional**
