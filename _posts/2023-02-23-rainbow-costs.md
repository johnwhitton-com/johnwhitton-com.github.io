---
title: "Ethereum Bridging using Light Clients - Rainbow Costing"
excerpt: "A review of how Bridging costs can be reduced using light clients. Taking the near Rainbow Bridge as an example."
date: 2022-02-23
author: John Whitton
contributors: Thanks to Aaron Li for their helpful suggestions.
redirect_from:
--- 

## Table of Content

- [Table of Content](#table-of-content)
- [Introduction](#introduction)
- [Bridge Transaction Walk Through](#bridge-transaction-walk-through)
  - [Actors](#actors)
  - [Sample TransactionFlow](#sample-transactionflow)
- [Bridging Resources Required](#bridging-resources-required)
  - [References](#references)

## Introduction

In this article we review the use of light clients and how they can improve trust and costing for bridges.

## Bridge Transaction Walk Through

Following is a walkthough of a funds transfer from Ethereum to a target chain (In this example Near), complete with light client updates, block propogation and proofs to ensure the transaction validity.

![Ethereum to Near Funds Transfer](/assets/posts/2023-03-23-rainbow-costs/eth2NearFundsTransfer.jpg "Ethereum to NEAR Funds Transfer")

### Actors

From the diagram above you'll notice that there are many actors involved, below is an overview of the actors and the operations they perform.

- Accounts
  - [User Account](https://etherscan.io/address/0x29da2ef94deeaf2d2f9003e9354abfcb1ff04b32) : The user is the owner of the funds being transferred and is responsible for signing the transactions to authorize bridging them accross chains. In this example they have accounts on [Ethereum](https://etherscan.io/address/0x29da2ef94deeaf2d2f9003e9354abfcb1ff04b32) and [NEAR](https://nearblocks.io/address/johnrubini.near#tokentxns)
  - [Target Chain Relayer Acccount](https://nearblocks.io/address/relayer.bridge.near): The relayer account is responsible for relaying messages from Ethereum to the target chain. *Note this is connected to a relayer which is responsible for tasks such as querying latest block headers and getting light client status updates. Source code is [here](https://github.com/aurora-is-near/rainbow-bridge/tree/master/eth2near/eth2near-block-relay-rs).
  - [Target Chain Bridge Validator Accounts](https://nearblocks.io/address/bridge-validator1.near): are responsible for validating light client update proposals and sending approval votes to [DAO Eth Client Contract](https://nearblocks.io/address/bridge-validator.sputnik-dao.near).
- Ethereum Components
  - [ERC20 Token Contract](https://etherscan.io/address/0xdac17f958d2ee523a2206206994597c13d831ec7#code): this is the token contract securing the funds in this examle USDT (Tether). Source code is [here](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.8/contracts/token/ERC20/presets/ERC20PresetMinterPauser.sol)
  - [Bridge Contract](https://etherscan.io/address/0x23ddd3e3692d1861ed57ede224608875809e127f#code): Responsible for deposits and withdrawals of tokens on Ethereum as well as various proving and propogation mechanisms such as checking of Signatures and adding Light Client Blocks. Source code is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/eth/nearbridge/contracts/NearBridge.sol)
- Target Chain (NEAR) Components
  - [Validator DAO Contract](https://nearblocks.io/address/bridge-validator.sputnik-dao.near): Responsible for receivng light client update proposals from the relayer and gathering approval votes for these propoals from Validators and submitting light client updates once the proposal is approved by the Validators. Source code is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/eth2near/contract_wrapper/src/dao_eth_client_contract.rs)
  - [Etherum 2 Client](https://nearblocks.io/address/client-eth2.bridge.near): The Ethereum 2 client is responsbile for processing light client updates and receiving execution header blocks from Ethereum via the relayer. Source code is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/near/eth2-client/src/lib.rs). *Note: this replaced the [Ethereum 1 client](https://nearblocks.io/address/client.bridge.near) source code [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/near/eth-client/src/lib.rs)*
  - [Ethereum Prover](https://nearblocks.io/address/prover.bridge.near) : The Ethereum Prover is used to prove transactions are included in a valid block Header. Source code is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/near/eth-prover/src/lib.rs)
  - [Bridge Contract](https://nearblocks.io/address/factory.bridge.near#contract): The Bridge contract is responsible for managing tokens including creating new tokens, setting metadata and depositing and withdrawal of tokens. Source code is [here](https://github.com/aurora-is-near/rainbow-token-connector/blob/master/bridge-token-factory/src/lib.rs).
    - [NEAR Token Contract](https://nearblocks.io/token/dac17f958d2ee523a2206206994597c13d831ec7.factory.bridge.near?a=dac17f958d2ee523a2206206994597c13d831ec7.factory.bridge.near): The target chain representation of the token (USDT) managed by the target chain bridge contract.

### Sample TransactionFlow

1. Block Propogation
   1. Get the Latest Slot: The relayer loops polling Ethereum every 12 seconds to get the latest slot. It then checks if it is for a new epoch and if so (every 6 minutes) submits an execution header (with 32 blocks in it) and a light client update with the latest approved epochs and updated sync_comittee. Relayer source code for the loop is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/eth2near/eth2near-block-relay-rs/src/eth2near_relay.rs#L258) for retrieving the latest slot is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/eth2near/eth2near-block-relay-rs/src/eth2near_relay.rs#L163), for  submitting execution blocks is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/eth2near/eth2near-block-relay-rs/src/eth2near_relay.rs#L399) and for sending light client updates is [here](https://github.com/aurora-is-near/rainbow-bridge/blob/master/eth2near/eth2near-block-relay-rs/src/eth2near_relay.rs#L489).
      1. [Send Block Headers (submit_execution_header)](https://nearblocks.io/txns/HaXUxCvA1D87QXJzPzSYXmFYNuSLbTmyuxShzWgSLvPM): Batch transaction which submits 32 block headers to [client-eth2.bridge.near](https://nearblocks.io/address/client-eth2.bridge.near) for Ethereum Blocks 16493592 to 16493623. (The second slot in epoch [176,936](https://beaconcha.in/epoch/176936) to the first slot in epoch [176,937](https://beaconcha.in/epoch/176937)). **Executed every 6 minutes when the first slot of a new epoch is found.**
      2. [Create Light Client update proposal(add_proposal)](https://nearblocks.io/txns/J1tQ465Dxt4UhWy9Msn2pZCbdkWatSepqsx9sDZaX35z#): calls [bridge-validator.sputnik-dao.near](https://nearblocks.io/address/bridge-validator.sputnik-dao.near) to add proposal 17410 for [slot 5,661,984](https://beaconcha.in/slot/5661984) in epoch [176,937](https://beaconcha.in/epoch/176937).
   2. [Approve Proposal (act_proposal)](https://nearblocks.io/txns/D5uP4BbRSUX4ZGijRfWGkR5KbFb2Kb9q1gSsFVQbYSLt): sends a VoteApprove action for proposal 17410 from a [bridge validator](https://nearblocks.io/address/bridge-validator1.near) to the [Validator DAO Contract](https://nearblocks.io/address/bridge-validator.sputnik-dao.near).
      1. act_proposal in contract [bridge-validator.sputnik-dao.near](https://nearblocks.io/address/bridge-validator.sputnik-dao.near)
      2. submit_beacon_chain_light_client_update in [client-eth2.bridge.near](https://nearblocks.io/address/client-eth2.bridge.near)
      3. on_proposal_callback in contract [bridge-validator.sputnik-dao.near](https://nearblocks.io/address/bridge-validator.sputnik-dao.near)
2. Funds Transfer Transaction Flow
   1. [Lock Funds On Ethereum](https://etherscan.io/tx/0xa685c59a24cc2056e10e660ce8a8bff7bbc335433698e138c77aaadf20ecb614): Locking 10,000 USDT to send to user on NEAR.
   2. [Deposit Funds on Target Chain Bridge Contract (deposit)](https://nearblocks.io/txns/vniyRR67ndrtvpoQ9c5ACoT4e9c283VSQsrZcN6GGto#execution)
      1. deposit in contract factory.bridge.near
      2. verify_log_entry in contract prover.bridge.near
      3. block_hash_safe in contract client-eth2.bridge.near
      4. finish_deposit in contract factory.bridge.near : mint of 10,000 USDT.

**TODO**

- Find and review the source code for the [validator light client approval update](https://nearblocks.io/txns/HnzBR7x5Sxnmcm4MfRt1ghhMjJNspDaygUUKeM9T27Li#execution). *Note: the eth2_client has a [validate_light_client_update](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/near/eth2-client/src/lib.rs#L311) which is [configurable](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/near/eth2-client/src/lib.rs#L42) and is used for debugging purposes.*

## Bridging Resources Required

Here is the storage and compuational costs per component.

| Component                                                                                                                   | Data           | Storage | Notes |
| --------------------------------------------------------------------------------------------------------------------------- | -------------- | ------- | ----- |
| [Ethereum 2 Client](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/near/eth2-client/src/lib.rs#L35) | ---            | ---     | ---   |
| [Prover](https://github.com/aurora-is-near/rainbow-bridge/blob/master/contracts/near/eth-prover/src/lib.rs)                 | not applicable | 0 bytes |       |
| [DAO Contract](https://github.com/aurora-is-near/rainbow-bridge/blob/master/eth2near/contract_wrapper/src/dao_contract.rs)  |                |         |       |

**TODO**
Review the following data structure and elements and move into the table above commenting on any mandatory requirements and structures that can be improved.

```go
pub struct Eth2Client {
    /// If set, only light client updates by the trusted signer will be accepted
    trusted_signer: Option<AccountId>,
    /// Mask determining all paused functions
    paused: Mask,
    /// Whether the client validates the updates.
    /// Should only be set to `false` for debugging, testing, and diagnostic purposes
    validate_updates: bool,
    /// Whether the client verifies BLS signatures.
    verify_bls_signatures: bool,
    /// We store the hashes of the blocks for the past `hashes_gc_threshold` headers.
    /// Events that happen past this threshold cannot be verified by the client.
    /// It is desirable that this number is larger than 7 days' worth of headers, which is roughly
    /// 51k Ethereum blocks. So this number should be 51k in production.
    hashes_gc_threshold: u64,
    /// Network. e.g. mainnet, kiln
    network: Network,
    /// Hashes of the finalized execution blocks mapped to their numbers. Stores up to `hashes_gc_threshold` entries.
    /// Execution block number -> execution block hash
    finalized_execution_blocks: LookupMap<u64, H256>,
    /// All unfinalized execution blocks' headers hashes mapped to their `HeaderInfo`.
    /// Execution block hash -> ExecutionHeaderInfo object
    unfinalized_headers: UnorderedMap<H256, ExecutionHeaderInfo>,
    /// `AccountId`s mapped to their number of submitted headers.
    /// Submitter account -> Num of submitted headers
    submitters: LookupMap<AccountId, u32>,
    /// Max number of unfinalized blocks allowed to be stored by one submitter account
    /// This value should be at least 32 blocks (1 epoch), but the recommended value is 1024 (32 epochs)
    max_submitted_blocks_by_account: u32,
    // The minimum balance that should be attached to register a new submitter account
    min_storage_balance_for_submitter: Balance,
    /// Light client state
    finalized_beacon_header: ExtendedBeaconBlockHeader,
    finalized_execution_header: LazyOption<ExecutionHeaderInfo>,
    current_sync_committee: LazyOption<SyncCommittee>,
    next_sync_committee: LazyOption<SyncCommittee>,
}
```

### References

**Explorer and Interactive Links**

- Near
  - eth-prover
    - [https://nearblocks.io/address/relayer.bridge.near](https://nearblocks.io/address/relayer.bridge.near)
    - [https://nearblocks.io/address/client-eth2.bridge.near](https://nearblocks.io/address/client-eth2.bridge.near)
    - [https://nearblocks.io/address/client.bridge.near](https://nearblocks.io/address/client.bridge.near)
  - eth-client
    - [https://nearblocks.io/address/prover.bridge.near](https://nearblocks.io/address/prover.bridge.near)
    - [https://nearblocks.io/address/client.bridge.near](https://nearblocks.io/address/client.bridge.near)
  - factory (manages tokens)
    - [https://nearblocks.io/address/factory.bridge.near](https://nearblocks.io/address/factory.bridge.near)
  - dao
    - [https://nearblocks.io/address/bridge-validator.sputnik-dao.near](https://nearblocks.io/address/bridge-validator.sputnik-dao.near)
  - aurora
    - [https://nearblocks.io/address/aurora](https://nearblocks.io/address/aurora)
    - [https://nearblocks.io/address/relay.aurora](https://nearblocks.io/address/relay.aurora)

- Ethereum
  - [beaconcha.in](https://beaconcha.in/)
    - [validators](https://beaconcha.in/validators)
    - [epochs](https://beaconcha.in/epochs)
    - [slots](https://beaconcha.in/slots)
    - [blocks](https://beaconcha.in/blocks)
    - [transactions](https://beaconcha.in/transactions)
  - Near Bridge
    - [NearBridge](https://etherscan.io/address/0x3fefc5a4b1c02f21cbc8d3613643ba0635b9a873)
    - [ERC20Locker](https://etherscan.io/tx/0xa685c59a24cc2056e10e660ce8a8bff7bbc335433698e138c77aaadf20ecb614)
