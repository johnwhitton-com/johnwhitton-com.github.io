---
title: Ethereum
category: chain
date: 2023-02-04
---


- [Overview](#overview)
- [Consensus Mechanism](#consensus-mechanism)
  - [Block Production](#block-production)
  - [Slots and Epochs 6](#slots-and-epochs-6)
  - [Block Proposals](#block-proposals)
  - [Committees](#committees)
  - [Attestations](#attestations)
  - [Checkpoints and Finality6](#checkpoints-and-finality6)
  - [Sync Committee 10](#sync-committee-10)
  - [Validator Lifecycle](#validator-lifecycle)
- [Light Client Support](#light-client-support)
- [References](#references)
- [Appendices](#appendices)
  - [Appendix A: Ethreum 2.0 Technical Deep Dive](#appendix-a-ethreum-20-technical-deep-dive)
    - [Block Production](#block-production-1)
    - [Consensus and Finality](#consensus-and-finality)
  - [Appendix B: Additional Light Client Support Documentation](#appendix-b-additional-light-client-support-documentation)
    - [Key Concepts](#key-concepts)
    - [Altair Light Client -- Sync Protocol](#altair-light-client----sync-protocol)
    - [The Portal Network](#the-portal-network)
    - [Transaction Proofs](#transaction-proofs)
    - [Further Information](#further-information)
  - [Appendix C: Proving and Verification Mechanisms](#appendix-c-proving-and-verification-mechanisms)
    - [eth-proof-of-consensus: Proof of Consensus for Ethereum by succinctlabs](#eth-proof-of-consensus-proof-of-consensus-for-ethereum-by-succinctlabs)
  - [Appendix D: Topics](#appendix-d-topics)
  - [Appendix E: gRPC and API's](#appendix-e-grpc-and-apis)
  - [Appendix F: Data Structures](#appendix-f-data-structures)
    - [Beacon State Data Structures from Prysm](#beacon-state-data-structures-from-prysm)
    - [web3signer\_types from prysm](#web3signer_types-from-prysm)
  - [Appendix G: Sample Data](#appendix-g-sample-data)
    - [Epoch Data for 167040](#epoch-data-for-167040)
    - [Block Data for Slot 5,330,592](#block-data-for-slot-5330592)
    - [Execution Block for 16163905](#execution-block-for-16163905)
    - [Sync Committee (latest)](#sync-committee-latest)
  - [Appendix H: Sync Committe Creation and Retrieval](#appendix-h-sync-committe-creation-and-retrieval)

## Overview

With the Introduction of Ethereum 2.0<sup>[1](#bp1)</sup> <sup>[2](#bp2)</sup> <sup>[3](#bp3)</sup> block production and consensus were separated<sup>[4](#bp4)</sup> into execution clients<sup>[5](#bp5)</sup> and consensus clients<sup>[6](#ts6)</sup> <sup>[7](#bp7)</sup>.

The execution chain implemented a simplified Proof of Work<sup>[1](#bp1)</sup> reducing difficutly to zero and removing the need for omners (uncles) which would now be handled by the beacon chain<sup>[3](#bp3)</sup> which is responsible for providing consensus <sup>[2](#bp2)</sup>.

Light Clients<sup>[11](#ts11)</sup> were also introduced. To facilate this
a sync committee of 512 current validators is elected every 255 epochs, approximately every 27 hours (see [sample sync comittee data](#sync-committee-latest)), they are responsible for signing each block.

As at December 11th, 2022 Ethereum has 487,920 validators<sup>[8](#bp8)</sup> with a sample epoch ([166581](https://beaconcha.in/epoch/166581)) and slot ([5,330,592](https://beaconcha.in/slot/5330592)) having [139 transactions](https://beaconcha.in/slot/5330592#transactions) with [19,227 votes](https://beaconcha.in/slot/5330592#votes) from 63 committees and [126 aggregated committe attestations](https://beaconcha.in/slot/5330592#attestations).

Here is more information on the upgrade<sup>[9](#bp9)</sup> and the roadmap<sup>[10](#bp10)</sup>

![Ethereum Roadmap](/assets/research/ethereum-roadmap.jpg "Ethereum Roadmap")

## Consensus Mechanism

Ethreum uses Proof of Stake (PoS). Here we give an overview of Proof of Stake Followed by a deep dive into synch committees.
Following is an excerpt from [Ethereum Orgs Proof of Stake document](Proof-of-stake (PoS))

> **What is proof-of-stake (PoS)?**

> Proof-of-stake underlies certain [consensus mechanisms](/developers/docs/consensus-mechanisms/) used by blockchains to achieve distributed consensus. In proof-of-work, miners prove they have capital at risk by expending energy. Ethereum uses proof-of-stake, where validators explicitly stake capital in the form of ETH into a smart contract on Ethereum. This staked ETH then acts as collateral that can be destroyed if the validator behaves dishonestly or lazily. The validator is then responsible for checking that new blocks propagated over the network are valid and occasionally creating and propagating new blocks themselves.

> Proof-of-stake comes with a number of improvements to the now-deprecated proof-of-work system:

> - better energy efficiency – there is no need to use lots of energy on proof-of-work computations
> - lower barriers to entry, reduced hardware requirements – there is no need for elite hardware to stand a chance of creating new blocks
> - reduced centralization risk – proof-of-stake should lead to more nodes securing the network
> - because of the low energy requirement less ETH issuance is required to incentivize participation
> - economic penalties for misbehaviour make 51% style attacks exponentially more costly for an attacker compared to proof-of-work
> - the community can resort to social recovery of an honest chain if a 51% attack were to overcome the crypto-economic defenses.

### Block Production

Validators run both an Ethereum 1 client (e.g. geth) and a Beacon Chain Client (e.g. prysm). The geth client recieves transactions and places them into blocks. For additional details see the Ethereum Builder Specs<sup>[12](#ts12)</sup>. The following diagrams give an overview of how blocks are proposed and how MEV Boost<sup>[13](#ts13)</sup> could be integrated. For simplification we can replace mev_boost and relay with geth in the block proposal diagram as the majority of validators simply run a geth node.

![Block Proposal](/assets/research/block-proposal.png "Block Proposal")

### Slots and Epochs <sup>[6](#ts6)</sup>  
>
>The Beacon Chain provides the heartbeat to Ethereum’s consensus. Each slot is 12 seconds and an epoch is 32 slots: 6.4 minutes.

![Slots and Epochs](/assets/research/Beacon-Chain-Slots-and-Epochs.png.webp "Slots and Epochs")

### Block Proposals

When a validator is nominated as a proposer for a slot in an Epoch they propose a block gathered from there Ethereum 1 client.

This proposed block is attested to by other validators who have been assigned as committe members for this slot<sup>[6](#ts6)</sup>.
> A block proposer is a validator that has been pseudorandomly selected to build a block.
>
> Most of the time, validators are attesters that vote on blocks.  These votes are recorded in the Beacon Chain and determine the head of the Beacon Chain.

![Validators and Attestations](/assets/research/Beacon-Chain-Validators.png "Validators and Attestations")

### Committees
>
> A committee is a group of validators.  For security, each slot has committees of at least 128 validators.  An attacker has less than a one in a trillion probability of controlling ⅔ of a committee.
>
>The concept of a randomness beacon that emits random numbers for the public, lends its name to the Ethereum Beacon Chain. The Beacon Chain enforces consensus on a pseudorandom process called RANDAO.

![Committees](/assets/research/Beacon-Chain-RANDAO.png "Committees")

### Attestations

The attestation lifecyle<sup>[9](#ts9)</sup> involves

1. Generation of the proposed Block
2. Propagation of the block to committee members to vote on and sign
3. Aggregation of the votes (signatures) of the committee members by Aggregators
4. Propagation of the aggregated attestations back to the block Proposer
5. Inclusion of the block in the Beaconchain

![Attestation Life Cycle](/assets/research/AttestationLifeCycle.png "Attestation Life Cycle")

### Checkpoints and Finality<sup>[6](#ts6)</sup>
>
> When an epoch ends, if its checkpoint has garnered a ⅔ supermajority, the checkpoint gets justified.

![Checkpoints](/assets/research/Beacon-Chain-Checkpoints.jpg "Checkpoints")

> If a checkpoint B is justified and the checkpoint in the immediate next epoch becomes justified, then B becomes finalized.  Typically, a checkpoint is finalized in two epochs, 12.8 minutes.

![Finality](/assets/research/Beacon-Chain-Justification-and-Finalization.png "Finality")

### Sync Committee <sup>[10](#ts10)</sup>

A sync committee of 512 current validators is elected every 255 epochs, approximately every 27 hours (see [sample sync comittee data](#sync-committee-latest)).
They are responsible for signing each block which records which sync committee members (validtors) signed the block, held in `syncaggregate_bits`, and creates a bls aggregate signature held in `syncaggregate_signature` (see [block-data](#block-data-for-slot-5330592)).

```
    "syncaggregate_bits": "0xdffffffffffffffffffffffffffffff7fffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffffffffffdffffffffffffffffffffffff",
    "syncaggregate_participation": 0.9921875,
    "syncaggregate_signature": "0x95332c55790018eed3d17eada01cb4045348d09137505bc8697eeedaa3800a830ee2c138251850a9577f62a5488419ef0a722579156a177fb3a147017f1077af5d778f46a4cdf815fc450129d135fe5286e16df68333592e4aa45821bde780dd",
```

This is used in Altair Light Client -- Sync Protocol<sup>[11](#ts11)</sup> which enables the beacon chain to be light client friendly for constrained environments to access Ethereum.

### Validator Lifecycle

Following is an overview of statuses for validators in Ethereum 2.0 phase 0 <sup>[14](#ts14)</sup>.

> 1. **Deposited**: the validator has made a deposit and has registered in BeaconState.
> 2. **Eligible to be activated (Pending)**: the validator is eligible to be activated.
> 3. **Activated**: the validator is activated
>    - *Note that the validator may be “eligible to be activated, but has not been activated yet”.*
> 4. **Slashed**: the validator has been slashed
> 5. **Exited**: the validator is exited
> 6. **Withdrawable**: the validator is withdrawable
>     - *Note that the validator will be able to withdraw to EEs in phase 2*
>
> *Note that in some cases, a validator can be in multiple statuses at the same time, e.g., an active validator may be “activated and slashed”.*

![Validator Status Transition](/assets/research/ValidatorStateTransition.png "Validator Status Transition")

## Light Client Support

**Light client state updates**

- A light client receives objects of type `LightClientUpdate`, `LightClientFinalityUpdate` and `LightClientOptimisticUpdate`:
  - **`update: LightClientUpdate`**: Every `update` triggers `process_light_client_update(store, update, current_slot, genesis_validators_root)` where `current_slot` is the current slot based on a local clock.
  - **`finality_update: LightClientFinalityUpdate`**: Every `finality_update` triggers `process_light_client_finality_update(store, finality_update, current_slot, genesis_validators_root)`.
  - **`optimistic_update: LightClientOptimisticUpdate`**: Every `optimistic_update` triggers `process_light_client_optimistic_update(store, optimistic_update, current_slot, genesis_validators_root)`.
- `process_light_client_store_force_update` MAY be called based on use case dependent heuristics if light client sync appears stuck.

**validate_light_client_update**

```python
def validate_light_client_update(store: LightClientStore,
                                 update: LightClientUpdate,
                                 current_slot: Slot,
                                 genesis_validators_root: Root) -> None:
    # Verify sync committee has sufficient participants
    sync_aggregate = update.sync_aggregate
    assert sum(sync_aggregate.sync_committee_bits) >= MIN_SYNC_COMMITTEE_PARTICIPANTS

    # Verify update does not skip a sync committee period
    assert is_valid_light_client_header(update.attested_header)
    update_attested_slot = update.attested_header.beacon.slot
    update_finalized_slot = update.finalized_header.beacon.slot
    assert current_slot >= update.signature_slot > update_attested_slot >= update_finalized_slot
    store_period = compute_sync_committee_period_at_slot(store.finalized_header.beacon.slot)
    update_signature_period = compute_sync_committee_period_at_slot(update.signature_slot)
    if is_next_sync_committee_known(store):
        assert update_signature_period in (store_period, store_period + 1)
    else:
        assert update_signature_period == store_period

    # Verify update is relevant
    update_attested_period = compute_sync_committee_period_at_slot(update_attested_slot)
    update_has_next_sync_committee = not is_next_sync_committee_known(store) and (
        is_sync_committee_update(update) and update_attested_period == store_period
    )
    assert (
        update_attested_slot > store.finalized_header.beacon.slot
        or update_has_next_sync_committee
    )

    # Verify that the `finality_branch`, if present, confirms `finalized_header`
    # to match the finalized checkpoint root saved in the state of `attested_header`.
    # Note that the genesis finalized checkpoint root is represented as a zero hash.
    if not is_finality_update(update):
        assert update.finalized_header == LightClientHeader()
    else:
        if update_finalized_slot == GENESIS_SLOT:
            assert update.finalized_header == LightClientHeader()
            finalized_root = Bytes32()
        else:
            assert is_valid_light_client_header(update.finalized_header)
            finalized_root = hash_tree_root(update.finalized_header.beacon)
        assert is_valid_merkle_branch(
            leaf=finalized_root,
            branch=update.finality_branch,
            depth=floorlog2(FINALIZED_ROOT_INDEX),
            index=get_subtree_index(FINALIZED_ROOT_INDEX),
            root=update.attested_header.beacon.state_root,
        )

    # Verify that the `next_sync_committee`, if present, actually is the next sync committee saved in the
    # state of the `attested_header`
    if not is_sync_committee_update(update):
        assert update.next_sync_committee == SyncCommittee()
    else:
        if update_attested_period == store_period and is_next_sync_committee_known(store):
            assert update.next_sync_committee == store.next_sync_committee
        assert is_valid_merkle_branch(
            leaf=hash_tree_root(update.next_sync_committee),
            branch=update.next_sync_committee_branch,
            depth=floorlog2(NEXT_SYNC_COMMITTEE_INDEX),
            index=get_subtree_index(NEXT_SYNC_COMMITTEE_INDEX),
            root=update.attested_header.beacon.state_root,
        )

    # Verify sync committee aggregate signature
    if update_signature_period == store_period:
        sync_committee = store.current_sync_committee
    else:
        sync_committee = store.next_sync_committee
    participant_pubkeys = [
        pubkey for (bit, pubkey) in zip(sync_aggregate.sync_committee_bits, sync_committee.pubkeys)
        if bit
    ]
    fork_version = compute_fork_version(compute_epoch_at_slot(update.signature_slot))
    domain = compute_domain(DOMAIN_SYNC_COMMITTEE, fork_version, genesis_validators_root)
    signing_root = compute_signing_root(update.attested_header.beacon, domain)
    assert bls.FastAggregateVerify(participant_pubkeys, signing_root, sync_aggregate.sync_committee_signature)
```

**apply_light_client_update**

```python
def apply_light_client_update(store: LightClientStore, update: LightClientUpdate) -> None:
    store_period = compute_sync_committee_period_at_slot(store.finalized_header.beacon.slot)
    update_finalized_period = compute_sync_committee_period_at_slot(update.finalized_header.beacon.slot)
    if not is_next_sync_committee_known(store):
        assert update_finalized_period == store_period
        store.next_sync_committee = update.next_sync_committee
    elif update_finalized_period == store_period + 1:
        store.current_sync_committee = store.next_sync_committee
        store.next_sync_committee = update.next_sync_committee
        store.previous_max_active_participants = store.current_max_active_participants
        store.current_max_active_participants = 0
    if update.finalized_header.beacon.slot > store.finalized_header.beacon.slot:
        store.finalized_header = update.finalized_header
        if store.finalized_header.beacon.slot > store.optimistic_header.beacon.slot:
            store.optimistic_header = store.finalized_header
```

**Sample Implementation: NEAR Rainbow Bridge Ethereum Light Client Deployed on NEAR**

Bridging support was implemented by NEAR under [Eth2-to-Near-relay: prototype implementation #762
](https://github.com/aurora-is-near/rainbow-bridge/pull/762)

![Ethereum 2 block proof](/assets/posts/2023-02-05-ethereum-bridging-costs/ETH_2_0_MMR.jpg "Ethereum 2 Block Proof")

> When we send light client update for finality block inside light client update, we also send Eth1 execution block hash with the Merkle proof of include to Beacon Block Body. Execution block hash you can find at BeaconBlockBody.execution_payload.block_hash.
>
> So, for creating Merkle proof, we need two levels of Merkle Tree, as shown in the picture. Both Merkle trees you can find in beacon_block_body_merkle_tree.rs The first level Merkle tree for beacon block body and the second level Merkle tree for execution payload.
>
> The execution block hash proof creation you can find in execution_block_proof.rs First, we build two Merkle trees and concatenate together the Merkle proof for block_hash in execution_payload and the Merkle proof of execution_payload in beacon_block_body. The final Merkle proof is shown by the orange vertices on the picture; the orange numbers in the picture are the order of hashes in the proof.
>
> beacon_block_header_with_execution_data.rs contain a structure which consists of beacon_block_header and correspondent execution_block_hash with Merkle proof. This structure is created for finality blocks in a light client update.

## References

**Consensus**

- [Gasper Consensus Whitepaper](https://arxiv.org/pdf/2003.03052.pdf): Combining GHOST and Casper
- [sigp lighthouse beacon block](https://github.com/sigp/lighthouse/blob/stable/consensus/types/src/beacon_block.rs#L7): Beacon Block codebase (rust)

<a name="bp1">[1]</a>  [EIP-3675: Upgrade consensus to Proof-of-Stake](https://eips.ethereum.org/EIPS/eip-3675#pow-block-processing): Specification of the consensus mechanism upgrade on Ethereum Mainnet that introduces Proof-of-Stake.

<a name="bp2">[2]</a>  [EIP-2982: Serenity Phase 0](https://eips.ethereum.org/EIPS/eip-2982): Phase 0 of the release schedule of Serenity, a series of updates to Ethereum a scalable, proof-of-stake consensus.

<a name="bp3">[3]</a>  [Ethreum Consensus Specs Phase 0](https://github.com/ethereum/consensus-specs/tree/dev/specs/phase0): Specifications for Ethereum 2.0 Phase 0 including [beacon-chain](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/beacon-chain.md), [deposit-contract](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/deposit-contract.md), [fork-choice](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/fork-choice.md), [p2p-interface](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/p2p-interface.md), [validator](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/validator.md) and [weak-subjectivity](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/weak-subjectivity.md)

<a name="bp4">[6]</a>  [Ethereum Consensus and Execution Client Distribution](https://clientdiversity.org/#distribution): Percentages of nodes running client types for  both Consensus (Prysm, Lighthours, Nimbus, Teku) and Execution (Geth, Erigon, Besu, Nethermind) clients.

<a name="bp5">[5]</a>  [go-ethereum go documentation](https://pkg.go.dev/github.com/ethereum/go-ethereum@v1.10.26): Documentation for Go Ethereum, Official Golang implementation of the Ethereum protocol. Which is an execution chain implementation.

<a name="bp6">[6]</a>  [prysm go documentation](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2): Documentation for prysm, An Ethereum Consensus Implementation Written in Go. A beacon-chain immplementation. Also see [Prysm Documentation](https://docs.prylabs.network/docs/getting-started)

<a name="bp7">[7]</a>  [lighthouse documentation](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2): Documentation for lighthouse, written in Rust. A beacon-chain immplementation.

<a name="bp8">[8]</a> [Etherum 2.0 Validators Overview](https://beaconcha.in/validators): Live Monitoring of Ethreum 2.0 Validators from beachoncha.in

<a name="bp9">[9]</a> [Upgrading Ethereum](https://eth2book.info/bellatrix/): A technical handbook on Ethereum's move to proof of stake and beyond Edition 0.2: Bellatrix [WIP] by Ben Edgington.

<a name="bp10">[9]</a> [Annotated Ethereum Roadmap](https://notes.ethereum.org/@domothy/roadmap): an entry point for the various items on the Ethereum roadmap, with a quick summary along with links for those who want to dive deeper.

<a name="bp11">[10]</a> [Shanghai/Capella Upgrade](https://consensys.net/shanghai-capella-upgrade/): the first simultaneous upgrade of Ethereum’s execution layer and consensus layer, and is highly anticipated because it will enable staked ETH withdrawals.

**Signing**

- [sigp lighthouse bls signing](https://github.com/sigp/lighthouse/blob/stable/crypto/bls/src/lib.rs): BLS signing codebase (rust)

**Staking**

- [Ethereum Staking](https://ethereum.org/en/staking/): Staking User Interface
- [App Stakewise](https://app.stakewise.io/): Ethreeum Staking Application
- [PROOF-OF-STAKE (POS)](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/): Ethereum Proof of Stake Documentation

**References Technical Summary**

<a name="ts1">[1]</a>  [Ethereum EVM illustrated](https://takenobu-hs.github.io/downloads/ethereum_evm_illustrated.pdf): A technical overview of Ethereum including state, accounts, transactions and messages as well as the EVM. [Appendix E](#appendix-e-data-structures) has links to type definitions for blocks, transactions, state etc in geth.

<a name="ts2">[2]</a> [Blocks](https://ethereum.org/en/developers/docs/blocks/): Block data definitions including attestations from ethereum.org

<a name="ts3">[3]</a> [eth1 block proposal](https://hackmd.io/@flashbots/mev-in-eth2#eth1-block-proposal): Technical walkthrough of how blocks are proposed and potential MEV opportunities from FlashBots.

<a name="ts4">[4]</a> [Assemble Block](https://github.com/ethereum/rayonism/blob/master/specs/merge.md#assemble-block): Ethereum Specification for block Assembly as part of Rayonism -- The Merge spec.

<a name="ts5">[5]</a> [Prysm running a node](https://docs.prylabs.network/docs/install/install-with-script): Operational procedures for Validators by Prysm. Note validators run both the beacon chain(consensus) and a geth node(execution)

<a name="ts6">[6]</a>[The Beacon Chain Ethereum 2.0 explainer you need to read first](https://ethos.dev/beacon-chain): Detailed walk through og Ethereum 2.0 block production including slots, epochs, validators, commitees and finality.

<a name="ts7">[7]</a> [Etherum 2.0 Validators Overview](https://beaconcha.in/validators): Live Monitoring of Ethreum 2.0 Validators from beachoncha.in

<a name="ts8">[8]</a>[BLS Signatures](https://eth2book.info/bellatrix/part2/building_blocks/signatures/): Detailed walkthrough of BLS Signatures and how they can be used in aggregation.

<a name="ts9">[8]</a>[Attestation Inclusion Lifecycle](https://kb.beaconcha.in/attestation#attestation-inclusion-lifecycle): High Level overview of the attestation life cycle including geeration, propogation, aggregation and inclusion.Attest

<a name="ts10">[ts10]</a> [Beacon Chain Proposal: Sync Comittees](https://notes.ethereum.org/@vbuterin/HF1_proposal#Sync-committees): For each period (~27 hours), 1024 validators are randomly selected to be part of the sync committee during that period. Validators in the sync committee would publish signatures attesting to the current head. These signatures would be broadcasted as part of a LightClientUpdate object that could help light clients find the head, and would be included in the beacon chain to be rewarded.

<a name="ts11">[ts11]</a> [Altair Light Client -- Sync Protocol](https://notes.ethereum.org/@vbuterin/HF1_proposal#Sync-committees): This document suggests a minimal light client design for the beacon chain that uses sync committees.

<a name="ts12">[ts12]</a> [Ethereum Builder Specifications: Honest Validator](https://github.com/ethereum/builder-specs/blob/main/specs/validator.md): explains the way in which a beacon chain validator is expected to use the Builder spec to participate in an external builder network.

<a name="ts13">[ts13]</a> [Flashbots: mev-boost](https://github.com/flashbots/mev-boost): open source middleware run by validators to access a competitive block-building market.

<a name="ts14">[ts14]</a> [A note on Ethereum 2.0 phase 0 validator lifecycle](https://notes.ethereum.org/7CFxjwMgQSWOHIxLgJP2Bw#A-note-on-Ethereum-20-phase-0-validator-lifecycle): describes the concept of validator status epochs and the cases of validator lifecycle in the view of “validator status transition” in phase 0.

**Additional**

## Appendices

### Appendix A: Ethreum 2.0 Technical Deep Dive

#### Block Production

**Process Flow**

- Transactions are placed in [txpool](https://github.com/ethereum/go-ethereum/tree/master/core/txpool)
- The transaction pool is read and [blocks](https://github.com/ethereum/go-ethereum/blob/release/1.9/core/types/block.go#L169) are produced by the [miner](https://github.com/ethereum/go-ethereum/blob/master/miner/miner.go)
- Blocks Headers get forwarded to the Beacon chain once they pass [beacon consensus](https://github.com/ethereum/go-ethereum/blob/master/consensus/beacon/consensus.go)
- The Beacon chain embeds the EthChain Header into a [BeaconBlock](https://github.com/prysmaticlabs/prysm/blob/develop/consensus-types/blocks/types.go#L43)

#### Consensus and Finality

Attestation Process Flow

- Proposing Block
- Signing Blocks
- Aggregated Attestation generation
- Block Proposal and Inclusion of Attestation
- The [SignedBeaconBlock](https://github.com/prysmaticlabs/prysm/blob/develop/consensus-types/blocks/types.go#L72) is added to the chain

Attestations Block(LMD Ghost Vote) and Epoch Checkpoints (FFG Votes)

- The validators in the committee attest to the validity of the block (LMD Ghost Vote)
- The validators in the comittee attest to the first block in the Epoch (FFG Vote)

From [Attestations, ethereum.org](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/attestations)
> Every epoch (6.4 minutes) a validator proposes an attestation to the network. The attestation is for a specific slot in the epoch. The purpose of the attestation is to vote in favor of the validator's view of the chain, in particular the most recent justified block and the first block in the current epoch (known as source and target checkpoints). This information is combined for all participating validators, enabling the network to reach consensus about the state of the blockchain.
>
> The attestation contains the following components:
>
> - aggregation_bits: a bitlist of validators where the position maps to the validator index in their committee; the value (0/1) indicates whether the validator signed the data (i.e. whether they are active and agree with the block proposer)
> - data: details relating to the attestation, as defined below
> - signature: a BLS signature that aggregates the signatures of individual validators
>
> The first task for an attesting validator is to build the data. The data contains the following information:
>
> - slot: The slot number that the attestation refers to
> - index: A number that identifies which committee the validator belongs to in a given slot
> - beacon_block_root: Root hash of the block the validator sees at the head of the chain (the result of applying the fork-choice algorithm)
> - source: Part of the finality vote indicating what the validators see as the most recent justified block
> - target: Part of the finality vote indicating what the validators see as the first block in the current epoch
>
> Once the data is built, the validator can flip the bit in aggregation_bits corresponding to their own validator index from 0 to 1 to show that they participated.
>
> Finally, the validator signs the attestation and broadcasts it to the network.

**Technical Details**

Following is an overview of the state structure and logic for generating committees and aggregating attestations. For data structures, please see [Beacon State Data Structures from Prysm](#beacon-state-data-structures-from-prysm) and [web3signer_types from prysm](#web3signer_types-from-prysm).

[BeaconState](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/state#BeaconState) contains both a [ReadOnlyBeaconState](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/state#ReadOnlyBeaconState) and a [WriteOnlyBeaconState](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/state#WriteOnlyBeaconState) wich contain [ReadOnlyValidators](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/state#ReadOnlyValidators) and [ReadOnlyRandaoMixes](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/state#ReadOnlyRandaoMixes) and [WriteOnlyValidators](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/state#WriteOnlyValidators) and [WriteOnlyRandaoMixes](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/state#WriteOnlyRandaoMixes) respectively.

At the beginning of each epoch [func ProcessRandaoMixesReset](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/epoch#ProcessRandaoMixesReset) processes the final updates to RANDAO mix during epoch processing. This calls [RandaoMix](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#RandaoMix) which returns the randao mix (xor'ed seed) of a given slot. It is used to shuffle validators.

Following are sample mixes generated from [func TestRandaoMix_OK](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/helpers/randao_test.go#L16) by adding the statement `fmt.Printf("mix: %v\n", mix)`

```
mix: [10 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
mix: [40 9 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
mix: [159 134 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
```

The shuffle functions consist of

- [func ShuffleList](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ShuffleList): returns list of shuffled indexes in a pseudorandom permutation `p` of `0...list_size - 1` with “seed“ as entropy. We utilize 'swap or not' shuffling in this implementation; we are allocating the memory with the seed that stays constant between iterations instead of reallocating it each iteration as in the spec. This implementation is based on the original implementation from protolambda, <https://github.com/protolambda/eth2-shuffle>

    Following is an example of a shuffled list generated from [TestShuffleList_OK](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/helpers/shuffle_test.go#L25)

    ```
    list1: [0 1 2 3 4 5 6 7 8 9]
    seed1: [1 128 12 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
    shuffledList1: [0 7 8 6 3 9 4 5 2 1]
    ```

- [func ShuffleIndex](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ShuffledIndex): returns `p(index)` in a pseudorandom permutation `p` of `0...list_size - 1` with “seed“ as entropy. We utilize 'swap or not' shuffling in this implementation; we are allocating the memory with the seed that stays constant between iterations instead of reallocating it each iteration as in the spec. This implementation is based on the original implementation from protolambda, <https://github.com/protolambda/eth2-shuffle>

- [func ShuffleIndices](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ShuffledIndices): ShuffledIndices uses input beacon state and returns the shuffled indices of the input epoch, the shuffled indices then can be used to break up into committees.

Committes are formed using functions from [beacon_comittee.go](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/helpers/beacon_committee.go)

- [func BeaconComittee](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#BeaconCommittee): returns the beacon committee of a given slot and committee index. The validator indices and seed are provided as an argument rather than an imported implementation from the spec definition. Having them as an argument allows for cheaper computation run time. (This is an optomized version of [func BeaconComitteFromState](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#BeaconCommitteeFromState))

    Following is an example of a `beaconComittee` generated by adding the following lines to [TestBeaconCommitteeFromState_UpdateCacheForPreviousEpoch](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/helpers/beacon_committee_test.go#L574):

    ```

 var beaconCommittee []types.ValidatorIndex
 beaconCommittee, err = BeaconCommitteeFromState(context.Background(), state, 1 /*previous epoch*/, 0)
 fmt.Printf("beaconComittee: %+v\n", beaconCommittee)
    ```

    Result

    ```
    beaconComittee: [160 338 313 307 320 324 45 469 196 303 23 14 97 312 126 488]
    ```

- [func CommitteeAssignments](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#CommitteeAssignments): is a map of validator indices pointing to the appropriate committee assignment for the given epoch.
  1. Determine the proposer validator index for each slot.
  2. Compute all committees.
  3. Determine the attesting slot for each committee.
  4. Construct a map of validator indices pointing to the respective committees.

    Following is an example of `commitees` generated by adding the following lines to [TestComputeCommittee_WithoutCache](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/helpers/beacon_committee_test.go#L23)

    ```
    committees, err := computeCommittee(indices, seed, 0, 1 /* Total committee*/)

 fmt.Printf("committees: %+v\n", committees)
    ```

    <details>
    <summary>result</summary>

    ```
    committees: [799 45 913 1 631 654 417 244 1270 918 798 719 426 164 1171 863 848 522 828 359 713 972 284 680 203 832 453 75 979 468 667 540 180 729 1137 156 624 434 655 974 108 321 641 750 1150 356 933 870 650 984 869 95 975 510 563 1002 821 819 599 597 593 635 982 915 693 910 1030 845 461 887 936 354 1075 1253 1238 1011 395 773 670 54 389 765 1183 912 866 1230 1279 521 898 598 1038 814 377 1209 1226 19 1087 775 820 401 640 1028 673 174 493 857 931 288 475 1115 139 429 353 295 412 1136 1166 1191 496 677 1039 629 826 528 769 289 856 147 1227 243 731 297 924 89 644 557 1027 1239 1109 447 323 716 764 669 903 612 350 1046 392 768 1257 1083 216 294 606 971 103 902 1015 801 674 1099 49 484 995 1012 146 879 1156 548 1081 844 873 1246 1107 115 121 1018 387 751 941 1259 183 916 937 71 163 287 706 421 304 247 310 113 1032 776 502 1276 274 1214 418 271 307 1224 332 1222 240 657 1060 479 874 14 1147 627 122 448 1082 458 371 214 64 487 1263 34 172 497 880 555 1091 839 507 530 1170 498 999 727 950 317 1266 423 134 364 1092 1128 155 362 419 1219 1019 379 1163 483 917 318 804 336 985 463 584 210 1255 26 583 850 365 723 433 1073 1141 735 922 1035 893 774 1114 256 358 1044 997 546 679 1024 699 1096 663 1066 499 366 1256 883 566 17 717 393 422 622 795 1181 554 1212 736 1064 106 1050 72 1153 1210 198 943 818 518 309 101 471 0 38 688 107 718 1077 1021 648 1236 891 969 39 481 1159 660 686 450 990 1045 1213 756 900 849 355 119 1135 623 878 44 596 262 553 1013 290 269 691 18 207 454 620 221 983 852 430 843 1272 209 526 1100 865 402 437 278 976 1185 784 128 906 536 608 683 1205 574 1251 562 344 930 440 758 472 239 369 73 1235 478 724 373 399 1142 375 490 966 1203 1093 403 74 65 1247 579 145 1090 143 80 190 187 449 1160 194 959 533 671 442 136 158 665 79 253 226 1076 572 1130 227 909 940 275 43 342 182 126 967 700 267 1070 171 1000 658 876 1120 424 141 1164 328 1277 1220 1245 314 335 886 249 638 836 104 527 1057 1179 1111 551 334 749 754 237 1232 495 549 672 250 547 1132 427 346 935 515 452 184 739 77 689 744 831 281 76 48 2 327 542 351 47 1079 661 585 746 709 260 486 1242 932 303 435 1061 282 1217 390 996 457 470 40 592 785 1065 24 160 991 920 858 978 616 934 586 601 939 730 501 859 482 1207 386 1037 78 1184 947 861 643 231 22 397 1126 1215 265 1145 864 942 809 398 715 890 385 559 232 777 185 410 131 112 192 632 1124 302 1025 904 1047 94 1175 516 474 1122 568 617 894 733 1074 1252 264 263 851 124 1258 1023 1121 283 901 1225 923 464 193 1140 810 604 1108 740 1157 368 853 199 270 8 752 529 973 90 246 896 11 960 6 734 285 299 1042 152 732 965 469 161 609 1234 467 1084 780 1069 466 816 588 50 1194 1127 5 1010 31 712 766 1049 813 157 27 259 1055 343 793 1005 127 558 1036 794 1006 1178 767 1168 537 254 1218 590 361 531 186 567 605 4 255 618 37 1216 1134 337 223 811 962 67 587 1001 1187 842 455 1228 1248 1056 300 613 396 1152 830 329 61 1155 439 1188 807 1182 268 662 1101 1026 82 847 755 757 148 1244 778 664 1059 1197 301 1117 1274 743 840 316 123 634 272 1237 326 1041 1068 372 1003 1190 1243 630 298 215 166 445 513 838 363 1085 854 639 503 129 1029 1196 219 325 1161 70 165 564 1206 111 1078 1233 970 444 12 400 211 742 191 41 760 506 196 988 1173 125 177 420 805 957 862 1088 1144 1267 1265 994 380 1250 505 235 1089 451 120 762 867 1167 117 675 16 711 575 1009 85 577 550 1116 895 438 822 138 308 13 349 233 197 404 142 1123 589 614 251 411 1007 228 151 911 105 1162 738 140 892 1110 607 511 802 580 459 293 619 927 488 378 60 1020 236 212 279 980 322 1052 29 720 173 812 1043 882 797 159 926 1261 58 726 492 494 242 3 725 800 524 1062 1195 504 1016 808 168 436 682 383 952 615 179 57 921 370 394 945 489 1254 154 938 789 1229 339 684 806 525 539 787 1268 698 1008 621 225 408 32 964 357 188 477 114 581 144 745 701 110 391 460 381 181 1231 63 206 1264 480 538 561 591 1113 1202 825 348 704 33 625 783 681 1063 1080 1240 217 28 1176 928 582 914 229 252 1102 552 280 728 594 1017 35 406 137 175 162 1118 176 66 296 837 56 508 786 602 102 443 1095 868 696 899 692 1086 1223 907 834 1241 1172 118 1221 855 266 556 1098 384 948 55 340 178 1249 150 781 642 514 771 291 877 519 100 919 224 376 1125 987 645 1169 305 1133 319 201 611 956 42 189 238 908 703 88 981 954 1139 1174 881 576 1105 1186 1201 414 545 741 407 313 23 653 1051 509 872 195 649 1208 1165 1014 595 222 697 1112 1033 234 748 823 570 476 1198 1180 1154 248 257 905 306 1269 676 116 135 51 208 68 202 646 1177 312 86 388 1200 833 779 791 153 347 230 1158 565 543 261 986 875 1193 415 889 273 20 258 600 860 573 636 149 759 374 1072 1053 610 286 656 1119 1260 500 637 702 97 951 628 170 491 944 747 99 714 1278 721 69 571 83 520 473 569 989 98 245 929 1106 961 431 955 1004 884 998 446 544 949 220 535 1031 311 93 1262 871 763 1273 485 647 352 803 205 652 1034 687 958 888 753 792 456 782 59 462 441 796 708 1192 360 96 1148 678 428 277 1189 1071 633 1151 1103 25 993 835 241 1211 320 968 788 338 925 7 9 668 84 330 204 690 133 405 1094 1138 1097 1275 761 1104 10 897 315 517 694 416 685 560 62 772 382 977 87 651 532 659 827 1204 737 841 331 213 1040 132 846 963 695 130 292 91 1022 324 81 992 1199 770 790 465 523 425 1146 21 1054 815 345 829 666 603 1067 109 167 722 432 1149 953 512 413 707 1058 885 218 626 341 409 824 30 705 1048 578 367 710 946 36 1131 46 200 534 15 92 1129 276 817 169 53 52 541 333 1143 1271]
    ```

    </details>

Attestations are managed using functions from [attestation.go](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/helpers/attestation.go)

- [func ValidateNilAttestation](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ValidateNilAttestation): checks if any composite field of input attestation is nil. Access to these nil fields will result in run time panic, it is recommended to run these checks as first line of defense.
- [func ValidateSlotTargetEpoch](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ValidateSlotTargetEpoch): ValidateSlotTargetEpoch checks if attestation data's epoch matches target checkpoint's epoch. It is recommended to run `ValidateNilAttestation` first to ensure `data.Target` can't be nil.
- [func IsAggregator](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#IsAggregator): IsAggregator returns true if the signature is from the input validator. The committee count is provided as an argument rather than imported implementation from spec. Having committee count as an argument allows cheaper computation at run time.
- [func AggregateSignature](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#AggregateSignature): returns the aggregated signature of the input attestations.

    Spec pseudocode definition:

    ```
    def get_aggregate_signature(attestations: Sequence[Attestation]) -> BLSSignature:
    signatures = [attestation.signature for attestation in attestations]
    return bls.Aggregate(signatures)
    ```

    Following is an example aggregrated signature by adding the following lines to [TestAttestation_AggregateSignature](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/helpers/attestation_test.go#L48)

    ```
    aggSig, err := helpers.AggregateSignature(atts)

 fmt.Printf("aggSig: %+v\n", aggSig)
    ```

    Result

    ```
        aggSig: &{s:0xc0003fe000}
    ```

- [func IsAggregated](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#IsAggregated): IsAggregated returns true if the attestation is an aggregated attestation, false otherwise.

- [func ComputeSubnetForAttestation](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ComputeSubnetForAttestation): returns the subnet for which the provided attestation will be broadcasted to.This differs from the spec definition by instead passing in the active validators indices in the attestation's given epoch.

    Spec pseudocode definition:

    ```
    def compute_subnet_for_attestation(committees_per_slot: uint64, slot: Slot, committee_index: CommitteeIndex) -> uint64:

    """
    Compute the correct subnet for an attestation for Phase 0.
    Note, this mimics expected future behavior where attestations will be mapped to their shard subnet.
    """
    slots_since_epoch_start = uint64(slot % SLOTS_PER_EPOCH)
    committees_since_epoch_start = committees_per_slot * slots_since_epoch_start

    return uint64((committees_since_epoch_start + committee_index) % ATTESTATION_SUBNET_COUNT)
    ```

- [func ComputeSubnetFromCommitteeAndSlot](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ComputeSubnetFromCommitteeAndSlot): is a flattened version of ComputeSubnetForAttestation where we only pass in the relevant fields from the attestation as function arguments.

    Spec pseudocode definition:

    ```
    def compute_subnet_for_attestation(committees_per_slot: uint64, slot: Slot, committee_index: CommitteeIndex) -> uint64:

    """
    Compute the correct subnet for an attestation for Phase 0.
    Note, this mimics expected future behavior where attestations will be mapped to their shard subnet.
    """
    slots_since_epoch_start = uint64(slot % SLOTS_PER_EPOCH)
    committees_since_epoch_start = committees_per_slot * slots_since_epoch_start

    return uint64((committees_since_epoch_start + committee_index) % ATTESTATION_SUBNET_COUNT)
    ```

- [func ValidateAttestationTime](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#ValidateAttestationTime): Validates that the incoming attestation is in the desired time range.
    An attestation is valid only if received within the last ATTESTATION_PROPAGATION_SLOT_RANGE slots.

    Example:

    ```
    ATTESTATION_PROPAGATION_SLOT_RANGE = 5
    clockDisparity = 24 seconds
    current_slot = 100
    invalid_attestation_slot = 92
    invalid_attestation_slot = 103
    valid_attestation_slot = 98
    valid_attestation_slot = 101
    ```

    In the attestation must be within the range of 95 to 102 in the example above.

- [func VerifyCheckpointEpoch](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/helpers#VerifyCheckpointEpoch): VerifyCheckpointEpoch is within current epoch and previous epoch with respect to current time. Returns true if it's within, false if it's not.

*Note: Sample command for running tests in Prysm: `bazel test //beacon-chain/core/helpers:go_default_test --test_output=streamed --test_filter=TestAttestation_AggregateSignature`.*

**Consensus Committee Selection**

- [func ProcessRandoa](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/beacon-chain/core/blocks#ProcessRandao): checks the block proposer's randao commitment and generates a new randao mix to update in the beacon state's latest randao mixes slice.
  - [func randaoSigningData](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/core/blocks/signature.go#L157): retrieves the randao related signing data from the state.
    - [func (b *BeaconState) PubkeyAtIndex(idx types.ValidatorIndex) [fieldparams.BLSPubkeyLength]byte ](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/state/state-native/getters_validator.go#L135): returns the pubkey at the given validator index.

### Appendix B: Additional Light Client Support Documentation

#### Key Concepts

- Syncing to Current state

- Advancing Blocks
- Communication can be either via
  - RPC to the [Eth BEACON Node API](https://ethereum.github.io/beacon-APIs/#/Beacon)
  - [Networking Gossip Topics](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/p2p-interface.md#global-topics)
    - [light_client_finality_update](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/p2p-interface.md#light_client_finality_update): This topic is used to propagate the latest `LightClientFinalityUpdate` to light clients, allowing them to keep track of the latest `finalized_header`.
    - [light_client_optimistic_update](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/p2p-interface.md#light_client_optimistic_update): This topic is used to propagate the latest`LightClientOptimisticUpdate` to light clients, allowing them to keep track of the latest `optimistic_header`.

*Note: Time on Ethereum 2.0 Proof of Stake is divided into slots and epochs. One slot is 12 seconds. One epoch is 6.4 minutes, consisting of 32 slots. One block can be created for each slot.*

#### Altair Light Client -- Sync Protocol

- [Altair Light Client -- Sync Protocol](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md): The beacon chain is designed to be light client friendly for constrained environments to access Ethereum with reasonable safety and liveness.

    Such environments include resource-constrained devices (e.g. phones for trust-minimized wallets)and metered VMs (e.g. blockchain VMs for cross-chain bridges).

    This document suggests a minimal light client design for the beacon chain thatuses sync committees introduced in [this beacon chain extension](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/beacon-chain.md).

    Additional documents describe how the light client sync protocol can be used:
  - [Full node](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/full-node.md)
  - [Light client](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/light-client.md)
  - [Networking](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/p2p-interface.md)

- [Light client sync process](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/light-client.md): explains how light clients MAY obtain light client data to sync with the network.

    1. The light client MUST be configured out-of-band with a spec/preset (including fork schedule), with `genesis_state` (including `genesis_time` and `genesis_validators_root`), and with a trusted block root. The trusted block SHOULD be within the weak subjectivity period, and its root SHOULD be from a finalized `Checkpoint`.
    2. The local clock is initialized based on the configured `genesis_time`, and the current fork digest is determined to browse for and connect to relevant light client data providers.
    3. The light client fetches a [`LightClientBootstrap`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/light-client.md) object for the configured trusted block root. The `bootstrap` object is passed to [`initialize_light_client_store`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#initialize_light_client_store) to obtain a local [`LightClientStore`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#lightclientstore).
    4. The light client tracks the sync committee periods `finalized_period` from `store.finalized_header.slot`, `optimistic_period` from `store.optimistic_header.slot`, and `current_period` from `current_slot` based on the local clock.
        1. When `finalized_period == optimistic_period` and [`is_next_sync_committee_known`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#is_next_sync_committee_known) indicates `False`, the light client fetches a [`LightClientUpdate`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#lightclientupdate) for `finalized_period`. If `finalized_period == current_period`, this fetch SHOULD be scheduled at a random time before `current_period` advances.
        2. When `finalized_period + 1 < current_period`, the light client fetches a `LightClientUpdate` for each sync committee period in range `[finalized_period + 1, current_period)` (current period excluded)
        3. When `finalized_period + 1 >= current_period`, the light client keeps observing [`LightClientFinalityUpdate`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#lightclientfinalityupdate) and [`LightClientOptimisticUpdate`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#lightclientoptimisticupdate). Received objects are passed to [`process_light_client_finality_update`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#process_light_client_finality_update) and [`process_light_client_optimistic_update`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#process_light_client_optimistic_update). This ensures that `finalized_header` and `optimistic_header` reflect the latest blocks.
    5. [`process_light_client_store_force_update`](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md#process_light_client_store_force_update) MAY be called based on use case dependent heuristics if light client sync appears stuck. If available, falling back to an alternative syncing mechanism to cover the affected sync committee period is preferred.

#### The Portal Network

- [The Portal Network](https://github.com/ethereum/portal-network-specs): The Portal Network is an in progess effort to enable lightweight protocol access by resource constrained devices.  The term *"portal"* is used to indicate that these networks provide a *view* into the protocol but are not critical to the operation of the core Ethereum protocol.

    The Portal Network is comprised of multiple peer-to-peer networks which together provide the data and functionality necessary to expose the standard [JSON-RPC API](https://eth.wiki/json-rpc/API).  These networks are specially designed to ensure that clients participating in these networks can do so with minimal expenditure of networking bandwidth, CPU, RAM, and HDD resources.

    The term 'Portal Client' describes a piece of software which participates in these networks. Portal Clients typically expose the standard JSON-RPC API.

  - Motivation: The Portal Network is focused on delivering reliable, lightweight, and decentralized access to the Ethereum protocol.

  - Prior Work on the "Light Ethereum Subprotocol" (LES): The term "light client" has historically refered to a client of the existing [DevP2P](https://github.com/ethereum/devp2p/blob/master/rlpx.md) based [LES](https://github.com/ethereum/devp2p/blob/master/caps/les.md) network.  This network is designed using a client/server architecture.  The LES network has a total capacity dictated by the number of "servers" on the network.  In order for this network to scale, the "server" capacity has to increase.  This also means that at any point in time the network has some total capacity which if exceeded will cause service degradation across the network.  Because of this the LES network is unreliable when operating near capacity.

- Block Relay
  - [Beacon State](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/beacon-state-network.md#dht-overview): A client has a trusted beacon state root, and it wants to access some parts of the state. Each of the access request corresponds to some leave nodes of the beacon state. The request is a content lookup on a DHT. The response is a Merkle proof.

        A Distributed Hash Table (DHT) allows network participants to have retrieve data on-demand based on a content
  - [Syncing Block Headers](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/sync-gossip.md): A beacon chain client could sync committee to perform state updates. The data object LightClientSkipSyncUpdate allows a client to quickly sync to a recent header with the appropriate sync committee. Once the client establishes a recent header, it could sync to other headers by processing LightClientUpdates. These two data types allow a client to stay up-to-date with the beacon chain.
    - [Sync State](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/skip-sync-network.md): A client uses SkipSyncUpdate to skip sync from a known header to a recent header. A client with a trusted but outdated header cannot use the messages in the gossip channel bc-light-client-update to update. The client's sync-committee in the stored snapshot is too old and not connected to any update messages. The client look for the appropriate SkipSyncUpdate to skip sync its header.
    - [Advance Block Headers](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/sync-gossip.md): A beacon chain client could sync committee to perform [state updates](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/sync-protocol.md). The data object [LightClientSkipSyncUpdate](skip-sync-network) allows a client to quickly sync to a recent header with the appropriate sync committee. Once the client establishes a recent header, it could sync to other headers by processing [LightClientUpdates](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/sync-protocol.md#lightclientupdate). These two data types allow a client to stay up-to-date with the beacon chain.

            These two data types are placed into separate sub-networks. A light client make find-content requests on `skip-sync-network` at start of the sync to get a header with the same `SyncCommittee` object as in the current sync period. The client uses messages in the gossip topic `bc-light-client-update` to advance its header.

            The gossip topics described in this document is part of a [proposal](https://ethresear.ch/t/a-beacon-chain-light-client-proposal/11064) for a beacon chain light client.

#### Transaction Proofs

- [Retrieving Beacon State](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/beacon-state-network.md): A client has a trusted beacon state root, and it wants to access some parts of the state. Each of the access request corresponds to some leave nodes of the beacon state. The request is a content lookup on a DHT. The response is a Merkle proof.

    A Distributed Hash Table (DHT) allows network participants to have retrieve data on-demand based on a content key. A portal-network DHT is different than a traditional one in that each participant could selectively limit its workload by choosing a small interest radius r. A participants only process messages that are within its chosen radius boundary.
  - [Wire Protocol](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/beacon-state-network.md#wire-protocol): For a subprotocol, we need to further define the following to be able to instantiate the wire format of each message type.
        1. `content_key`
        2. `content_id`
        3. `payload`

        The content of the message is a Merkle proof contains multiple leave nodes for a [BeaconState](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/beacon-chain.md#beaconstate).

        Finally, we define the necessary encodings. A light client only knows the root of the beacon state. The client wants to know the details of some leave nodes. The client has to be able to construct the `content_key` only knowing the root and which leave nodes it wants see. The `content_key` is the ssz serialization of the paths. The paths represent the part of the beacon state that one wants to know about. The paths are represented by generalized indices. Note that `hash_tree_root` and `serialize` are the same as those defined in [sync-gossip](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/sync-gossip.md).

- TODO: Review of Retrieving a transaction proof not just retrieving data on-demand

#### Further Information

- [Ethereum 2.0 Light Client Support](./ETH2_0.md#ethereum-20-light-client-support)

- Ethereum 2.0 Specifications
  - [Beacon Chain Specification](https://github.com/ethereum/consensus-specs/blob/master/specs/phase0/beacon-chain.md)
  - [Extended light client protocol](https://notes.ethereum.org/@vbuterin/extended_light_client_protocol)
  - [Altair Light Client -- Light Client](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/light-client.md)
  - [Altair Light Client -- Sync Protocol](https://github.com/ethereum/consensus-specs/blob/dev/specs/altair/light-client/sync-protocol.md)
  - [Beacon Chain Fork Choice](https://github.com/ethereum/consensus-specs/blob/dev/specs/phase0/fork-choice.md)
  - [The Portal Network Specification](https://github.com/ethereum/portal-network-specs): an in progess effort to enable lightweight protocol access by resource constrained devices.
- [Light Ethereum Subprotocol (LES)](https://github.com/ethereum/devp2p/blob/master/caps/les.md): the protocol used by "light" clients, which only download block headers as they appear and fetch other parts of the blockchain on-demand.
- [BlockDaemon: Ethereum Altair Hard Folk: Light Clients & Sync Committees](https://blockdaemon.com/blog/ethereum-altair-hard-folk-light-clients-sync-committees/)
- [Efficient algorithms for CBC Casper](https://docs.google.com/presentation/d/1oc_zdywOsHxz3zez1ILAgrerS7RkaF1hHoW0FLtp0Gw/edit#slide=id.p): Review of LMD GHOST (Latest Message Driven, Greediest Heaviest Observed Sub-Tree)
- [SSZ: Simple Serialize](https://ethereum.org/en/developers/docs/data-structures-and-encoding/ssz/): Overview of Simple serialize (SSZ) is the serialization method used on the Beacon Chain. (including merkalization and multiproofs)
- [The Noise Protocol Framework](https://noiseprotocol.org/noise.html): Noise is a framework for crypto protocols based on Diffie-Hellman key agreement.
- [Flashbots for Ethereum Consensus Clients](https://hackmd.io/QoLwVQf3QK6EiVt15YOYqQ?view)
- [Optimistic Sync Specification](https://github.com/ethereum/consensus-specs/blob/dev/sync/optimistic.md): Optimistic Sync is a stop-gap measure to allow execution nodes to sync via established methods until future Ethereum roadmap items are implemented (e.g., statelessness).
- [Consensus Light Client Server Implementation Notes](https://hackmd.io/hsCz1G3BTyiwwJtjT4pe2Q?view): How  Lodestar beacon node was tweaked to serve light clients
- [beacon chain light client design doc](https://notes.ethereum.org/@ralexstokes/HJxDMi8vY): notes about the design/implementation of a beacon chain light client using standard APIs and protocol features
- [A Beacon Chain Light Client Proposal](https://ethresear.ch/t/a-beacon-chain-light-client-proposal/11064): proposing a light client implementation that goes a step further than the minimum light client described in the altair consensus-spec. The proposed client aims to allow queries into the beacon state.
- [Distributed Hash Table (DHT) Overview](https://github.com/ethereum/portal-network-specs/blob/master/beacon-chain/beacon-state-network.md#dht-overview): allows network participants to have retrieve data on-demand based on a content key.
- [(WIP) Light client p2p interface Specification](https://github.com/ethereum/consensus-specs/pull/2786): a PR to get the conversation going about a p2p approach.
Here we cover two approaches which may be combined

### Appendix C: Proving and Verification Mechanisms

#### [eth-proof-of-consensus](https://github.com/succinctlabs/eth-proof-of-consensus): Proof of Consensus for Ethereum by succinctlabs

Circuits

- [aggregate_bls_verify.circom](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/circuits/circuits/aggregate_bls_verify.circom): Computes an aggregate BLS12-381 public key over a set of public keys and a bitmask
- [assert_valid_signed_header.circom](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/circuits/circuits/assert_valid_signed_header.circom)
- [pubkey_poseidon.circom](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/circuits/circuits/pubkey_poseidon.circom): Computes the Poseidon merkle root of a list of field elements
- [sha256_bytes.circom](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/circuits/circuits/sha256_bytes.circom): Wrapper around SHA256 to support bytes as input instead of bits
- [simple_serialize.circom](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/circuits/circuits/simple_serialize.circom): Helper function to implement SSZArray
- [sync_committee_committments.circom](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/circuits/circuits/sync_committee_committments.circom): Asserts that the byte representation of a BLS12-381 public key's x-coordinate matches the BigInt representation

Verification

- [AMB](https://github.com/succinctlabs/eth-proof-of-consensus/tree/main/contracts/src/amb): Arbitrary Message Passing
  - [TrustlessAMB.sol](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/amb/TrustlessAMB.sol): sends and executes messages
  - [TrustlessAMBStorage.sol](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/amb/TrustlessAMBStorage.sol): Storage for messages between two chains
- [bridge](https://github.com/succinctlabs/eth-proof-of-consensus/tree/main/contracts/src/bridge): Allows for the deposit and withdrawal of ERC20 tokens
  - [Bridge.sol](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/bridge/Bridge.sol): Deposit and withdraw functionality
  - [Token.sol](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/bridge/Tokens.sol): ERC20 bridge token definitions
- [lightclient](https://github.com/succinctlabs/eth-proof-of-consensus/tree/main/contracts/src/lightclient)
  - [BLSAggregatedSignatureVerifier.sol](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BLSAggregatedSignatureVerifier.sol): Verifies BLS aggregated signature proofs
  - [BeaconLightClient.sol](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BeaconLightClient.sol): Beacon Light Client Functionality including
    - [step(LightClientUpdate memory update)](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BeaconLightClient.sol#L86): Updates the head given a finalized light client update.
    - [function updateSyncCommittee(LightClientUpdate memory update, bytes32 nextSyncCommitteePoseidon, Groth16Proof memory commitmentMappingProof)](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BeaconLightClient.sol#L102): Set the sync committee validator set root for the next sync commitee period.
    - [function forceUpdate()](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BeaconLightClient.sol#L131): Finalizes the optimistic update and sets the next sync committee if no finalized updates have been received for a period.
    - [function processLightClientUpdate(LightClientUpdate memory update)](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BeaconLightClient.sol#L131): Implements shared logic for processing light client updates.
    - [function zkMapSSZToPoseidon(bytes32 sszCommitment, bytes32 poseidonCommitment, Groth16Proof memory proof)](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BeaconLightClient.sol#L190): Maps a simple serialize merkle root to a poseidon merkle root with a zkSNARK. The proof asserts that: SimpleSerialize(syncCommittee) == Poseidon(syncCommittee).
    - [function zkBLSVerify(bytes32 signingRoot, bytes32 syncCommitteeRoot, uint256 claimedParticipation, Groth16Proof memory proof)](https://github.com/succinctlabs/eth-proof-of-consensus/blob/main/contracts/src/lightclient/BeaconLightClient.sol#L208): Does an aggregated BLS signature verification with a zkSNARK.
  - [scripts](https://github.com/succinctlabs/eth-proof-of-consensus/tree/main/contracts/src/scripts): A collection of [forge-scripts](https://book.getfoundry.sh/reference/forge/forge-script) for contract deployment.

### Appendix D: Topics

Beacon Chain Topics [Prysm](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/p2p/topics.go)

```
package p2p

const (
 // GossipProtocolAndDigest represents the protocol and fork digest prefix in a gossip topic.
 GossipProtocolAndDigest = "/eth2/%x/"

 // Message Types
 //
 // GossipAttestationMessage is the name for the attestation message type. It is
 // specially extracted so as to determine the correct message type from an attestation
 // subnet.
 GossipAttestationMessage = "beacon_attestation"
 // GossipSyncCommitteeMessage is the name for the sync committee message type. It is
 // specially extracted so as to determine the correct message type from a sync committee
 // subnet.
 GossipSyncCommitteeMessage = "sync_committee"
 // GossipBlockMessage is the name for the block message type.
 GossipBlockMessage = "beacon_block"
 // GossipExitMessage is the name for the voluntary exit message type.
 GossipExitMessage = "voluntary_exit"
 // GossipProposerSlashingMessage is the name for the proposer slashing message type.
 GossipProposerSlashingMessage = "proposer_slashing"
 // GossipAttesterSlashingMessage is the name for the attester slashing message type.
 GossipAttesterSlashingMessage = "attester_slashing"
 // GossipAggregateAndProofMessage is the name for the attestation aggregate and proof message type.
 GossipAggregateAndProofMessage = "beacon_aggregate_and_proof"
 // GossipContributionAndProofMessage is the name for the sync contribution and proof message type.
 GossipContributionAndProofMessage = "sync_committee_contribution_and_proof"
 // GossipBlsToExecutionChangeMessage is the name for the bls to execution change message type.
 GossipBlsToExecutionChangeMessage = "bls_to_execution_change"

 // Topic Formats
 //
 // AttestationSubnetTopicFormat is the topic format for the attestation subnet.
 AttestationSubnetTopicFormat = GossipProtocolAndDigest + GossipAttestationMessage + "_%d"
 // SyncCommitteeSubnetTopicFormat is the topic format for the sync committee subnet.
 SyncCommitteeSubnetTopicFormat = GossipProtocolAndDigest + GossipSyncCommitteeMessage + "_%d"
 // BlockSubnetTopicFormat is the topic format for the block subnet.
 BlockSubnetTopicFormat = GossipProtocolAndDigest + GossipBlockMessage
 // ExitSubnetTopicFormat is the topic format for the voluntary exit subnet.
 ExitSubnetTopicFormat = GossipProtocolAndDigest + GossipExitMessage
 // ProposerSlashingSubnetTopicFormat is the topic format for the proposer slashing subnet.
 ProposerSlashingSubnetTopicFormat = GossipProtocolAndDigest + GossipProposerSlashingMessage
 // AttesterSlashingSubnetTopicFormat is the topic format for the attester slashing subnet.
 AttesterSlashingSubnetTopicFormat = GossipProtocolAndDigest + GossipAttesterSlashingMessage
 // AggregateAndProofSubnetTopicFormat is the topic format for the aggregate and proof subnet.
 AggregateAndProofSubnetTopicFormat = GossipProtocolAndDigest + GossipAggregateAndProofMessage
 // SyncContributionAndProofSubnetTopicFormat is the topic format for the sync aggregate and proof subnet.
 SyncContributionAndProofSubnetTopicFormat = GossipProtocolAndDigest + GossipContributionAndProofMessage
 // BlsToExecutionChangeSubnetTopicFormat is the topic format for the bls to execution change subnet.
 BlsToExecutionChangeSubnetTopicFormat = GossipProtocolAndDigest + GossipBlsToExecutionChangeMessage
)
```

### Appendix E: gRPC and API's

[Beaconcha.in ETH2 API](https://beaconcha.in/api/v1/docs/index.html)

### Appendix F: Data Structures

- Block Structure from [go-ethereum](https://github.com/ethereum/go-ethereum/blob/release/1.9/core/types/block.go#L72)

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

- Blocks Headers get forwarded to the Beacon chain once they pass [beacon consensus](https://github.com/ethereum/go-ethereum/blob/master/consensus/beacon/consensus.go)
- The Beacon chain embeds the EthChain Header into a [BeaconBlock](https://github.com/prysmaticlabs/prysm/blob/develop/consensus-types/blocks/types.go#L43)

BeaconBlockBody from [prysm](https://github.com/prysmaticlabs/prysm/blob/develop/consensus-types/blocks/types.go) (golang)

```
// BeaconBlockBody is the main beacon block body structure. It can represent any block type.
type BeaconBlockBody struct {
 version                int
 isBlinded              bool
 randaoReveal           [field_params.BLSSignatureLength]byte
 eth1Data               *eth.Eth1Data
 graffiti               [field_params.RootLength]byte
 proposerSlashings      []*eth.ProposerSlashing
 attesterSlashings      []*eth.AttesterSlashing
 attestations           []*eth.Attestation
 deposits               []*eth.Deposit
 voluntaryExits         []*eth.SignedVoluntaryExit
 syncAggregate          *eth.SyncAggregate
 executionPayload       *engine.ExecutionPayload
 executionPayloadHeader *engine.ExecutionPayloadHeader
}

// BeaconBlock is the main beacon block structure. It can represent any block type.
type BeaconBlock struct {
 version       int
 slot          types.Slot
 proposerIndex types.ValidatorIndex
 parentRoot    [field_params.RootLength]byte
 stateRoot     [field_params.RootLength]byte
 body          *BeaconBlockBody
}

// SignedBeaconBlock is the main signed beacon block structure. It can represent any block type.
type SignedBeaconBlock struct {
 version   int
 block     *BeaconBlock
 signature [field_params.BLSSignatureLength]byte
}
```

Eth1Data from [prysm](https://github.com/prysmaticlabs/prysm/blob/develop/proto/prysm/v1alpha1/powchain.pb.go#L24) (golang)

```
type ETH1ChainData struct {
 state         protoimpl.MessageState
 sizeCache     protoimpl.SizeCache
 unknownFields protoimpl.UnknownFields

 CurrentEth1Data   *LatestETH1Data     `protobuf:"bytes,1,opt,name=current_eth1_data,json=currentEth1Data,proto3" json:"current_eth1_data,omitempty"`
 ChainstartData    *ChainStartData     `protobuf:"bytes,2,opt,name=chainstart_data,json=chainstartData,proto3" json:"chainstart_data,omitempty"`
 BeaconState       *BeaconState        `protobuf:"bytes,3,opt,name=beacon_state,json=beaconState,proto3" json:"beacon_state,omitempty"`
 Trie              *SparseMerkleTrie   `protobuf:"bytes,4,opt,name=trie,proto3" json:"trie,omitempty"`
 DepositContainers []*DepositContainer `protobuf:"bytes,5,rep,name=deposit_containers,json=depositContainers,proto3" json:"deposit_containers,omitempty"`
}

type LatestETH1Data struct {
 state         protoimpl.MessageState
 sizeCache     protoimpl.SizeCache
 unknownFields protoimpl.UnknownFields

 BlockHeight        uint64 `protobuf:"varint,2,opt,name=block_height,json=blockHeight,proto3" json:"block_height,omitempty"`
 BlockTime          uint64 `protobuf:"varint,3,opt,name=block_time,json=blockTime,proto3" json:"block_time,omitempty"`
 BlockHash          []byte `protobuf:"bytes,4,opt,name=block_hash,json=blockHash,proto3" json:"block_hash,omitempty"`
 LastRequestedBlock uint64 `protobuf:"varint,5,opt,name=last_requested_block,json=lastRequestedBlock,proto3" json:"last_requested_block,omitempty"`
}
```

BeaconBlockAltair from [lighthouse](https://github.com/sigp/lighthouse/blob/stable/consensus/types/src/beacon_block.rs#L407) rust

```
    /// Return an Altair block where the block has maximum size.
    pub fn full(spec: &ChainSpec) -> Self {
        let base_block: BeaconBlockBase<_, Payload> = BeaconBlockBase::full(spec);
        let sync_aggregate = SyncAggregate {
            sync_committee_signature: AggregateSignature::empty(),
            sync_committee_bits: BitVector::default(),
        };
        BeaconBlockAltair {
            slot: spec.genesis_slot,
            proposer_index: 0,
            parent_root: Hash256::zero(),
            state_root: Hash256::zero(),
            body: BeaconBlockBodyAltair {
                proposer_slashings: base_block.body.proposer_slashings,
                attester_slashings: base_block.body.attester_slashings,
                attestations: base_block.body.attestations,
                deposits: base_block.body.deposits,
                voluntary_exits: base_block.body.voluntary_exits,
                sync_aggregate,
                randao_reveal: Signature::empty(),
                eth1_data: Eth1Data {
                    deposit_root: Hash256::zero(),
                    block_hash: Hash256::zero(),
                    deposit_count: 0,
                },
                graffiti: Graffiti::default(),
                _phantom: PhantomData,
            },
        }
    }
}
```

#### Beacon State Data Structures from Prysm

```
type BeaconState interface {
 SpecParametersProvider
 ReadOnlyBeaconState
 WriteOnlyBeaconState
 Copy() BeaconState
 HashTreeRoot(ctx context.Context) ([32]byte, error)
 FutureForkStub
 StateProver
}
```

```
type ReadOnlyBeaconState interface {
 ReadOnlyBlockRoots
 ReadOnlyStateRoots
 ReadOnlyRandaoMixes
 ReadOnlyEth1Data
 ReadOnlyValidators
 ReadOnlyBalances
 ReadOnlyCheckpoint
 ReadOnlyAttestations
 ToProtoUnsafe() interface{}
 ToProto() interface{}
 GenesisTime() uint64
 GenesisValidatorsRoot() []byte
 Slot() types.Slot
 Fork() *ethpb.Fork
 LatestBlockHeader() *ethpb.BeaconBlockHeader
 HistoricalRoots() [][]byte
 Slashings() []uint64
 FieldReferencesCount() map[string]uint64
 MarshalSSZ() ([]byte, error)
 IsNil() bool
 Version() int
 LatestExecutionPayloadHeader() (interfaces.ExecutionData, error)
}
```

```
type ReadOnlyValidators interface {
 Validators() []*ethpb.Validator
 ValidatorAtIndex(idx types.ValidatorIndex) (*ethpb.Validator, error)
 ValidatorAtIndexReadOnly(idx types.ValidatorIndex) (ReadOnlyValidator, error)
 ValidatorIndexByPubkey(key [fieldparams.BLSPubkeyLength]byte) (types.ValidatorIndex, bool)
 PubkeyAtIndex(idx types.ValidatorIndex) [fieldparams.BLSPubkeyLength]byte
 NumValidators() int
 ReadFromEveryValidator(f func(idx int, val ReadOnlyValidator) error) error
}
```

```
type ReadOnlyRandaoMixes interface {
 RandaoMixes() [][]byte
 RandaoMixAtIndex(idx uint64) ([]byte, error)
 RandaoMixesLength() int
}
```

```
type WriteOnlyBeaconState interface {
 WriteOnlyBlockRoots
 WriteOnlyStateRoots
 WriteOnlyRandaoMixes
 WriteOnlyEth1Data
 WriteOnlyValidators
 WriteOnlyBalances
 WriteOnlyCheckpoint
 WriteOnlyAttestations
 SetGenesisTime(val uint64) error
 SetGenesisValidatorsRoot(val []byte) error
 SetSlot(val types.Slot) error
 SetFork(val *ethpb.Fork) error
 SetLatestBlockHeader(val *ethpb.BeaconBlockHeader) error
 SetHistoricalRoots(val [][]byte) error
 SetSlashings(val []uint64) error
 UpdateSlashingsAtIndex(idx, val uint64) error
 AppendHistoricalRoots(root [32]byte) error
 SetLatestExecutionPayloadHeader(payload interfaces.ExecutionData) error
 SetWithdrawalQueue(val []*enginev1.Withdrawal) error
 AppendWithdrawal(val *enginev1.Withdrawal) error
 SetNextWithdrawalIndex(i uint64) error
 SetNextPartialWithdrawalValidatorIndex(i types.ValidatorIndex) error
}
```

```
type WriteOnlyValidators interface {
 SetValidators(val []*ethpb.Validator) error
 ApplyToEveryValidator(f func(idx int, val *ethpb.Validator) (bool, *ethpb.Validator, error)) error
 UpdateValidatorAtIndex(idx types.ValidatorIndex, val *ethpb.Validator) error
 AppendValidator(val *ethpb.Validator) error
}
```

```
type WriteOnlyRandaoMixes interface {
 SetRandaoMixes(val [][]byte) error
 UpdateRandaoMixesAtIndex(idx uint64, val []byte) error
}
```

[Validator](https://pkg.go.dev/github.com/prysmaticlabs/prysm/v3@v3.1.2/proto/prysm/v1alpha1#Validator) information

```
type Validator struct {
 PublicKey                  []byte                                                             `protobuf:"bytes,1,opt,name=public_key,json=publicKey,proto3" json:"public_key,omitempty" spec-name:"pubkey" ssz-size:"48"`
 WithdrawalCredentials      []byte                                                             `` /* 138-byte string literal not displayed */
 EffectiveBalance           uint64                                                             `protobuf:"varint,3,opt,name=effective_balance,json=effectiveBalance,proto3" json:"effective_balance,omitempty"`
 Slashed                    bool                                                               `protobuf:"varint,4,opt,name=slashed,proto3" json:"slashed,omitempty"`
 ActivationEligibilityEpoch github_com_prysmaticlabs_prysm_v3_consensus_types_primitives.Epoch `` /* 221-byte string literal not displayed */
 ActivationEpoch            github_com_prysmaticlabs_prysm_v3_consensus_types_primitives.Epoch `` /* 186-byte string literal not displayed */
 ExitEpoch                  github_com_prysmaticlabs_prysm_v3_consensus_types_primitives.Epoch `` /* 168-byte string literal not displayed */
 WithdrawableEpoch          github_com_prysmaticlabs_prysm_v3_consensus_types_primitives.Epoch `` /* 192-byte string literal not displayed */
 // contains filtered or unexported fields
}
```

#### [web3signer_types from prysm](https://github.com/prysmaticlabs/prysm/blob/develop/validator/keymanager/remote-web3signer/v1/web3signer_types.go#L107)

```
////////////////////////////////////////////////////////////////////////////////
// sub properties of Sign Requests /////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// ForkInfo a sub property object of the Sign request
type ForkInfo struct {
 Fork                  *Fork         `json:"fork"`
 GenesisValidatorsRoot hexutil.Bytes `json:"genesis_validators_root"`
}

// Fork a sub property of ForkInfo.
type Fork struct {
 PreviousVersion hexutil.Bytes `json:"previous_version"`
 CurrentVersion  hexutil.Bytes `json:"current_version"`
 Epoch           string        `json:"epoch"` /*uint64*/
}

// AggregationSlot a sub property of AggregationSlotSignRequest.
type AggregationSlot struct {
 Slot string `json:"slot"`
}

// AggregateAndProof a sub property of AggregateAndProofSignRequest.
type AggregateAndProof struct {
 AggregatorIndex string        `json:"aggregator_index"` /* uint64 */
 Aggregate       *Attestation  `json:"aggregate"`
 SelectionProof  hexutil.Bytes `json:"selection_proof"` /* 96 bytes */
}

// Attestation a sub property of AggregateAndProofSignRequest.
type Attestation struct {
 AggregationBits hexutil.Bytes    `json:"aggregation_bits"` /*hex bitlist*/
 Data            *AttestationData `json:"data"`
 Signature       hexutil.Bytes    `json:"signature"`
}

// AttestationData a sub property of Attestation.
type AttestationData struct {
 Slot            string        `json:"slot"`  /* uint64 */
 Index           string        `json:"index"` /* uint64 */ // Prysm uses CommitteeIndex but web3signer uses index.
 BeaconBlockRoot hexutil.Bytes `json:"beacon_block_root"`
 Source          *Checkpoint   `json:"source"`
 Target          *Checkpoint   `json:"target"`
}

// Checkpoint a sub property of AttestationData.
type Checkpoint struct {
 Epoch string `json:"epoch"`
 Root  string `json:"root"`
}
```

[attestation.proto from prysm (Message Structure)](https://github.com/prysmaticlabs/prysm/blob/develop/proto/prysm/v1alpha1/attestation.proto)

```
message AttestationData {
    // Attestation data includes information on Casper the Friendly Finality Gadget's votes
    // See: https://arxiv.org/pdf/1710.09437.pdf

    // Slot of the attestation attesting for.
    uint64 slot = 1 [(ethereum.eth.ext.cast_type) = "github.com/prysmaticlabs/prysm/v3/consensus-types/primitives.Slot"];

    // The committee index that submitted this attestation.
    uint64 committee_index = 2  [(ethereum.eth.ext.cast_type) = "github.com/prysmaticlabs/prysm/v3/consensus-types/primitives.CommitteeIndex"];

    // 32 byte root of the LMD GHOST block vote.
    bytes beacon_block_root = 3 [(ethereum.eth.ext.ssz_size) = "32"];

    // The most recent justified checkpoint in the beacon state
    Checkpoint source = 4;

    // The checkpoint attempting to be justified for the current epoch and its epoch boundary block
    Checkpoint target = 5;
}
```

### Appendix G: Sample Data

#### Epoch Data for 167040

Following is the Epoch Data for  167040
It can be retrieved from [here](https://beaconcha.in/api/v1/docs/index.html#/Epoch/get_api_v1_epoch__epoch_) or by using this curl command

`curl -X 'GET' \
  'https://beaconcha.in/api/v1/epoch/167040' \
  -H 'accept: application/json'`

Response

```
{
  "status": "OK",
  "data": {
    "attestationscount": 3457,
    "attesterslashingscount": 0,
    "averagevalidatorbalance": 33899775551,
    "blockscount": 32,
    "depositscount": 0,
    "eligibleether": 15596542000000000,
    "epoch": 167040,
    "finalized": true,
    "globalparticipationrate": 0.9963188171386719,
    "missedblocks": 0,
    "orphanedblocks": 0,
    "proposedblocks": 32,
    "proposerslashingscount": 0,
    "scheduledblocks": 0,
    "totalvalidatorbalance": 16522615004645864,
    "validatorscount": 487396,
    "voluntaryexitscount": 0,
    "votedether": 15539128000000000
  }
}
```

#### Block Data for Slot 5,330,592

Following is the Block Data for Slot 5,330,592
It can be retrieved from [here](https://beaconcha.in/api/v1/docs/index.html#/Block/get_api_v1_block__slotOrHash_) or by using this curl command

`curl -X 'GET' 'https://beaconcha.in/api/v1/block/5330592' -H 'accept: application/json'`

Response

```
{
  "status": "OK",
  "data": {
    "attestationscount": 126,
    "attesterslashingscount": 0,
    "blockroot": "0xaebe891086c79ab79b325f474dc1150f1223e567337bff815cc318f14c64c233",
    "depositscount": 0,
    "epoch": 166581,
    "eth1data_blockhash": "0xd346f84ffe7c600b7714d6411c8bea988d9d64dbdb432f26db58e72946337954",
    "eth1data_depositcount": 498785,
    "eth1data_depositroot": "0x9a5603a34aa60f299384679bf4bfc267e99b68278a81f343bde8cb5650bf1d60",
    "exec_base_fee_per_gas": 12376913565,
    "exec_block_hash": "0x26239efe09f51b24bdf7c518b1aa925a3b0b6453682408ec8a5c906d5038a6e7",
    "exec_block_number": 16163905,
    "exec_extra_data": "0x496c6c756d696e61746520446d6f63726174697a6520447374726962757465",
    "exec_fee_recipient": "0xdafea492d9c6733ae3d56b7ed1adb60692c98bc5",
    "exec_gas_limit": 30000000,
    "exec_gas_used": 9901267,
    "exec_logs_bloom": "0x8c21554815843b4084a999b2901917a52c58004a82a8440d94919a77f9241181388a0c404f000a8c0321ab024800bf899610e60ec801fb4b0352e34f147626192648619065381ded6b9d92bcd0861120adc1ec01064e7a016ea91c478d01b81316462d2d622a60010bc0139f6fb8ccf200499c0e211a85c042047d1601aa0c2ea2833902a2a3091528492dad09f6dc064529c455d328413b78c680c4699815ac9a91610f19e66542edca45a10518ee65b02cf02241a124232d5958b6004cd0a5846c5703d00b5e4d8353221015f7d38c1429074e34aaa11f3804f933082860c401152088251479918297a1a9237d9ac35539f6d069cca07a005819494a653913",
    "exec_parent_hash": "0x06746d5ff105e96a1b8961c2490c0261b474604fbcbf934e86295c0030e26ce2",
    "exec_random": "0xc2861c72cf4d34b37ec73519dbc20b690742b5cc119ed3738f1dd67d8ca52723",
    "exec_receipts_root": "0x33cdf5c6e03dd341f282d02d3c354c2361a6212692b2a3c06b520397045313f4",
    "exec_state_root": "0x517304bade8d83337c9a52f8ceeb13f924b64486b3b8033f7c348c176922104a",
    "exec_timestamp": 1670791127,
    "exec_transactions_count": 139,
    "graffiti": "0x0000000000000000000000000000000000000000000000000000000000000000",
    "graffiti_text": "",
    "parentroot": "0x0cab36616bbcbbc67c343ddce00241c27d0df2c367c5fa82fc7c0fdf0ed37405",
    "proposer": 4345,
    "proposerslashingscount": 0,
    "randaoreveal": "0x83950cb64781aff91f4bd14aa6abb0f5fdb7e08e4e81c264f0754c93d7672c4a9615de196491fdb53eafdeb8f49e9cf515f1bd3dc05bb5dc0e2dd8bff5a8d783b503e3385e80b61485f0ddac1caa9361132a863db84e7e234df5815e6908e4e7",
    "signature": "0x84865a9480ae6313b0e5fcadfa294b35f5963e06c66ad1c7613dc081e9700c07f82a2583ba4b62b2483b4a1b9d49aafe0690f22fcf4d0072f9f44a5ce3067ef4fda560d171001cc6bf5dc84e09d9055d92894b86b27695c297f25530cd8db7a0",
    "slot": 5330592,
    "stateroot": "0x9e7e40d844c3b229cd9497d662a6d94276d285945073849995aba93c7e73cfe7",
    "status": "1",
    "syncaggregate_bits": "0xdffffffffffffffffffffffffffffff7fffffffffffffffffffffffffffffffffffffffffffffffffffffffdfffffffffffffffdffffffffffffffffffffffff",
    "syncaggregate_participation": 0.9921875,
    "syncaggregate_signature": "0x95332c55790018eed3d17eada01cb4045348d09137505bc8697eeedaa3800a830ee2c138251850a9577f62a5488419ef0a722579156a177fb3a147017f1077af5d778f46a4cdf815fc450129d135fe5286e16df68333592e4aa45821bde780dd",
    "voluntaryexitscount": 0,
    "votes": 19227
  }
}
```

#### Execution Block for 16163905

Following is the execution block data for 16163905
It can be retrieved from [here](https://beaconcha.in/api/v1/docs/index.html#/Execution/get_api_v1_execution_block__blockNumber_) or by using this curl command

`curl -X 'GET' 'https://beaconcha.in/api/v1/execution/block/16163905'  -H 'accept: application/json'`

Result

```
{
  "status": "OK",
  "data": [
    {
      "blockHash": "0x26239efe09f51b24bdf7c518b1aa925a3b0b6453682408ec8a5c906d5038a6e7",
      "blockNumber": 16163905,
      "timestamp": 1670791127,
      "blockReward": 37343826945103810,
      "blockMevReward": 37083911760238810,
      "producerReward": 37083911760238810,
      "feeRecipient": "0xdafea492d9c6733ae3d56b7ed1adb60692c98bc5",
      "gasLimit": 30000000,
      "gasUsed": 9901267,
      "baseFee": 12376913565,
      "txCount": 139,
      "internalTxCount": 54,
      "uncleCount": 0,
      "parentHash": "0x06746d5ff105e96a1b8961c2490c0261b474604fbcbf934e86295c0030e26ce2",
      "uncleHash": "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347",
      "difficulty": 0,
      "posConsensus": {
        "executionBlockNumber": 16163905,
        "proposerIndex": 4345,
        "slot": 5330592,
        "epoch": 166581,
        "finalized": true
      },
      "relay": {
        "tag": "flashbots-relay",
        "builderPubkey": "0x81beef03aafd3dd33ffd7deb337407142c80fea2690e5b3190cfc01bde5753f28982a7857c96172a75a234cb7bcb994f",
        "producerFeeRecipient": "0x60987e0d8b5e0095869ca6f0e642828e3f258bb5"
      },
      "consensusAlgorithm": "pos"
    }
  ]
}
```

#### Sync Committee (latest)

Following is a sample Sync Committee
It can be retrieved from [here](https://beaconcha.in/api/v1/docs/index.html#/SyncCommittee/get_api_v1_sync_committee__period_) or by using this curl command

`curl -X 'GET' 'https://beaconcha.in/api/v1/sync_committee/latest' -H 'accept: application/json'`

Abbrieviated Result

```
{
  "status": "OK",
  "data": {
    "end_epoch": 167167,
    "period": 652,
    "start_epoch": 166912,
    "validators": [
      328781,
      184949,
      ...
    ]
  }
}
```

<details>
<summary>Full Result</summary>

```
{
  "status": "OK",
  "data": {
    "end_epoch": 167167,
    "period": 652,
    "start_epoch": 166912,
    "validators": [
      328781,
      184949,
      269719,
      484753,
      447707,
      190522,
      222987,
      429436,
      23553,
      353182,
      394935,
      347121,
      3941,
      77287,
      390407,
      41282,
      440380,
      477794,
      13208,
      321552,
      338223,
      414921,
      77542,
      57797,
      471002,
      238719,
      87491,
      85099,
      16484,
      220174,
      256680,
      194973,
      77409,
      150279,
      322042,
      275140,
      393620,
      21206,
      59424,
      308071,
      20736,
      173428,
      365316,
      293687,
      136783,
      459882,
      9048,
      128613,
      132177,
      267018,
      290896,
      236936,
      406218,
      380040,
      481667,
      34410,
      413701,
      158755,
      222721,
      295335,
      106306,
      426104,
      229412,
      377442,
      300381,
      251157,
      2301,
      255801,
      160943,
      417370,
      290905,
      435535,
      164094,
      204304,
      258455,
      366943,
      119808,
      311117,
      79552,
      164660,
      446993,
      347592,
      256827,
      244517,
      277343,
      303208,
      425967,
      216346,
      13359,
      481813,
      142254,
      105339,
      465226,
      200109,
      198691,
      43343,
      32947,
      392889,
      304855,
      452188,
      148690,
      441869,
      15210,
      216221,
      33338,
      124091,
      299153,
      305746,
      230810,
      484937,
      464816,
      474017,
      307185,
      370171,
      430926,
      21371,
      7607,
      209940,
      439052,
      398079,
      238559,
      108372,
      127122,
      62084,
      5906,
      278678,
      404838,
      253340,
      146867,
      437165,
      470827,
      252487,
      430474,
      433777,
      282060,
      221522,
      273826,
      56274,
      359184,
      401626,
      43613,
      287311,
      465536,
      301609,
      21832,
      192551,
      412598,
      186526,
      447005,
      112768,
      404399,
      289582,
      290124,
      191275,
      213003,
      39276,
      200971,
      315798,
      135302,
      121320,
      227480,
      156978,
      98919,
      201671,
      195988,
      186622,
      475967,
      314720,
      58582,
      404742,
      215008,
      306959,
      267381,
      126574,
      73725,
      156317,
      83010,
      375189,
      167000,
      459137,
      294856,
      144931,
      234176,
      371047,
      446790,
      219650,
      26577,
      64091,
      482916,
      203241,
      306809,
      178005,
      380280,
      452614,
      266272,
      264801,
      428464,
      342535,
      310436,
      297012,
      173959,
      384721,
      311372,
      375367,
      304633,
      247177,
      373217,
      43689,
      363227,
      447608,
      203474,
      186229,
      63975,
      189189,
      391682,
      197510,
      423160,
      168160,
      336488,
      11240,
      86706,
      316746,
      272065,
      50516,
      411785,
      25826,
      212663,
      233378,
      186547,
      268142,
      387972,
      275194,
      134600,
      337298,
      51510,
      206067,
      111837,
      461165,
      137209,
      317427,
      153989,
      464678,
      975,
      384374,
      433258,
      62611,
      413087,
      424810,
      449054,
      190150,
      310602,
      336220,
      71740,
      230657,
      453370,
      468144,
      322259,
      283775,
      1606,
      139348,
      352593,
      356482,
      156500,
      157489,
      454159,
      337203,
      63370,
      369541,
      170461,
      99771,
      398154,
      126177,
      281482,
      24217,
      234556,
      251792,
      201614,
      249765,
      130900,
      409074,
      46296,
      172953,
      194464,
      229313,
      120835,
      141417,
      187795,
      169516,
      352531,
      402467,
      433379,
      73331,
      345245,
      167093,
      176171,
      198482,
      486643,
      456439,
      449333,
      221367,
      481580,
      200704,
      197099,
      314035,
      336100,
      146714,
      415630,
      47127,
      287953,
      153548,
      438248,
      2664,
      325723,
      467719,
      408858,
      82963,
      180891,
      192679,
      86617,
      100068,
      2394,
      11764,
      48047,
      127406,
      149052,
      283994,
      342457,
      463547,
      320210,
      293252,
      6540,
      464926,
      265551,
      109109,
      164735,
      381110,
      29080,
      246178,
      355576,
      448267,
      430466,
      444401,
      126905,
      414347,
      451523,
      331926,
      366508,
      480803,
      387850,
      413867,
      17772,
      268744,
      427797,
      163955,
      333814,
      93663,
      338046,
      236013,
      180066,
      68685,
      466537,
      3904,
      277412,
      449845,
      16633,
      62120,
      108501,
      486885,
      60466,
      380719,
      269930,
      365432,
      377380,
      260009,
      300616,
      203897,
      289145,
      249814,
      26558,
      343110,
      48226,
      365643,
      401664,
      7355,
      350107,
      100836,
      99073,
      294093,
      7587,
      169932,
      166154,
      396054,
      108167,
      229069,
      307648,
      148531,
      233563,
      40093,
      44708,
      353913,
      456080,
      176129,
      156427,
      412072,
      154317,
      271015,
      126289,
      345876,
      156388,
      195860,
      25422,
      482057,
      362295,
      466187,
      115725,
      387438,
      170886,
      224753,
      126768,
      421612,
      96187,
      9314,
      194598,
      297360,
      121794,
      422582,
      428474,
      281996,
      211966,
      303980,
      232330,
      314475,
      485,
      146262,
      8780,
      459648,
      88780,
      371355,
      283376,
      480636,
      67695,
      153169,
      205011,
      52231,
      103646,
      432471,
      433747,
      16092,
      78487,
      165644,
      412660,
      451750,
      8088,
      185452,
      192135,
      355751,
      59734,
      341708,
      347491,
      466763,
      446951,
      670,
      392454,
      39840,
      469691,
      329363,
      61899,
      384770,
      317497,
      282776,
      211703,
      427937,
      284122,
      238949,
      417486,
      341081,
      241572,
      67225,
      294159,
      302865,
      227806,
      123006,
      329514,
      449279,
      31448,
      450144,
      485006,
      199737,
      253646,
      117814,
      408604,
      141399,
      121937,
      237632,
      315197,
      10397,
      318494,
      221051,
      444960,
      417643,
      90991,
      153828,
      291638,
      96654,
      280019,
      218632,
      74162,
      119769,
      20024,
      420771,
      219118,
      96325
    ]
  }
}

```

</details>

### Appendix H: Sync Committe Creation and Retrieval

**Sync Committee Configuration**

`EPOCHS_PER_SYNC_COMMITTEE_PERIOD` is set in [config.go](https://github.com/prysmaticlabs/prysm/blob/develop/config/params/config.go#L185) currently 255 epochs per synch comittee (approx 27 hrs) for Ethreum Mainnet.

**Sync Committee Update Process**

- [beacon-chain/blockchain](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/blockchain)
  - [process_block.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/blockchain/process_block.go): has function `onBlock` which is called when a gossip block is received. It also has function `handleEpochBoundary` which calls `ProcessSlots` in [beacon-chain/core/transition](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/core/transition) and calls function `UpdateCommitteeCache` in [beacon-chain/core/helpers](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/core/helpers)
- [beacon-chain/core/transition](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/core/transition)
  - [transition.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/transition/transition.go): implements the whole state transition function which consists of per slot, per-epoch transitions. function `ProcessSlots` calls `ProcessEpoch` in [beacon-chain/core/altair/transition.go]((<https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/altair/transition.go>))
- [beacon-chain/core/altair](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/core/altair)
  - [transition.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/altair/transition.go): includes function `ProcessEpoch` which calls `ProcessSyncCommitteeUpdates` in [epoch_spec.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/altair/epoch_spec.go)
  - [epoch_spec.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/altair/epoch_spec.go): includes function `ProcessSyncCommitteeUpdates` which calls `NextSyncCommittee` it also persists beacon state syncCommittee by calling `beaconState.SetNextSyncCommittee(nextSyncCommittee)` in [setters_sync_committee.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/state/state-native/setters_sync_committee.go)
  - [sync_committee.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/altair/sync_committee.go): includes function `NextSyncCommittee` which calls `NextSyncCommittee` to return the sync committee indices, with possible duplicates, for the next sync committee.
  - [block.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/altair/block.go): includes  function `VerifySyncCommitteeSig`
- [beacon-chain/core/helpers](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/core/helpers)
  - [beacon_committee.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/core/helpers/beacon_committee.go) has function `UpdateCommitteeCache` which gets called at the beginning of every epoch to cache the committee shuffled indices list with committee index and epoch number. It caches the shuffled indices for current epoch and next epoch. it calls `UpdatePositionsInCommittee` in [sync_committee.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/cache/sync_committee.go)
- [beacon-chain/cache](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/cache)
  - [sync_committee.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/cache/sync_committee.go): has function `UpdatePositionsInCommittee`  which updates caching of validators position in sync committee in respect to current epoch and next epoch. This should be called when `current_sync_committee` and `next_sync_committee` change and that happens every `EPOCHS_PER_SYNC_COMMITTEE_PERIOD`.

**Sync Committee Retrieval**
gRPC and API methods

- [beacon-chain/rpc](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/rpc)
  - [prysm/v1alpha1](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/rpc/prysm/v1alpha1)
    - [validator](https://github.com/prysmaticlabs/prysm/tree/develop/beacon-chain/rpc/prysm/v1alpha1/validator)
      - [assignments.go](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/rpc/prysm/v1alpha1/validator/assignments.go): has functions `GetDuties` and `StreamDuties` which calls function `duties` to compute the validator duties from the head state's corresponding epoch for validators public key / indices requested.

which [manages sync committee duties](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/rpc/prysm/v1alpha1/validator/assignments.go#L213) every `EPOCHS_PER_SYNC_COMMITTEE_PERIOD - 1` which is set in [config.go](https://github.com/prysmaticlabs/prysm/blob/develop/config/params/config.go#L185) currently 255 epochs per synch comittee (approx 27 hrs) for Ethreum Mainnet.

[registerSyncSubnetNextPeriod](https://github.com/prysmaticlabs/prysm/blob/develop/beacon-chain/rpc/prysm/v1alpha1/validator/assignments.go#L281)  

```
func registerSyncSubnetNextPeriod(s beaconState.BeaconState, epoch types.Epoch, pubKey []byte, status ethpb.ValidatorStatus) error {
 committee, err := s.NextSyncCommittee()
 if err != nil {
  return err
 }
 syncCommPeriod := slots.SyncCommitteePeriod(epoch)
 registerSyncSubnet(epoch, syncCommPeriod+1, pubKey, committee, status)
 return nil
}
```

**Sync Committee Storage**

Persistence Mechanism

- [proto](https://github.com/prysmaticlabs/prysm/tree/develop/proto)
  - [eth/v2](https://github.com/prysmaticlabs/prysm/tree/develop/proto/eth/v2)
    - [validator.proto](https://github.com/prysmaticlabs/prysm/blob/develop/proto/eth/v2/validator.proto): messages for validators including `SyncCommitteeDuty`
    - [sync_committee.proto](https://github.com/prysmaticlabs/prysm/blob/develop/proto/eth/v2/sync_committee.proto): messages for SyncCommittee which serves as committees to facilitate light client syncing to beacon chain.

[beacon_state_mainnet.go](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/state/state-native/beacon_state_mainnet.go)

```
// BeaconState defines a struct containing utilities for the Ethereum Beacon Chain state, defining
// getters and setters for its respective values and helpful functions such as HashTreeRoot().
type BeaconState struct {
 version                             int
 genesisTime                         uint64
 genesisValidatorsRoot               [32]byte
 slot                                eth2types.Slot
 fork                                *ethpb.Fork
 latestBlockHeader                   *ethpb.BeaconBlockHeader
 blockRoots                          *customtypes.BlockRoots
 stateRoots                          *customtypes.StateRoots
 historicalRoots                     customtypes.HistoricalRoots
 eth1Data                            *ethpb.Eth1Data
 eth1DataVotes                       []*ethpb.Eth1Data
 eth1DepositIndex                    uint64
 validators                          []*ethpb.Validator
 balances                            []uint64
 randaoMixes                         *customtypes.RandaoMixes
 slashings                           []uint64
 previousEpochAttestations           []*ethpb.PendingAttestation
 currentEpochAttestations            []*ethpb.PendingAttestation
 previousEpochParticipation          []byte
 currentEpochParticipation           []byte
 justificationBits                   bitfield.Bitvector4
 previousJustifiedCheckpoint         *ethpb.Checkpoint
 currentJustifiedCheckpoint          *ethpb.Checkpoint
 finalizedCheckpoint                 *ethpb.Checkpoint
 inactivityScores                    []uint64
 currentSyncCommittee                *ethpb.SyncCommittee
 nextSyncCommittee                   *ethpb.SyncCommittee
 latestExecutionPayloadHeader        *enginev1.ExecutionPayloadHeader
 latestExecutionPayloadHeaderCapella *enginev1.ExecutionPayloadHeaderCapella
 nextWithdrawalIndex                 uint64
 nextWithdrawalValidatorIndex        eth2types.ValidatorIndex

 lock                  sync.RWMutex
 dirtyFields           map[nativetypes.FieldIndex]bool
 dirtyIndices          map[nativetypes.FieldIndex][]uint64
 stateFieldLeaves      map[nativetypes.FieldIndex]*fieldtrie.FieldTrie
 rebuildTrie           map[nativetypes.FieldIndex]bool
 valMapHandler         *stateutil.ValidatorMapHandler
 merkleLayers          [][][]byte
 sharedFieldReferences map[nativetypes.FieldIndex]*stateutil.Reference
}
```

[beacon_state.pb.go](https://github.com/prysmaticlabs/prysm/blob/develop/proto/prysm/v1alpha1/beacon_state.pb.go#L962)

```
type SyncCommittee struct {
 state         protoimpl.MessageState
 sizeCache     protoimpl.SizeCache
 unknownFields protoimpl.UnknownFields

 Pubkeys         [][]byte `protobuf:"bytes,1,rep,name=pubkeys,proto3" json:"pubkeys,omitempty" ssz-size:"512,48"`
 AggregatePubkey []byte   `protobuf:"bytes,2,opt,name=aggregate_pubkey,json=aggregatePubkey,proto3" json:"aggregate_pubkey,omitempty" ssz-size:"48"`
}
```

[Interfaces](https://github.com/prysmaticlabs/prysm/blob/v3.1.2/beacon-chain/state/interfaces.go)

```
// BeaconState has read and write access to beacon state methods.
type BeaconState interface {
 SpecParametersProvider
 ReadOnlyBeaconState
 ReadOnlyWithdrawals
 WriteOnlyBeaconState
 Copy() BeaconState
 HashTreeRoot(ctx context.Context) ([32]byte, error)
 FutureForkStub
 StateProver
}
```

```
// StateProver defines the ability to create Merkle proofs for beacon state fields.
type StateProver interface {
 FinalizedRootProof(ctx context.Context) ([][]byte, error)
 CurrentSyncCommitteeProof(ctx context.Context) ([][]byte, error)
 NextSyncCommitteeProof(ctx context.Context) ([][]byte, error)
}
```
