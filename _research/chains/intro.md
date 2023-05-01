---
title: Chain Research
category: chain-intro
date: 2023-02-04
---

## Overview

Here we do a deep dive on individual chains with a focus on the following areas

* Consensus Mechanism
* Signing Algorithms Supported
* Light Client Support
* Gas Costs
* Settlement Time
* Codebases

## Chain Economics

Following is an overview of the economics of sample chains. These chains are early candidates for the design and implementation of trustless bridging that we have been doing.

| Chain     | Token                                                 | Token Price | Market Capitalization | Total Value Locked                                         |
| --------- | ----------------------------------------------------- | ----------- | --------------------- | ---------------------------------------------------------- |
| Avalanche | [AVAX](https://www.coingecko.com/en/coins/avalanche)  | $17.83      | $5,619,898,947        | [$912,440,000](https://defillama.com/chain/Avalanche)      |
| BSC       | [BNB](https://www.coingecko.com/en/coins/bnb)         | $308.08     | $48,646,681,885       | [$4,840,000,000](https://defillama.com/chain/BSC)          |
| Cosmos    | [ATOM](https://www.coingecko.com/en/coins/cosmos-hub) | $13.53      | $3,959,718,206        | [$1,218,000,000](https://defillama.com/chains/Cosmos)  +++ |
| Ethereum  | [ETH](https://www.coingecko.com/en/coins/ethereum)    | $1,519.29   | $183,069,985,916      | [$27,850,000,000](https://defillama.com/chain/Ethereum)    |
| Harmony   | [ONE](https://www.coingecko.com/en/coins/harmony)     | $0.0244     | $299,878,381          | [$6,958,436](https://defillama.com/chain/Harmony)          |
| Polygon   | [MATIC](https://www.coingecko.com/en/coins/polygon)   | $1.24       | $11,171,619,834       | [$1,170,000,000](https://defillama.com/chain/Polygon)      |
| Pokadot   | [DOT](https://www.coingecko.com/en/coins/polkadot)    | $6.22       | $7,475,485,172        | [$278,000,000](https://defillama.com/chains/Parachain)  ++ |

*The above data is from Feburary 11th, 2023. Links are provided to get current information.*

*++ Polkadot TVL includes all parachains*

*+++ Cosmos TVL include all cosmos based networks*

## Chain Technology

Following is an overview of the consensus, signing and staking mechanisms for sample chains. These chains are early candidates for the design and implementation of trustless bridging that we have been doing.

| Chain      | Consensus                                                                                                                                                                                                                                                                                   | Signing                                                                                                                                      | Staking                                                                                               | Validators                                                                        | Subnets                                                                                                       |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------- |
| Avalanche  | [Snowball](https://docs.avax.network/overview/getting-started/avalanche-consensus)<br> [White Paper](https://assets.website-files.com/5d80307810123f5ffbb34d6e/6009805681b416f34dcae012_Avalanche%20Consensus%20Whitepaper.pdf)                                                             | [rsa](https://en.wikipedia.org/wiki/RSA_(cryptosystem))                                                                         | [Avalanche Staking](https://docs.avax.network/nodes/validate/staking#staking-parameters-on-avalanche) | [1215](https://subnets.avax.network/validators)                                   | [45](https://subnets.avax.network/subnets) [subnets](https://docs.avax.network/subnets)                       |
| BSC        | [Parlia](https://docs.bnbchain.org/docs/learn/consensus/#consensus-protocol)                                                                                                                                                                                                                | [secp256k1](https://docs.bnbchain.org/docs/beaconchain/learn/accounts/#signature)                                                            | [PoSA](https://docs.bnbchain.org/docs/stake/Staking/)                                                 | [50](https://www.bnbchain.org/en/staking)                                         |                                                                                                               |
| Cosmos Hub | [Tendermint](https://docs.tendermint.com/v0.34/introduction/what-is-tendermint.html)                                                                                                                                                                                                        | [ed25519](https://ed25519.cr.yp.to/) [Validator Keys](https://docs.tendermint.com/v0.34/tendermint-core/validators.html#validator-keys)      | [Cosmos Staking](https://docs.cosmos.network/v0.46/modules/staking/)                                  | [504](https://www.mintscan.io/cosmos/validators)                                  | [21](https://defillama.com/chains/Cosmos) [Chains](https://docs.cosmos.network/main/intro/why-app-specific)   |
| Ethereum   | [Gasper](https://arxiv.org/pdf/2003.03052.pdf)                                                                                                                                                                                                                                              | BLS                                                                                                                                          | [PoS](https://ethereum.org/en/developers/docs/consensus-mechanisms/pos/)                              | [16,477,159](https://ethereum.org/en/staking/)                                    |                                                                                                               |
| Harmony    | [FBFT](https://docs.harmony.one/home/general/technology/consensus)                                                                                                                                                                                                                          | [BLS](https://medium.com/@caseyga/exploring-bls-keys-on-the-harmony-protocol-understanding-generation-management-and-use-cases-b8722f7219fc) | [EPoS](https://docs.harmony.one/home/general/technology/effective-proof-of-stake)                     | [299](https://staking.harmony.one/validators/mainnet)                             | [4](https://explorer.harmony.one/) [shards](https://docs.harmony.one/home/general/technology/sharding)        |
| Polygon    | [Peppermint](https://wiki.polygon.technology/docs/pos/peppermint/)<br>[Heimdall and Bor](https://polygon.technology/blog/heimdall-and-bor)<br>*[Heimdall](https://wiki.polygon.technology/docs/pos/heimdall/overview/)<br>* [BOR](https://wiki.polygon.technology/docs/pos/bor/consensus/) | secp256k1                                                                                                                                    | [Heimdall Staking](https://wiki.polygon.technology/docs/pos/heimdall/modules/staking/)                | [100](https://staking.polygon.technology/)                                        |                                                                                                               |
| Polkadot   | [NPoS](https://wiki.polkadot.network/docs/learn-consensus)                                                                                                                                                                                                                                  | [Sr25519](https://wiki.polkadot.network/docs/learn-cryptography#what-is-sr25519-and-where-did-it-come-from)                                  | [Nominated Pools](https://wiki.polkadot.network/docs/learn-staking)                                   | [1200](https://staking.polkadot.network/?utm_source=polkadot.network#/validators) | [36](https://polkadot.subscan.io/parachain) [parachains](https://wiki.polkadot.network/docs/learn-parachains) |

*The above  data is from Feburary 11th, 2023. Links are provided to get current information.*

## Consensus Implementations

### Consensus

* [avalanche](https://github.com/ava-labs/avalanchego/blob/master/snow/README.md) (go)
  * [avalanche](https://github.com/ava-labs/avalanchego/tree/master/snow/consensus/avalanche): a general avalanche instance that can be used directly to process a series of partially ordered elements.
  * [snowball](https://github.com/ava-labs/avalanchego/tree/master/snow/consensus/snowball): a general snow instance that can be used directly to process the results of network queries.
  * [snowman](https://github.com/ava-labs/avalanchego/tree/master/snow/consensus/snowman): a general snowman instance that can be used directly to process a series of dependent operations.
  * [snowstorm](https://github.com/ava-labs/avalanchego/tree/master/snow/consensus/snowstorm): a snowball instance deciding between an unbounded number of non-transitive conflicts. After performing a network sample of k nodes, you should call collect with the responses.
  * [Snowman++: congestion control for Snowman VMs](https://github.com/ava-labs/avalanchego/blob/master/vms/proposervm/README.md): Snowman++ introduces a soft proposer mechanism which attempts to select a single proposer with the power to issue a block, but opens up block production to every validator if sufficient time has passed without blocks being generated.
  * [Avalanche Warp Messaging (AWM)](https://medium.com/avalancheavax/avalanche-warp-messaging-awm-launches-with-the-first-native-subnet-to-subnet-message-on-avalanche-c0ceec32144a): AWM enables Subnet Validators to collectively produce a BLS Multi-Signature that attests to the validity of an arbitrary message (e.g., transfer, contract data, etc.) that can be verified by any other Subnet.
* [bsc](https://github.com/bnb-chain/bsc/tree/master/consensus) (go)
  * [beacon](https://github.com/bnb-chain/bsc/blob/master/consensus/beacon/consensus.go): Beacon is a consensus engine that combines the eth1 consensus and proof-of-stake algorithm. There is a special flag inside to decide whether to use legacy consensus rules or new rules. The transition rule is described in the eth1/2 merge spec [eip-3675](https://eips.ethereum.org/EIPS/eip-3675). The beacon here is a half-functional consensus engine with partial functions which is only used for necessary consensus checks. The legacy consensus engine can be any engine implements the consensus interface (except the beacon itself).
  * [clique](https://github.com/bnb-chain/bsc/blob/master/consensus/clique/clique.go): Clique is the proof-of-authority consensus engine proposed to support the Ethereum testnet following the Ropsten attacks.
  * [ethash](https://github.com/bnb-chain/bsc/blob/master/consensus/ethash/consensus.go): Ethash proof-of-work protocol (obsolete).
  * [misc](https://github.com/bnb-chain/bsc/tree/master/consensus/misc): includes code for [eip-1559](https://eips.ethereum.org/EIPS/eip-1559), DAO hard-fork extension to the header validity, VerifyForkHashes verifies that blocks conforming to network hard-forks do have the correct hashes and erifyGaslimit verifies the header gas limit according increase/decrease in relation to the parent gas limit.
  * [parlia](https://github.com/bnb-chain/bsc/blob/master/consensus/parlia/parlia.go): Parlia is the consensus engine of BSC
* [ethereum](https://github.com/ethereum/consensus-specs)
  * [Ethreum 2.0 Fork Choice](https://github.com/ethereum/consensus-specs/blob/v0.12.1/specs/phase0/fork-choice.md)
  * [Paths toward single-slot finality](https://notes.ethereum.org/@vbuterin/single_slot_finality): A look at how to improve Ethereum’s LMD GHOST + Casper FFG consensus.
    * [lighthouse](https://github.com/sigp/lighthouse/tree/stable/consensus/fork_choice) (rust): stores the actual block DAG in `ProtoArrayForkChoice`. - `time` is represented using `Slot` instead of UNIX epoch `u64`.
  * [proto_array]
    * [lighthouse proto_array](https://github.com/sigp/lighthouse/tree/stable/consensus/proto_array) (rust): ProtoArray iterates backwards through the array, touching all nodes and their parents and potentially the best-child of each parent. The structure of the `self.nodes` array ensures that the child of each node is always touched before its parent.
  * [SerDes](https://en.wikipedia.org/wiki/SerDes): Serializer/Deserializer
    * [lighthouse serde_utils](https://github.com/sigp/lighthouse/tree/stable/consensus/serde_utils) (rust)
  * [simple serialize](https://github.com/ethereum/eth2.0-specs/blob/v0.12.1/ssz/simple-serialize.md)
    * [lighthouse ssz](https://github.com/sigp/lighthouse/blob/stable/consensus/ssz/src/lib.rs) (rust): Provides encoding (serialization) and decoding(deserialization) in the SimpleSerialize (SSZ) format designed for use in Ethereum 2.0.
    * [lighthouse ssz_derive](https://github.com/sigp/lighthouse/tree/stable/consensus/ssz_derive) (rust): Provides procedural derive macros for the `Encode` and `Decode` traits of the `eth2_ssz` crate.
    * [lighthouse ssz_types](https://github.com/sigp/lighthouse/tree/stable/consensus/ssz_types) (rust): Provides types with unique properties required for SSZ serialization and Merklization
    * [prysm ssz.bzl](https://github.com/prysmaticlabs/prysm/blob/a7010d817dc839b0a46742dc286402357482da46/tools/ssz.bzl#L70) (bazel): A rule that uses the generated pb.go files from a go_proto_library target to generate SSZ marshal and unmarshal functions as pointer receivers on the specified objects.
  * [state_processing](https://github.com/ethereum/consensus-specs/blob/dev/specs/bellatrix/beacon-chain.md#beacon-chain-state-transition-function)
    * [lighthouse state_procesing](https://github.com/sigp/lighthouse/tree/stable/consensus/state_processing) (rust): State processing functions including block, slot and epoch functions.
  * [compute_shuffled_index](https://github.com/ethereum/consensus-specs/blob/v0.12.1/specs/phase0/beacon-chain.md#compute_shuffled_index)
    * [lighthouse swap_or_not_shuffle](https://github.com/sigp/lighthouse/tree/stable/consensus/swap_or_not_shuffle) (rust): Provides list-shuffling functions matching the Ethereum 2.0 specification.
  * [types]
    * [lighthouse types](https://github.com/sigp/lighthouse/tree/stable/consensus/types) (rust): Includes type definitions used in consensus including `beacon_block_header`, `beacon_comittee`, ,`beacon_state`, `sync_comitte` and more.
* [harmony](https://github.com/harmony-one/harmony/blob/main/consensus/README.md) (go)
  * [harmony consensus](https://github.com/harmony-one/harmony/tree/main/consensus)
* [near](https://nomicon.io/ChainSpec/Consensus) (rust)
  * [near nearcore](https://github.com/near/nearcore/tree/master/nearcore)
* [polkadot](https://wiki.polkadot.network/docs/learn-consensus) (rust): [code](https://github.com/paritytech/substrate/tree/master/primitives/consensus)
  * [aura](https://github.com/paritytech/substrate/tree/master/primitives/consensus/aura)
  * [babe](https://github.com/paritytech/substrate/tree/master/primitives/consensus/babe)
  * [beefy](https://github.com/paritytech/substrate/tree/master/primitives/consensus/beefy)
  * [grandpa](https://github.com/paritytech/substrate/tree/master/primitives/consensus/grandpa)
  * [pow](https://github.com/paritytech/substrate/tree/master/primitives/consensus/pow)
  * additional primitives
    * [common](https://github.com/paritytech/substrate/tree/master/primitives/consensus/common): Common utilities for building and using consensus engines in substrate.
    * [slots](https://github.com/paritytech/substrate/tree/master/primitives/consensus/slots): Primitives for slots-based consensus engines.
    * [vrf](https://github.com/paritytech/substrate/tree/master/primitives/consensus/vrf): Primitives for VRF-based consensus engines. Schnorrkel-based VRF.
* [polygon heimdall]() (go): Validator node for Matic Network. It uses peppermint, customized Tendermint. Here is where it sends validator updates to [peppermint](https://github.com/maticnetwork/heimdall/blob/develop/app/app.go#L625)
  * [polygon peppermint](https://github.com/maticnetwork/tendermint/tree/peppermint/consensus)(go): Peppermint is a modified Tendermint. It is changed to make it compatible with Ethereum addresses and verifiable on Ethereum chain. (docs are [here](https://wiki.polygon.technology/docs/pos/peppermint/))
* [tendermint tendermint](https://github.com/tendermint/tendermint/tree/main/consensus) (go)
