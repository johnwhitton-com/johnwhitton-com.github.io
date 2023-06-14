---
title:  Code bases and reviews
category: code-intro
date: 2023-02-04
---

## Overview

**Disclaimer: The content in this section are notes I took doing research and design work, primarily around bridging and consensus. Some are incomplete and they lack structure. I have included them here for completeness.**

- [Overview](#overview)
- [Functionality](#functionality)
- [Reference Codebases](#reference-codebases)
  - [Blockchains](#blockchains)
  - [Bridging and Light Clients](#bridging-and-light-clients)
  - [Zero Knowledge](#zero-knowledge)

## Functionality

In this section we list codebases that implement cryptographic functions. We organize by functional areas such as signing, hashing, primitives and consensus. Where possible we provide a link to the algorithms/specifications being implemented followed by reference codebases.

We have summarized the functionality in three areas

- [Signing](../primitives/signatures.md)
- [Cryptographic Primitives](../primitives/primitives.md)
- [Consensus](../chains/intro.md)

## Reference Codebases

### Blockchains

- [Binance](https://github.com/bnb-chain/bsc) (go)
- [Avalanche](https://github.com/ava-labs/avalanchego) (go)
- [Ethereum](https://clientdiversity.org/#distribution) [roadmap](https://notes.ethereum.org/@domothy/roadmap) [upgrading ethereum](https://eth2book.info/bellatrix/contents/) [consensus-specs](https://github.com/ethereum/consensus-specs)
  - Consensus Clients (Beacon Chain)
    - [prysm](https://github.com/prysmaticlabs/prysm) (go)
    - [lighthouse](https://github.com/sigp/lighthouse/) (rust)
    - [teku](https://github.com/ConsenSys/teku) (java)
    - [nimbus](https://github.com/status-im/nimbus-eth2) ([nim](https://nim-lang.org/))
    - [lodestar](https://github.com/ChainSafe/lodestar) (typescript)
    - [grandine](https://github.com/sifraitech/grandine) (rust) not open source
  - Execution Clients (Execution Chain)
    - [geth](https://github.com/ethereum/go-ethereum) (go)
    - [nethermind](https://github.com/NethermindEth/nethermind) (c#)
    - [Erigon](https://github.com/ledgerwatch/erigon) (go)
    - [Besu](https://github.com/hyperledger/besu) (java)
  - Light Client
    - [helios](https://github.com/a16z/helios) (rust): [article](https://a16zcrypto.com/building-helios-ethereum-light-client/)
    - [near rainbow bridge eth2-client](https://github.com/aurora-is-near/rainbow-bridge/tree/master/contracts/near/eth2-client) (rust)
    - [succinctlabs](https://github.com/succinctlabs/eth-proof-of-consensus/tree/main/contracts/src/lightclient) (solidity)
- [Harmony](https://github.com/harmony-one/harmony)
  - [Harmony MMRHardFork](https://github.com/peekpi/harmony/tree/mmrHardfork)
- [Near](https://github.com/near/nearcore)
- [Polkadot](https://github.com/orgs/paritytech/repositories)
  - [substrate](https://github.com/paritytech/substrate)
  - [cumulus](https://github.com/paritytech/cumulus)
  - [smoldot](https://github.com/smol-dot/smoldot)
  - [open-runtime-module-library](https://github.com/open-web3-stack/open-runtime-module-library)
- [Polygon](https://github.com/maticnetwork)
  - [peppermint](https://github.com/maticnetwork/tendermint/tree/peppermint) (go) fork of tendermint
  - [heimdall](https://github.com/maticnetwork/heimdall) (go)
- [Tendermint](https://github.com/tendermint/tendermint)

### Bridging and Light Clients

- Light Clients
  - [Harmony MMRHardFork](https://github.com/peekpi/harmony/tree/mmrHardfork)

- Bridging
  - [Harmony Horizon Bridge](./Horizon.md): Detailed code review
    - [Horizon](https://github.com/johnwhitton/horizon/tree/refactorV2): javascript, solidity
  - [Near Rainbow Bridge](./ethereum-near.md): Detailed code review
    - [Near Rainbow Bridge](https://github.com/aurora-is-near/rainbow-bridge): rust, go, solidity, javascript
    - [Near Rainbow Token Connector](https://github.com/aurora-is-near/rainbow-token-connector): soldity
    - SDK
      - [Near Rainbow Bridge Client](https://github.com/aurora-is-near/rainbow-bridge-client/tree/main/packages/client): typescript
    - Frontend
      - [NEAR Rainbow Bridge Frontend](https://github.com/aurora-is-near/rainbow-bridge-frontend)
  - [Nomad monprepo](https://github.com/nomad-xyz/monorepo): Nomad is a cross-chain communication protocol. This repo contains the following: Smart contracts for the core Nomad protocol, Smart contracts for the Nomad token bridge SDKs for Nomad's core protocol, bridge, and governance systems, Tooling for local environment simulation and Smart contract deployment tooling.
    - [Nomad rust](https://github.com/nomad-xyz/rust): Nomad is a cross-chain communication standard that supports passing messages between blockchains easily and inexpensively. Like IBC light clients and similar systems, Nomad establishes message-passing channels between chains. Once a channel is established, any application on that chain can use it to send messages to others chains.
    - [Nomad gelato-sdk](https://github.com/nomad-xyz/gelato-sdk): This crate reimplements Gelato's Relay SDK in Rust. It simply wraps Gelato Relay requests and responses to/from Gelato endpoints with Rust types and methods.
  - [Succinct labs](../bridge/succinct.md): Deep dive on Succinct labs Proof of Consensus for Ethreum.
    - [Proof of Consensus for Ethereum](https://github.com/succinctlabs/eth-proof-of-consensus): contains both the zkSNARK circuits as well as the smart contracts needed for our succinct light client implementation, as well as prototype message passing contracts and bridge contracts.
  - [Datachain lcp](https://github.com/datachainlab: )A proxy for light client verification executed in TEE.
  - [Cosmos ibc-go](https://github.com/cosmos/ibc-go): allows blockchains to talk to each other. This end-to-end, connection-oriented, stateful protocol provides reliable, ordered, and authenticated communication between heterogeneous blockchains.
    - [Cosmos ibc](https://github.com/cosmos/ibc): ibc specification
  - [Cosmos gravity bridge](https://github.com/cosmos/gravity-bridge): Cosmos <-> Ethereum bridge designed to run on the Cosmos Hub focused on maximum design simplicity and efficiency.
  - [Axelar](https://github.com/axelarnetwork/axelar-core):  based on the Cosmos SDK is the main application of the axelar network. [whitepaper](https://axelar.network/axelar_whitepaper.pdf) [docs](https://docs.axelar.dev/)
  - [Celer cBridge-node](https://github.com/celer-network/cBridge-node): Celer cBridge relay node implementation in Golang. ([docs](https://cbridge-docs.celer.network/))
    - [Celer cBridge-contracts](https://github.com/celer-network/cBridge-contracts): Contracts for cBridge, cross-chain liquidity solution powered by Hashed-Timelock Transfers
    - [Celer cBridge-cowa](https://github.com/celer-network/cbridge-cowa): CosmWasm Rust smart contracts for cbridge
  - [Wormhole](https://github.com/wormhole-foundation/wormhole): the reference implementation of the Wormhole protocol. ([docs](https://book.wormhole.com/introduction/introduction.html))
  - [LayerZero Labs LayerZero](https://github.com/LayerZero-Labs/LayerZero):  contains the smart contracts for LayerZero Endpoints. ([docs](https://layerzero.gitbook.io/docs/))
  - [Multichain CrossChain-Bridge](https://github.com/anyswap/CrossChain-Bridge): Cross-Chain bridge based on Anyswap MPC network. ([docs](https://docs.multichain.org/getting-started/introduction))
  - [Synapse Protocol](https://github.com/synapsecns): a universal interoperability protocol that enables secure cross-chain communication.( [docs](https://docs.synapseprotocol.com/))
    - [synapse-contracts](https://github.com/synapsecns/synapse-contracts):  smart contracts for Synapse Protocol.
  - [Hop Protocol contracts](https://github.com/hop-protocol/contracts): Hop is a scalable rollup-to-rollup general token bridge. Heare are the smart contracts that power the Hop Exchange. ([whitepaper](https://hop.exchange/whitepaper.pdf), [docs](https://docs.hop.exchange/basics/a-short-explainer)).
  - [Router Protocol](https://github.com/orgs/router-protocol/repositories): ([whitepaper](https://docs.routerprotocol.com/whitepaper/introducing-router-protocol), [docs](https://dev.routerprotocol.com/))
  - [Parity Bridges Common](https://github.com/paritytech/parity-bridges-common): a collection of components for building bridges.
  - [Snowfork snowbridge](https://github.com/Snowfork/snowbridge): A trustless bridge between Polkadot and Ethereum. ([docs](https://docs.snowbridge.network/))

### Zero Knowledge

- Foundational
  - [halo2](https://github.com/zcash/halo2) (rust)
    - [halo2 privacy-scaling-explorations](https://github.com/privacy-scaling-explorations/halo2/commits/main) (rust) fork
    - [junyu0312](https://github.com/junyu0312/halo2) (rust) fork
  - [Circom](https://github.com/iden3/circom) a novel domain-specific language for defining arithmetic circuits that can be used to generate zero-knowledge proofs
  - [Arkworks](https://github.com/arkworks-rs) (rust)
  - [noir](https://github.com/noir-lang/noir) (rust)
  - [StarkWare's Poseidon Hash](https://github.com/starkware-industries/poseidon)
- Applications
  - [halo2ecc-s](https://github.com/DelphinusLab/halo2ecc-s) (rust): ecc circuits with halo2
  - [DarkForest](https://github.com/darkforest-eth) zkSNARK space warfare
  - [Awesome List](https://github.com/snowtigersoft/awesome-darkforest)
- Proof of Consensus/Bridging
  - [succinctlabs](https://github.com/succinctlabs/eth-proof-of-consensus) (circom)
