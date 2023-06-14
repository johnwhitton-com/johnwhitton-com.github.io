---
title: Harmony Horizon
category: bridge
date: 2023-02-24
---


- [Overview](#overview)
- [Approach](#approach)
- [Proving Mechanisms](#proving-mechanisms)
  - [Ethereum Light Client](#ethereum-light-client)
  - [Harmony Light Client](#harmony-light-client)
- [Relayer Mechanisms](#relayer-mechanisms)
- [Light Client Functionality](#light-client-functionality)
  - [Ethereum Light Client](#ethereum-light-client-1)
  - [Harmony Light Client](#harmony-light-client-1)
- [Token Lockers](#token-lockers)
  - [MultiChain Support](#multichain-support)
- [Code Review](#code-review)
- [On-chain (Solidity) Code Review](#on-chain-solidity-code-review)
  - [OpenZeppelin Utilities](#openzeppelin-utilities)
  - [Cryptographic Primitives](#cryptographic-primitives)
  - [Proving Mechanisms](#proving-mechanisms-1)
  - [Token Lockers](#token-lockers-1)
- [Off-chain (Javascript) Code Review](#off-chain-javascript-code-review)
  - [On-chain interaction](#on-chain-interaction)
  - [Command Line Interface](#command-line-interface)
  - [Ethereum Light Client](#ethereum-light-client-2)
  - [Proving Mechanisms](#proving-mechanisms-2)
  - [Relayer Mechanisms](#relayer-mechanisms-1)
  - [Cryptographic Primitives](#cryptographic-primitives-1)
  - [Light Client Functionality](#light-client-functionality-1)
  - [Token Lockers](#token-lockers-2)
- [References](#references)
- [Appendices](#appendices)
  - [Appendix A: Current Implementation Walkthough](#appendix-a-current-implementation-walkthough)
    - [Ethereum Light Client (on Harmony)](#ethereum-light-client-on-harmony)
  - [Mapping Tokens (Ethereum to Harmony)](#mapping-tokens-ethereum-to-harmony)

## Overview

This document reviews the [horizon](https://github.com/johnwhitton/horizon/tree/refactorV2) current implementation, development tasks that need to be done to support POW and offers some thoughts on next steps to support Ethereum 2.0 and other chains.

Further thoughs on ETH 2.0 support, removing the ETHHASH logic and SPV client and potentially replacing with MMR trees per epoch and checkpoints similar to Harmony Light Client on Ethereum, can find inspiration in [near-rainbow](./near-rainbow.md).

## Approach

Horizon 2.0 approach is to use validity proofs implemented by on-chain smart contracts.

## Proving Mechanisms

### Ethereum Light Client

1. ETH 2.0 support see [here](./ETH2_0.md)
2. Queuing mechanism should be implemented to queue bridge transactions. The queue can be polled as part of the block relay functionality to process bridge transactions once the blocks have been relayed.
3. Consider whether we can use p2p messaging to receive published blocks rather than looping and polling via an RPC.

### Harmony Light Client

1. Needs to implement a process to `submitCheckpoint`.
2. `eprove` logic needs to be reviewed
3. Queuing mechanism should be implemented to queue bridge transactions. The queue can be polled as part of the `submitCheckpoint` functionality to process bridge transactions once the blocks have been relayed.
4. Need to facilitate the core protocol [MMR enhancements PR](https://github.com/harmony-one/harmony/pull/4198/files)

## Relayer Mechanisms

Sequencing of Transactions: Needs to be implemented and `TokenMap` in `bridge.js` needs to be refactored. Below is the current sequence flow and areas for improvements.

1. Ethereum Mapping Request
2. Relay of Block to EthereumLightClient.sol on Harmony
    - The block has to be relayed before we can process the Harmony Mapping request, as we have just executed the transaction the relayer usually has not relayed the block so this will fail.
    - There must be an additional 25 blocks on Ethereum before this block can be considered part of the canonical chain.
    - This logic needs to be rewritten to break down execution for 1. the ethereum mapping request 2. After a 25 block delay the Harmony Proof validation and executing the Harmony Mapping Request**  
3. Harmony Mapping Request
4. Relay of Checkpoint to HarmonyLightClient.sol on Ethereum
    - A `submitCheckpoint` in `HarmonyLightClient.sol` needs to have called either for the next epoch or for a checkpoint, after the block the harmony mapping transaction was in.**
    - Automatic submission of checkpoints to the Harmony Light Client has not been developed as yet. (It is not part of the `ethRelay.js`). And so the checkpoint would need to be manually submitted before the Ethereum Mapping could take place.
5. Etherem Process Harmony Mapping Acknowledgement

## Light Client Functionality

### Ethereum Light Client

1. ETH 2.0 support see [here](./ETH2_0.md)
2. Queuing mechanism should be implemented to queue bridge transactions. The queue can be polled as part of the block relay functionality to process bridge transactions once the blocks have been relayed.
3. Consider whether we can use p2p messaging to receive published blocks rather than looping and polling via an RPC.

### Harmony Light Client

1. Needs to implement a process to `submitCheckpoint`.
2. `eprove` logic needs to be reviewed
3. Queuing mechanism should be implemented to queue bridge transactions. The queue can be polled as part of the `submitCheckpoint` functionality to process bridge transactions once the blocks have been relayed.
4. Need to facilitate the core protocol [MMR enhancements PR](https://github.com/harmony-one/harmony/pull/4198/files)

## Token Lockers

*Note: The key difference between `TokenLockerOnEthereum.sol` and `TokenLockerOnHarmony.sol` is the proof validation. `TokenLockerOnEthereum.sol` uses `./lib/MMRVerifier.sol` to validate the [Mountain Merkle Ranges](https://github.com/opentimestamps/opentimestamps-server/blob/master/doc/merkle-mountain-range.md) on Harmony and `HarmonyProver.sol`. `TokenLockerOnHarmony.sol` imports `./lib/MPTValidatorV2.sol` to validate [Merkle Patrica Trie](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/#merkle-patricia-trees) and `./EthereumLightClient.sol`.*

### MultiChain Support

1. Need to support other chains
    - EVM: BSC, Polygon, Avalanche, Arbitrum, Optimism
    - Bitcoin
    - NEAR
    - Solana
    - Polkadot

## Code Review

The code reviewed is from a fork of [harmony-one/horizon](https://github.com/harmony-one/horizon). The fork is [johnwhitton/horizon branch refactorV2](https://github.com/johnwhitton/horizon/tree/refactorV2). This is part of the horizon v2 initiative to bride a trustless bridge after the initial horizon hack. The code is incomplete and the original codebase did not support ethereum 2.0 (only ethereum 1.0). Nevertheless there are a number of useful components developed which can be leveraged in building a trustless bridge.

## On-chain (Solidity) Code Review

*Note: here we document functionality developed in solidity. We recommend reading the [Open Zeppelin Contract Documentation](https://docs.openzeppelin.com/contracts/4.x/) specifically the [utilities](https://docs.openzeppelin.com/contracts/4.x/utilities) have a number of utitlies we leverage around signing and proving. We tend to utilize the [openzeppelin-contracts-upgradeabe repository](https://github.com/OpenZeppelin/openzeppelin-contracts-upgradeable) when building over the documented [openzeppelin-contracts repository](https://github.com/OpenZeppelin/openzeppelin-contracts) as we are often working with contracts which we wish to upgrade, there should be equivalent contracts in both repositories.*

### OpenZeppelin Utilities

- [Utilities](https://docs.openzeppelin.com/contracts/4.x/api/utils): Miscellaneous contracts and libraries containing utility functions you can use to improve security, work with new data types, or safely use low-level primitives.
  - [Math](https://docs.openzeppelin.com/contracts/4.x/api/utils#math): Standard math utilities missing in the Solidity language.
  - [Cryptography](https://docs.openzeppelin.com/contracts/4.x/api/utils#cryptography)
    - [ECDSA](https://docs.openzeppelin.com/contracts/4.x/api/utils#ECDSA): Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
    - [SignatureChecker](https://docs.openzeppelin.com/contracts/4.x/api/utils#SignatureChecker): Signature verification helper that can be used instead of ECDSA.recover to seamlessly support both ECDSA signatures from externally owned accounts (EOAs) as well as ERC1271 signatures from smart contract wallets like Argent and Gnosis Safe.
    - [MerkleProof](https://docs.openzeppelin.com/contracts/4.x/api/utils#MerkleProof): These functions deal with verification of Merkle Tree proofs.
    - [EIP712](https://docs.openzeppelin.com/contracts/4.x/api/utils#EIP712): [EIP 712](https://eips.ethereum.org/EIPS/eip-712) is a standard for hashing and signing of typed structured data.
  - [Escrow](https://docs.openzeppelin.com/contracts/4.x/api/utils#escrow): Base escrow contract, holds funds designated for a payee until they withdraw them.
  - [Introspection](https://docs.openzeppelin.com/contracts/4.x/api/utils#introspection): This set of interfaces and contracts deal with [type introspection](https://en.wikipedia.org/wiki/Type_introspection) of contracts, that is, examining which functions can be called on them. This is usually referred to as a contract’s *interface*.
  - [Data Structures](https://docs.openzeppelin.com/contracts/4.x/api/utils#data_structures)
    - [BitMaps](https://docs.openzeppelin.com/contracts/4.x/api/utils#BitMaps): Library for managing uint256 to bool mapping in a compact and efficient way, providing the keys are sequential. Largely inspired by Uniswap’s [merkle-distributor](https://github.com/Uniswap/merkle-distributor/blob/master/contracts/MerkleDistributor.sol).
    - [EnumerableMap](https://docs.openzeppelin.com/contracts/4.x/api/utils#EnumerableMap): Library for managing an enumerable variant of Solidity’s [mapping](https://solidity.readthedocs.io/en/latest/types.html#mapping-types) type.
    - [EnumerableSet](https://docs.openzeppelin.com/contracts/4.x/api/utils#EnumerableSet): Library for managing [sets](https://en.wikipedia.org/wiki/Set_(abstract_data_type)) of primitive types.
    - [DoubleEndedQueue](https://docs.openzeppelin.com/contracts/4.x/api/utils#DoubleEndedQueue): A sequence of items with the ability to efficiently push and pop items (i.e. insert and remove) on both ends of the sequence (called front and back).
    - [Checkpoints](https://docs.openzeppelin.com/contracts/4.x/api/utils#Checkpoints): This library defines the `History` struct, for checkpointing values as they change at different points in time, and later looking up past values by block number. See [Votes](https://docs.openzeppelin.com/contracts/4.x/api/governance#Votes) as an example.
  - [Libraries](https://docs.openzeppelin.com/contracts/4.x/api/governance#Votes)
    - [Create2](https://docs.openzeppelin.com/contracts/4.x/api/utils#Create2): Helper to make usage of the `CREATE2` EVM opcode easier and safer.
    - [Address](https://docs.openzeppelin.com/contracts/4.x/api/utils#Address): Collection of functions related to the address type
    - [Arrays](https://docs.openzeppelin.com/contracts/4.x/api/utils#Arrays): Collection of functions related to array types.
    - [Base64](https://docs.openzeppelin.com/contracts/4.x/api/utils#Base64): Provides a set of functions to operate with Base64 strings.
    - [Counters](https://docs.openzeppelin.com/contracts/4.x/api/utils#Counters): Provides counters that can only be incremented, decremented or reset.
    - [Strings](https://docs.openzeppelin.com/contracts/4.x/api/utils#Strings): String operations.
    - [StorageSlot](https://docs.openzeppelin.com/contracts/4.x/api/utils#StorageSlot): Library for reading and writing primitive types to specific storage slots. Storage slots are often used to avoid storage conflict when dealing with upgradeable contracts.
    - [Multicall](https://docs.openzeppelin.com/contracts/4.x/api/utils#Multicall): Provides a function to batch together multiple calls in a single external call.

### Cryptographic Primitives

- [ethash](https://github.com/johnwhitton/horizon/tree/refactorV2/contracts/ethash): used in proving ethereum 1.0 [ethash](https://github.com/johnwhitton/horizon/tree/refactorV2/contracts/ethash) proof of work.
  - [MerkleRoot.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/ethash/MerkelRoot.sol): provides the ability to getRootHash for a given epoch. Needs to be initialized with a start and end epoch and an initial merkle root.
  - [Prime.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/ethash/Prime.sol): Determins if a number is likely to be prime, based on the [Miller-Rabin primality test](https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test)
  - [binary.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/ethash/binary.sol): Binary number manipulation.
  - [ethash.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/ethash/ethash.sol): Provides the ability to verifyHash using a [hashimto function](https://ethereum.org/en/developers/docs/consensus-mechanisms/pow/mining-algorithms/dagger-hashimoto/) and [fnv hashing](https://en.wikipedia.org/wiki/Fowler%E2%80%93Noll%E2%80%93Vo_hash_function).
  - [kecakk512.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/ethash/keccak512.sol): Keccak512 hash function supporting [SHA-3](https://en.wikipedia.org/wiki/SHA-3).
- [lib](https://github.com/johnwhitton/horizon/tree/refactorV2/contracts/lib): utility library
  - [ECVerify.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/ECVerify.sol): Verify's a signature and returns the signer address.
  - [EthUtils](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/EthUtils.sol): hexString and byte manipulation
  - [MMR.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/MMR.sol): Merkle Mountain Range solidity library
  - [MMRWrapper.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/MMRWrapper.sol): Merkle Mountain Range wrapper functions.
  - [MPT.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/MPT.sol): Merkle Patricie Tries validation tools (uses RLPReader.sol)
  - [MPTValidatorV2.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/MPTValidatorV2.sol): Merkle Particia Tries validation tools improved by LayerZero
  - [RLPEncode.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/RLPEncode.sol): A simple RLP encoding library.
  - [RLPReader.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/RLPReader.sol): RLP Reader
  - [Safecast.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/lib/SafeCast.sol): Safe casting function for Uints.

### Proving Mechanisms

**Ethereum 1.0 contracts deployed to Harmony**

- [EthereumLightClient.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/EthereumLightClient.sol): Light Client for Ethereum 1.0, stores a mapping of blocks existing in the Canonical Chain verified using EthHash.
- [EthereumParser.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/EthereumParser.sol): Parse RLP-encoded block header into BlockHeader data structure and transactions with data fields order as defined in the Tx struct.
- [EthereumProver.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/EthereumProver.sol): Computes the hash of the Merkle-Patricia-Trie hash of the input and Validates a Merkle-Patricia-Trie proof. If the proof proves the inclusion of some key-value pair in the trie, the value is returned.

**Harmony contracts deployed to Ethereum 1.0**

*Note these contracts were planned to be implemented with Harmony Light Client support which includes Merkle Mountain Ranges (see this [PR](https://github.com/harmony-one/harmony/pull/3872) and this [review](../chains/harmony#light-client-support)). The planned timeline for implementing this had not been finalized as of Feb 2023.*

- [HarmonyLightClient.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/HarmonyLightClient.sol): Allows submission of checkpoints and manages mappings for `checkPointBlocks`  (holding blockHeader information including the Merkle Mountain Range Root field `mmrRoot`).
- [HarmonyParser.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/HarmonyParser.sol): Parse RLP-encoded block header into BlockHeader data structure and transactions with data fields order as defined in the Transaction struct.
- [HarmonyProver.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/HarmonyProver.sol): Verification functions for Blocks, Transaction, Receipts etc. Verification is done by verifying MerkleProofs via `MPTValidator2.sol`.

### Token Lockers

- [BridgeToken.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/BridgedToken.sol): ERC20 contract used for managing bridged tokens.
- [FaucetToken.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/FaucetToken.sol): ERC20 Token Faucet used for testing on testnets.
- [TokenLocker.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/TokenLocker.sol): Locks Bridged Tokens
- [TokenLockerOnEthereum.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/TokenLockerOnEthereum.sol): Ethereum TokenLocker
- [TokenLockerOnHarmony.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/TokenLockerOnHarmony.sol): Harmony TokenLocker
- [TokenRegistry.sol](https://github.com/johnwhitton/horizon/blob/refactorV2/contracts/TokenRegistry.sol): Responsible for mapping tokens between chains and minting new bridged tokens.

## Off-chain (Javascript) Code Review

### On-chain interaction

- [bridge](https://github.com/johnwhitton/horizon/tree/refactorV2/src/bridge)
  - [bridge.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/bridge/bridge.js): Interacts with provers and tokenLockers on the respective chains to perform the bridging of tokens across chains.
  - [contract.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/bridge/contract.js): Responsible for deploying contracts, mapping tokens between chains and checking token status.
  - [ethBridge.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/bridge/ethBridge.js): extends bridge.js with a constructor for Ethereum
  - [hmyBridge.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/bridge/hmyBridge.js): extens bridge.js with a constructor for Harmony
  - [token.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/bridge/token.js): interacts with ERC20 and FaucetToken (for testing).
  - [index.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/cli/index.js): Command Line Interface commands.

### Command Line Interface

- [cli](https://github.com/johnwhitton/horizon/tree/refactorV2/src/cli): CLI is a utility that provides a command-line interface to all the components to the Horizon bridge and allow performing end-to-end bridge functionalities.
  - [elsc.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/cli/elc.js): Ethereum Light Client deployed on Harmony. Supports deployment, status checks and querying block information.
  - [ethRelay.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/cli/ethRelay.js): Block Relayer from Ethereum to Harmony
  - [everifier.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/cli/everifier.js): Ethereum Verifier for Harmony. Supports the deployment of the verifier and validating Merkle Patricia Trie proofs from Harmony.
  - [index.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/cli/index.js): Commands for the CLI.

### Ethereum Light Client

- [elc](https://github.com/johnwhitton/horizon/blob/refactorV2/src/elc/README.md): Ethereum Light Client (ELC) is a SPV-based light client implemented as a smart contract that receives and stores Ethereum block header information.
  - [MerkleRoot.json](https://github.com/johnwhitton/horizon/blob/refactorV2/src/elc/MerkelRoot.json): Holds starting epoch and Merkle root information.
  - [MerkleRootSol.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/elc/MerkelRootSol.js): Deploys a MerkleRoot.sol contract on Harmony for the given Ethereum epoch and merkle root information.
  - [client.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/elc/client.js): Interaction with the Client.sol (the Ethereum Light Client deployed on Harmony).
  - [eth2one.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/elc/eth2one-relay.js): Relays blocks from ethereum to Harmony.
  - [proofDump](https://github.com/johnwhitton/horizon/blob/refactorV2/src/elc/proofDump.js): Allows logging of dagProofs for blocks and epochs and writing them to files.

### Proving Mechanisms

**Ethereum Prover**

- [eprover](https://github.com/johnwhitton/horizon/tree/refactorV2/src/eprover): EProver is a utility that provides verifiable proof about user’s Ethereum tx, e.g., lock tx.
  - [Receipt.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eprover/Receipt.js): Allows retreival of a receipt from Rpc, buffer or hex and serailiation of receipt.
  - [index.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eprover/index.js): exports Eprover
  - [txProof.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eprover/txProof.js): Takes a transaction hash and gets a receipt proof (sha3 hash, recieptRoor, proof and an encoded txIndex).

### Relayer Mechanisms

**Ethereum to Harmony Relayer**

- [eth2hmy-relay](https://github.com/johnwhitton/horizon/tree/refactorV2/src/eth2hmy-relay): Eth2Hmy relay downloads the Ethereum block headers, extract information and relay it to ELC smart contract on Harmony.
  - [index.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eth2hmy-relay/index.js): exports `DagProof` and `getBlockByNumber`.
  - [ethash](https://github.com/johnwhitton/horizon/tree/refactorV2/src/eth2hmy-relay/ethash)
    - [index.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eth2hmy-relay/ethash/dist/index.js): Loads the epoch seed and cache given a block number and uses this to verify Proof of Work for headers and blocks.
    - [util.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eth2hmy-relay/ethash/dist/util.js): Utilities for epochs including caching, hashing and retreival of seeds and buffers.

### Cryptographic Primitives

- [eth2hmy-relay/lib](https://github.com/johnwhitton/horizon/tree/refactorV2/src/eth2hmy-relay/lib): Library of functions used by the Ethereum to Harmony Relay
  - [DagPropf.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eth2hmy-relay/lib/DagProof.js): Checks if a dag exists for an epoch, loads DAG for an epoch and verify header and getProof using the epoch's DAG.
  - [MmapDB.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eth2hmy-relay/lib/MmapDB.js): Merkle database functionality by extending Memory Map.
  - [getBlockHeader.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eth2hmy-relay/lib/getBlockHeader.js): Get Block information.
  - [merkel.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/eth2hmy-relay/lib/merkel.js): MerkleTree functionality including construction of MerkleTrees and getting proofs, hex proofs, combined hashes, get Paired Elements and layers.
- [ethashProof](https://github.com/johnwhitton/horizon/tree/refactorV2/src/ethashProof): ethash proving mechanisms
  - [BlockProof.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/ethashProof/BlockProof.js): Exports getHeaderProof, parseRlpHeader, getBlockByNumber
  - [DagMTreeEpoch.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/ethashProof/DagMtreeEpoch.js): Exports generateDagMTree, genearateDagMTreeRange
  - [MerkelRootSol.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/ethashProof/MerkelRootSol.js): Creates a MerkleRoot.sol contract for an inputted merkleInfo.
- [lib](https://github.com/johnwhitton/horizon/tree/refactorV2/src/lib)
  - [configure.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/lib/configure.js): Configure TokenLocker and Faucet contracts.
  - [ethEthers.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/lib/ethEthers.js): Shim over [ethers](https://www.npmjs.com/package/ethers) allowing the instantiation of connections using a configured private key.
  - [logger.js](https://github.com/johnwhitton/horizon/blob/refactorV2/src/lib/logger.js): Logging Functions
  - [utils.ts](https://github.com/johnwhitton/horizon/blob/refactorV2/src/lib/utils.ts): Utility functions including (buffer2hex, rpcWrapper, toRLPHeader, getReceiptLight, getReceipt, getReceiptRlp, getReceiptTrie,hex2key,index2key, expandkey, getReceiptProof, getTransactionProof, getAccountProof, getStorageProof, getKeyFromProof, fullToMin)

**npm packages**

- [@ethereumjs/block](https://www.npmjs.com/package/@ethereumjs/block): Implements schema and functions related to Ethereum's block. (Ethereum 1.0 or Execution Chain for Ethereum 2.0)
- [ethereumjs-util](https://www.npmjs.com/package/ethereumjs-util): A collection of utility functions for Ethereum. It can be used in Node.js and in the browser with browserify.
- [ethers](https://www.npmjs.com/package/ethers): A complete, compact and simple library for Ethereum and ilk, written in TypeScript.
-
- [miller-rabin](https://www.npmjs.com/package/miller-rabin): implements [Miller Rabin primality test](https://en.wikipedia.org/wiki/Miller%E2%80%93Rabin_primality_test)
- [mmap-io](https://www.npmjs.com/package/mmap-io): Memory Map for node.js
- [sha3](https://www.npmjs.com/package/sha3): A pure JavaScript implementation of the Keccak family of cryptographic hashing algorithms, most notably including Keccak and SHA3.
-

### Light Client Functionality

### Token Lockers

## References

## Appendices

### Appendix A: Current Implementation Walkthough

Following is a detailed walk though of the current implementation of the Ethereum Light Client and the flow for mapping tokens from Ethereum to Harmony.

#### Ethereum Light Client (on Harmony)

**Design**
Existing Design

1. DAG is generated for each Ethereum EPOCH: This takes a couple of hours and has a size of approx 1GB.
2. Relayer is run to replicate each block header to the SPV Client on Harmony.
3. EthereumLightClient.sol addBlockHeader: Adds each block header to the Ethereum Light Client.
4. Transactions are Verified

**Running the Relayer**

```
# Start the relayer (note: replace the etherum light client address below)
# relay [options] <ethUrl> <hmyUrl> <elcAddress>   relay eth block header to elc on hmy
 yarn cli ethRelay relay http://localhost:8645 http://localhost:9500 0x3Ceb74A902dc5fc11cF6337F68d04cB834AE6A22
 ```

**Implementation**

1. DAG Generation can be done explicity by calling `dagProve` from the CLI or it is done automatically by `getHeaderProof` in `ethHashProof/BlockProof.js` which is called from `blockRelay` in `cli/ethRelay.js`.
2. Relaying of Block Headers is done by `blockRelayLoop` in `cli/ethRelay.js` which
    - Reads the last block header from EthereumLightClient.sol
    - Loops through calling an Ethereum RPC per block to retrieve the blockHeader using `return eth.getBlock(blockNo).then(fromRPC)` in function `getBlockByNumber` in `eth2hmy-relay/getBlockHeader.js`
3. Adding BlockHeaders is done by `await elc.addBlockHeader(rlpHeader, proofs.dagData, proofs.proofs)` which is called from `cli/ethRelay.js`. `addBlockHeader` in `EthereumLightClient.sol`
    - calculates the blockHeader Hash
    - and checks that it
        - hasn't already been relayed,
        - is the next block to be added,
        - has a valid timestamp
        - has a valid difficulty  
        - has a valid Proof of Work (POW)
    - Check if the canonical chain needs to be replaced by another fork

### Mapping Tokens (Ethereum to Harmony)

**Design**

1. If the Token Has not already been mapped on Harmony
    - Harmony: Create an ERC20 Token
    - Harmony: Map the Ethereum Token to the new ERC20 Contract
    - Ethereum: Validate the Harmony Mapping Transaction
    - Ethereum: Map the Harmony ERC20 token to the existing Ethereum Token
    - Harmony: Validate the Ethereum mapping Transaction

*Note: The key difference between `TokenLockerOnEthereum.sol` and `TokenLockerOnHarmony.sol` is the proof validation. `TokenLockerOnEthereum.sol` uses `./lib/MMRVerifier.sol` to validate the [Mountain Merkle Ranges](https://github.com/opentimestamps/opentimestamps-server/blob/master/doc/merkle-mountain-range.md) on Harmony and `HarmonyProver.sol`. `TokenLockerOnHarmony.sol` imports `./lib/MPTValidatorV2.sol` to validate [Merkle Patrica Trie](https://ethereum.org/en/developers/docs/data-structures-and-encoding/patricia-merkle-trie/#merkle-patricia-trees) and `./EthereumLightClient.sol`.*

*Note: `validateAndExecuteProof` is responsible for creation of the BridgeTokens on the destination chain it does this by calling `execute` call in `TokenLockerLocker.sol` which then calls the function `onTokenMapReqEvent` in `TokenRegistry.sol` which creates a new Bridge Token `BridgedToken mintAddress = new BridgedToken{salt: salt}();` and then initializes it. This uses [(RLP) Serialization](https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/)*

*Note: The shims in `ethWeb3.js` provide simplified functions for `ContractAt`, `ContractDeploy`, `sendTx` and `addPrivateKey` and have a constructor which uses `process.env.PRIVATE_KEY`.*

**Mapping the Tokens**

```
# Map the Tokens
# map <ethUrl> <ethBridge> <hmyUrl> <hmyBridge> <token>
yarn cli Bridge map http://localhost:8645 0x017f8C7d1Cb04dE974B8aC1a6B8d3d74bC74E7E1 http://localhost:9500 0x017f8C7d1Cb04dE974B8aC1a6B8d3d74bC74E7E1 0x4e59AeD3aCbb0cb66AF94E893BEE7df8B414dAB1
```

**Implementation**

- The CLI calls `tokenMap` in `src/bridge/contract.js` to
  - Instantiate the Ethereum Bridge and Harmony Bridge Contracts
  - Calls `TokenMap` in `scr/bridge/bridge.js` to
    - Issue a token Map request on Ethereum `const mapReq = await src.IssueTokenMapReq(token)`
    - Acknowledge the Map Request on Harmony `const mapAck = await Bridge.CrossRelayEthHmy(src, dest, mapReq)`
    - Issue a token Map request on Harmony `return Bridge.CrossRelayHmyEth(dest, src, mapAck.transactionHash)`
  
**Here is the Logic (call execution overview) when Mapping Tokens across Chains. *NOTE: Currently mapping has only been developed from Ethereum to Harmony (not bi-directional)*.**

1. Bridge Map is called in src.cli.index.js and it calls `tokenMap` in `bridge/contract.js` which
    - Get srcBridge Contract on Ethereum `TokenLockerOnEthereum.sol` from `ethBridge.js` it also instantiates an `eprover` using `tools/eprover/index.js` which calls `txProof.js` which uses [eth-proof npm package](https://www.npmjs.com/package/eth-proof). *Note: this is marked with a //TODO need to test and develop proving logic on Harmony.*
    - Get destBridge Contract on Hamony `TokenLockerOnHarmony.sol` from `hmyBridge.js` it also instantiates an `hprove` using `tools/eprover/index.js` which calls `txProof.js` which uses [eth-proof npm package](https://www.npmjs.com/package/eth-proof).
    - calls `TokenMap` in `bridge.js`
2. `TokenMap` Calls IssueTokenMapReq (on the Ethreum Locker) returning the `mapReq.transactionHash`
    - `IssueTokenMapReq(token)` is held in `bridge.js` as part of the bridge class
    - It calls `issueTokenMapReq` on `TokenLockerOnEthereum.sol` which is implemented by `TokenRegistry.sol`
    - `issueTokenMapReq` checks if the token has already been mapped if not it was emitting a `TokenMapReq` with the details of the token to be mapped. However this was commented out as it was felt that, if it has not been mapped, we use the `transactionHash` of the mapping request` to drive the logic below (not the event).
3. `TokenMap` calls `Bridge.CrossRelay` with the IssueTokenMapReq.hash to
    - gets the proof of the transaction on Ethereum via `getProof` calling `prover.ReceiptProof` which calls the eprover and returns `proof` with
        - `hash: sha3(resp.header.serialize()),`
        - `root: resp.header.receiptRoot,`
        - `proof: encode(resp.receiptProof),`
        - `key: encode(Number(resp.txIndex)) // '0x12' => Nunmber`
    - We then call `dest.ExecProof(proof)` to execute  the proof on Harmony
        - This calls `validateAndExecuteProof` on `TokenLockerOnHarmony.sol` with the `proofData` from above, which
            - requires `lightclient.VerifyReceiptsHash(blockHash, rootHash),` implemented by `./EthereumLightClient.sol`
                - This returns `return bytes32(blocks[uint256(blockHash)].receiptsRoot) == receiptsHash;`
                - **Which means the block has to be relayed first, as we have just executed the transaction the relayer usually has not relayed the block so this will fail**
            - requires `lightclient.isVerified(uint256(blockHash)` implemented by `./EthereumLightClient.sol`
                - This returns `return canonicalBlocks[blockHash] && blocks[blockHash].number + 25 < blocks[canonicalHead].number;`
                - **Which means there must be an additional 25 blocks on Ethereum before this can be processed. This logic needs to be rewritten to break down execution for 1. the ethereum mapping request 2. After a 25 block delay the Harmony Proof validation and executing the Harmony Mapping Request**  
            - `require(spentReceipt[receiptHash] == false, "double spent!");` to ensure that we haven't already executed this proof
            - gets the `rlpdata` using `EthereumProver.validateMPTProof` implemented by `EthereumProver.sol` which
                - Validates a Merkle-Patricia-Trie proof.
                - Returns a value whose inclusion is proved or an empty byte array for a proof of exclusion
            - marks `spentReceipt[receiptHash] = true;`
            - `execute(rlpdata)` implemented by `TokenLocker.sol` which calls `onTokenMapReqEvent(topics, Data)` implemented by `TokenRegistry.sol`
                - `address tokenReq = address(uint160(uint256(topics[1])));` gets the address of the token to be mapped.
                - require `address(RxMapped[tokenReq]) == address(0)` that the token has not already been mapped.
                - `address(RxMapped[tokenReq]) == address(0)` creates a new BridgedToken implemented by `BridgedToken.sol`
                    - `contract BridgedToken is ERC20Upgradeable, ERC20BurnableUpgradeable, OwnableUpgradeable` it is a standard openzepplin ERC20 Burnable, Ownable, Upgradeable token
                - `mintAddress.initialize` initialize the token with the same `name`, `symbol` and `decimals` as the ethereum bridged token
                - `RxMappedInv[address(mintAddress)] = tokenReq;` updates the inverse Key Value Mapping
                - `RxMapped[tokenReq] = mintAddress;` updates the Ethereum mapped tokens
                - `RxTokens.push(mintAddress);` add the newly created token to a list of bridged tokens
                - `emit TokenMapAck(tokenReq, address(mintAddress));`
            - `require(executedEvents > 0, "no valid event")` to check if it executed the mapping correctly.
4. We then take the Harmony Mapping `transactionHash` and repeat the above process to prove the Harmony mapping acknowledgment on Ethereum (Cross Relay second call) `return Bridge.CrossRelay(dest, src, mapAck.transactionHash);`

- gets the proof of the transaction on Harmony via `getProof` calling `prover.ReceiptProof` which calls the eprover and returns `proof` with
        *`hash: sha3(resp.header.serialize()),`
        * `root: resp.header.receiptRoot,`
        *`proof: encode(resp.receiptProof),`
        * `key: encode(Number(resp.txIndex)) // '0x12' => Nunmber`
  - We then call `dest.ExecProof(proof)` to execute the proof on Ethereum
    - This calls `validateAndExecuteProof` on `TokenLokerOnEthereum.sol` with the `proofData` from above, which
      - `require(lightclient.isValidCheckPoint(header.epoch, mmrProof.root),` implemented by `HarmonyLightClient.sol`
        - `return epochMmrRoots[epoch][mmrRoot]` which means that the epoch has to have had a checkpoint submitted via `submitCheckpoint`
      - `bytes32 blockHash = HarmonyParser.getBlockHash(header);` gets the blockHash implemented by `HarmonyParser.sol`  
        - This returns `return keccak256(getBlockRlpData(header));`  
        - `getBlockRlpData`  creates a list `bytes[] memory list = new bytes[](15);` and uses statements like `list[0] = RLPEncode.encodeBytes(abi.encodePacked(header.parentHash));` to perform [Recursive-Length Prefix (RLP) Serialization](https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp/) implemented by `RLPEncode.sol`
      - `HarmonyProver.verifyHeader(header, mmrProof);` verifys the header implemented by `HarmonyProver.sol`
        - `bytes32 blockHash = HarmonyParser.getBlockHash(header);` gets the blockHash implemented by `HarmonyParser.sol` as above
        - `valid = MMRVerifier.inclusionProof(proof.root, proof.width, proof.index, blockHash, proof.peaks, proof.siblings);` verifys the proff using the [Merkle Mountain Range Proof](https://github.com/opentimestamps/opentimestamps-server/blob/master/doc/merkle-mountain-range.md) passed `MMRVerifier.MMRProof memory proof` and the `blockHash`.
        - **NOTE: This means that a `submitCheckpoint` in `HarmonyLightClient.sol` needs to have called either for the next epoch or for a checkpoint, after the block the harmony mapping transaction was in.**
        - **NOTE: Automatic submission of checkpoints to the Harmony Light Client has not been developed as yet. (It is not part of the `ethRelay.js`). And so the checkpoint would need to be manually submitted before the Ethereum Mapping could take place.**
      - `require(spentReceipt[receiptHash] == false, "double spent!");` ensure that we haven't already processed this mapping request`
      - `HarmonyProver.verifyReceipt(header, receiptdata)` ensure the receiptdata is valid
      - `spentReceipt[receiptHash] = true;` marks the receipt as having been processed
      - `execute(receiptdata.expectedValue);` implemented by `TokenLocker.sol` which calls `onTokenMapAckEvent(topics)` implemented by `TokenRegistry.sol`
        - `address tokenReq = address(uint160(uint256(topics[1])));`
        - `address tokenAck = address(uint160(uint256(topics[2])));`
        - `require(TxMapped[tokenReq] == address(0), "missing mapping to acknowledge");`
        - `TxMapped[tokenReq] = tokenAck;`
        - `TxMappedInv[tokenAck] = IERC20Upgradeable(tokenReq);`
        - `TxTokens.push(IERC20Upgradeable(tokenReq));`

5. Upon completion of tokenMap control is passed back to Bridge Map which
6. Calls TokenPair on Ethereum
7. Calls ethTokenInfo to get the status of the ERC20
8. Calls hmyTokenInfo to get the tokenStatus on Harmony
