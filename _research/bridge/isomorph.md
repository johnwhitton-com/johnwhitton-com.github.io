---
title: Isomorph
category: bridge
date: 2023-02-24
---


## Overview

Isomporph is a Zero Knowledge trustless multichain bridge.

## Approach

## Sample Process Flow

At a high level when an event happens on chain 1 we want to trigger a corresponding action on chain 2.

For a simple bridging of funds this looks as follows

1. Alice deposits 100 TokenX into TokenLocker on Chain 1 (which are locked) **a1
2. A transaction t1 is triggered in Block b1 and an event e1 is sent
3. The relayer listens to event e1 and relays the transaction receipt information to Chain 2.
4. Verifier verifies that t1 is in block b1
5. Verifier verifies that block b1 is a valid block
6. Verifier verifies that b1 is in Chain1 canoninical chain
7. Executor1 triggers a minting of corresponding 100 TokenX∆ on TokenLocker∆ on Chain 2
8. A transaction t2 is triggered in Block b2 and an event e2 is sent
9. The relayer listens to event e2 and relays the transaction receipt information to Chain 1.
10. Verifier verifies that t2 is in block b2
11. Verifier verifies that block b2 is a valid block
12. Verifier verifies that b2 is in Chain2 canoninical chain
13. Executor2 marks the bridge transaction as complete

## Proof Components

* Valid Signers : Who are eligible to sign
* Valid Signature:
* Valid Block : (Epoch)

## Technology

* TokenLocker: [horizon txProof.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eprover/txProof.js) [npm EthProof](https://www.npmjs.com/package/eth-proof)
* TransactionVerify: Proves a [Merkle Patricia Trie](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/) using [merkle Proof](https://github.com/ethereum/consensus-specs/blob/dev/ssz/merkle-proofs.md) which verifies the [Transaction.Hash](https://github.com/ethereum/go-ethereum/blob/release/1.9/core/types/transaction.go#L44) against [Header.txHash](https://github.com/ethereum/go-ethereum/blob/release/1.9/core/types/block.go#L77). Here is an example from horizon using [horizon txProof.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eprover/txProof.js) which calls [npm EthProof](https://www.npmjs.com/package/eth-proof).
* BlockSignatureVerification
  * On Chain Verification : example is Near Rainbow Bridge Fraud Proof
  * Optimistic
  * Secure Enclave
  * Zero Knowledge
    * Prover
    * Verification
* BlockCanonicalVerification
  * Wait Number of Blocks
  * Optimistic
  * Light Client (Finality Gadgets)
  * Finalized Epoch
* EventLister
* Executor

## Proving Mechanisms

### Avalanche

### Binance

### Cosmos

### Ethereum

### NEAR

The leading NEAR Ethereum Bridge today Near Rainbow Bridge uses an optimistic approach.  Following is an excerpt from NearOnEthClient [^near-1].
> we adopt the optimistic [^near-2] approach where NearOnEthClient verifies everything in the NEAR header except the signatures. Then anyone can challenge a signature in a submitted header within a 4-hour challenge window. The challenge requires verification of a single Ed25519 signature which would cost about 500k Ethereum gas (expensive, but possible).

### Harmony

### Polygon

### Polkadot

Previous proving mechanisms for Polkadot leverage BEEFY (Bridge Effiency Enabling Finality Yielder) [^dot-3] an example is Snowbridge [^dot-1] which developed their own Interactive Update Protocol [^dot-2].

## Verification Mechanism

## Relayer Mechanisms

## Token Lockers

## References

## Appendices

### Appendix F: Data Structures

* Block Structure from [go-ethereum](https://github.com/ethereum/go-ethereum/blob/release/1.9/core/types/block.go#L72)

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

* Transaction structure from [go-ethereum](https://github.com/ethereum/go-ethereum/blob/release/1.9/core/types/transaction.go#LL39-L64C2)

```
type Transaction struct {
 data txdata    // Consensus contents of a transaction
 time time.Time // Time first seen locally (spam avoidance)

 // caches
 hash atomic.Value
 size atomic.Value
 from atomic.Value
}

type txdata struct {
 AccountNonce uint64          `json:"nonce"    gencodec:"required"`
 Price        *big.Int        `json:"gasPrice" gencodec:"required"`
 GasLimit     uint64          `json:"gas"      gencodec:"required"`
 Recipient    *common.Address `json:"to"       rlp:"nil"` // nil means contract creation
 Amount       *big.Int        `json:"value"    gencodec:"required"`
 Payload      []byte          `json:"input"    gencodec:"required"`

 // Signature values
 V *big.Int `json:"v" gencodec:"required"`
 R *big.Int `json:"r" gencodec:"required"`
 S *big.Int `json:"s" gencodec:"required"`

 // This is only used when marshaling to JSON.
 Hash *common.Hash `json:"hash" rlp:"-"`
}
```

## FootNotes
<!-- Overview -->

<!-- Approach -->

<!-- Proving Mechanisms -->

<!-- Avalanche -->

<!-- Binance -->

<!-- Cosmos -->

<!-- Ethereum -->

<!-- NEAR -->

[^near-1]: [NEAR: ETH-NEAR Rainbow Bridge](https://near.org/blog/eth-near-rainbow-bridge/): a bridge, called Rainbow Bridge, to connect the Ethereum and NEAR blockchains.

[^near-2]: [Optimistic Contracts](https://medium.com/@deaneigenmann/optimistic-contracts-fb75efa7ca84): contracts that accept all information as fact until proven to be non-factual. This allows for a reduction in the cost of verifying data, as on-chain verification would only be necessary when one is sure that the data is false.

<!-- Harmony -->

<!-- Polygon -->

<!-- Polkadot -->

[^dot-1]: [SnowBridge: Polkadot Verification](https://docs.snowbridge.network/architecture/verification/polkadot): use Polkadot’s BEEFY gadget to implement an efficient light client that only needs to verify a very small subset of relay chain validator signatures.

[^dot-2]: [Snowbridge: Interactive Update Protocol](https://docs.snowbridge.network/architecture/verification/polkadot/interactive-update-protocol): A prover wants to convince a light client that at least $$1/3$$  of validators signed a statement, which they claim that a specific set of at least $$2/3$$ of validators do.

[^dot-3]: [Polkadot: BEEFY](https://spec.polkadot.network/#sect-grandpa-beefy): The BEEFY (Bridge Effiency Enabling Finality Yielder) is a secondary protocol to GRANDPA to support efficient bridging between the Polkadot network (relay chain) and remote, segregated blockchains, such as Ethereum, which were not built with the Polkadot interchain operability in mind.

<!-- Verification Mechanism -->

<!-- Relayer Mechanisms -->

<!-- Token Lockers -->
