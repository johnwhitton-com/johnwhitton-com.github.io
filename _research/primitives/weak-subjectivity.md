---
title:  Weak Subjectivity
category: primitive
date: 2023-02-04
---

## Overview

Following is an excerpt from *Analysis on Weak Subjectivity in Ethereum 2.0* [^1] .

> Weak subjectivity [^2] is a social-consensus-driven approach for solving the fun- damental “nothing-at-stake” problem of proof-of-stake protocols. In particular, it addresses the problem in the presence of long-range forks, while the slash- ing mechanism handles the case of short-range forks. Specifically, the current weak subjectivity mechanism deals with the following two types of long-range attacks [^3]
>
> – *Exploiting retired validators:* Adversaries can create and reveal a new chain branching from a certain block on the canonical chain, after 2/3 of validators who were active for the block have exited. Note that such validators can still justify and finalize conflicting blocks at earlier slots without being slashed after they have exited.
>
> – *Exploiting diverging validator sets:* Adversaries can build a new chain until the validator set for the new chain is sufficiently different from that of the canonical chain. The larger the difference between the two validator sets, the lower the accountable safety tolerance. For example, if the intersection of the two sets is smaller than 2/3 of each set, then it is possible to have conflicting blocks to be finalized without any validators violating the slashing conditions.
>
> *It is unknown whether this mechanism can deal with other types of long-range attacks, if any, in general.*
>
> The current weak subjectivity mechanism employs a social consensus layer in parallel to maintain sufficiently many checkpoints (called weak subjectivity check- points) so that there exist no conflicting finalized blocks that are descendants of the latest weak subjectivity checkpoint. In other words, the purpose of the latest weak subjectivity checkpoints is to deterministically identify the unique canonical chain even in the presence of conflicting finalized blocks caused by the long-range attacks.

## References

<!-- Articles and guides -->
* [Weak Subjectivity in Eth2.0](https://notes.ethereum.org/@adiasg/weak-subjectvity-eth2): This document is aimed for Eth2.0 client teams to understand weak subjectivity periods and their implication.

* [Phase 0 -- Weak Subjectivity Guide](https://github.com/ethereum/consensus-specs/blob/master/specs/phase0/weak-subjectivity.md): This document is a guide for implementing the Weak Subjectivity protections in Phase 0.

<!-- Documentation -->
* [Ethereum Docs: WEAK SUBJECTIVITY](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/weak-subjectivity/): This refers to a chain that can progress objectively after some initial seed of information is retrieved socially.

* [Teku Docs: Weak Subjectivity](https://docs.teku.consensys.net/Concepts/Weak-Subjectivity/): The weak subjectivity period refers to how far behind the chain head a node can be before 1/3 of validators may have exited since the node was last in sync.

<!-- Implementations -->
* [Prysm: weak_subjectivity_checks.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/blockchain/weak_subjectivity_checks.go)
  * [NewWeakSubjectivityVerifier](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/blockchain/weak_subjectivity_checks.go#L31) validates a checkpoint, and if valid, uses it to initialize a weak subjectivity verifier.
  * [VerifyWeakSubjectivity](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/blockchain/weak_subjectivity_checks.go#L52) verifies the weak subjectivity root in the service struct.

 <!-- Footnotes -->
[^1]: [Analysis on Weak Subjectivity in Ethereum 2.0](https://github.com/runtimeverification/beacon-chain-verification/blob/master/weak-subjectivity/weak-subjectivity-analysis.pdf):

[^2]: [Proof of Stake: How I Learned to Love Weak Subjectivity](https://blog.ethereum.org/2014/11/25/proof-stake-learned-love-weak-subjectivity):

[^3]: It is unknown whether this mechanism can deal with other types of long-range attacks, if any, in general
