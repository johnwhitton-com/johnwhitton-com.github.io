---
title:  Crosschain Bridge Analysis - An Introduction
category: bridge-intro
date: 2023-02-04
---


Here we present a survey of existing bridge designs, historical security incidents, and a brief discussion of common components and where ZKP may be used.

## Bridge Taxonomy

Bridge designs evolved as DeFi and multi-chain paradigm gained popularity. Our summary is inspired by prior taxonomy work by [Ganesha Upadhyaya](https://twitter.com/gupadhyaya) in [A Classification of Various Bridging Technologies](https://medium.com/harmony-one/harmonys-cross-chain-future-41d02d53b10), [Dmitriy Berenzon](https://twitter.com/dberenzon) in [Blockchain Bridges: Building Networks of Cryptonetworks](https://medium.com/1kxnetwork/blockchain-bridges-5db6afac44f8), and by multiple researchers from Jump Crypto in [Security Stack-Up: How Bridges Compare](https://jumpcrypto.com/security-stack-up-how-bridges-compare/)

> At a very high level, there are two types of bridging solutions: 1) proof-based and 2) committee-based. The proof-based solutions entail cryptographic proving of the validity of any transaction of one chain in the other, whereas the committee-based solution relies on the social consensus of the bridge validators to attest for the transaction validity, which often involves no cryptographic proving.
>
> - Ganesha Upadhyaya in "A Classification of Various Bridging Technologies"

### Proof Based

#### Validity Proofs

Validity-proof based bridges prioritize security, trustlessness, permissionlessness, and delay minimization

| Type | Design | Code | UI  | Note |
| ---- | ------ | ---- | --- | ---- |
| ZKP | [zkBridge](https://rdi.berkeley.edu/zkp/zkBridge/uploads/paper.pdf) | TBD | TBD | By Berkeley researcehrs ([Twitter](https://twitter.com/zkcollective)) |
| ZKP | [Telepathy](https://docs.telepathy.xyz/protocol/overview) | [Telepathy](https://github.com/succinctlabs?q=telepathy&type=all&language=&sort=) | [Demo](https://demo.telepathy.xyz/) | By [Succint Labs](https://succinct.xyz) |
| Native | [Horizon](https://arxiv.org/pdf/2101.06000.pdf) | [Horizon](https://github.com/harmony-one/horizon) | TBD | Inactive. By Harmony|
| Native | [IBC](https://github.com/cosmos/ibc) ([Intro](https://tutorials.cosmos.network/academy/3-ibc/1-what-is-ibc.html)) | [ibc-go](https://github.com/cosmos/ibc-go) | Various / [Explorer](https://hub.mintscan.io/chains/ibc-network) | Within Cosmos Network |
| Native | [Gravity](https://github.com/Gravity-Bridge/Gravity-Bridge/blob/main/docs/design/overview.md) | [Gravity](https://github.com/Gravity-Bridge/Gravity-Bridge) | [Gravity](https://bridge.blockscape.network/) | Ethereum <-> Cosmos |
| Native | [AWM](https://github.com/ava-labs/xsvm) ([Intro](https://medium.com/avalancheavax/avalanche-warp-messaging-awm-launches-with-the-first-native-subnet-to-subnet-message-on-avalanche-c0ceec32144a)) | [Wrap](https://github.com/ava-labs/avalanchego/tree/master/vms/platformvm/warp) / [XSVM](https://github.com/ava-labs/xsvm) | TBD / [Explorer](https://subnets.avax.network/subnets) | Within Avalanche Subnets
| Native | [Snowbridge](https://docs.snowbridge.network/architecture/overview) | [snowbridge](https://github.com/Snowfork/snowbridge) | TBD |
| LCP | [Datachain LCP](https://medium.com/lcp-network/lcp-a-proxy-for-light-client-verification-to-realize-trust-minimized-and-gas-efficient-f7d5868e4b0) | [LCP](https://github.com/datachainlab/lcp) / [Demo](https://github.com/datachainlab/harmony-cosmos-bridge-demo)                                                                                                                                                           | TBD | Relies on TEE enclave |
| LCP | [Avalanche](https://medium.com/avalancheavax/avalanche-bridge-secure-cross-chain-asset-transfers-using-intel-sgx-b04f5a4c7ad1)                                                                                                                                              | TBD / [Audit](https://github.com/ava-labs/audits/blob/main/bridge/Avalanche_Bridge_Security_Audit_Report_Halborn_v1_1.pdf) | [core.app](https://core.app/bridge/)                                                                                                                                                                 | Relies on TEE enclave (Intel SGX) |

#### Fraud Proofs

Fraud-proof based bridges assume all participants are truthful unless someone presents a proof showing otherwise. As a result, they must leave a wide fraud-proof time window and carefully design economic incentives for such. This limitation inevitably incurs much higher delay, but makes implementation substantially easier and costs significantly less to operate and maintain. Fraud-proof based bridges face more security risks due to reliance on fraud-prover and economic incentives, but still far less risky than committee-based bridges.

| Design | Code | UI  | Note |
| ------ | ---- | --- | ---- |
| [Rainbow](https://near.org/blog/eth-near-rainbow-bridge/) | [rainbow-bridge](https://github.com/aurora-is-near/rainbow-bridge) | [rainbowbridge.app](https://rainbowbridge.app/transfer) | By NEAR |
| [Nomad](https://docs.nomad.xyz/governance-bridge/architecture) ([Intro](https://medium.com/nomad-xyz-blog/the-nomad-design-philosophy-6fc0eacf3263)) | [monorepo](https://github.com/nomad-xyz/monorepo) | [app.nomad.xyz](https://app.nomad.xyz/) | Hacked \$200M (engineering flaw) |
| [Darwinia](https://docs.darwinia.network/) ([Paper](https://darwinia.network/itering_io_optimistic_bridge_technical_paper_en.pdf)) | [darwinia](https://github.com/darwinia-network/darwinia) | TBD / [Explorer](https://darwinia.subscan.io/) |

### Committee Based

| Sub Category         | Type                               | Design/Docs                                                                                                                                                                                                                                                                   | Implementation                                                                                                                                                                                                                                     | Frontend                                                                                                                                                                                                             |
| ----------------- | -------------------- | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Protocol Validators  |                                    | [Cosmos Gravity Bridge](https://www.gravitybridge.net/faq)                                                                                                                                                                                                                    | [gravity-bridge](https://github.com/cosmos/gravity-bridge)                                                                                                                                                                                         | [https://bridge.blockscape.network/](https://bridge.blockscape.network/) [https://emeris.com/ (ON HOLD)](https://emeris.com/)                                                                                        |
| Proof of Stake Chain |                                    | [Axelar](https://axelar.network/axelar_whitepaper.pdf) [docs](https://docs.axelar.dev/)                                                                                                                                                                                       | [axelar-core](https://github.com/axelarnetwork/axelar-core)                                                                                                                                                                                        | TBD                                                                                                                                                                                                                  |
| Proof of Stake Chain |                                    | [Celer cBridge](https://cbridge-docs.celer.network/) [Celer Network Whitepaper](https://celer.network/doc/CelerNetwork-Whitepaper.pdf)                                                                                                                                        | [cBridge-node](https://github.com/celer-network/cBridge-node), [cBridge-contracts](https://github.com/celer-network/cBridge-contracts), [cBridge-cowa](https://github.com/celer-network/cbridge-cowa)                                              | [https://cbridge.celer.network/](https://cbridge.celer.network/)                                                                                                                                                     |
| External Networks    | Multisig                           | [Horizon 1.0](https://medium.com/harmony-one/introducing-horizon-an-ethereum-harmony-cross-chain-bridge-2f56ed7214b3)                                                                                                                                                         | [github](https://github.com/harmony-one/horizon)                                                                                                                                                                                                   | OBSOLETE                                                                                                                                                                                                             |
| External Networks    | Multisig                           | [Wormhole](https://book.wormhole.com/wormhole/2_architectureOverview.html)                                                                                                                                                                                                    | [wormhole](https://github.com/wormhole-foundation/wormhole)                                                                                                                                                                                        | [network](https://wormhole.com/network/) [ecosystem](https://wormhole.com/ecosystem/)                                                                                                                                |
| External Networks    | Decentralized Oracle Network (DON) | [Chainlink (CCIP)](https://blog.chain.link/introducing-the-cross-chain-interoperability-protocol-ccip/), [web](https://chain.link/cross-chain) [Chainlink Whitepaper](https://research.chain.link/whitepaper-v2.pdf?_ga=2.40239147.884807142.1677705772-204109244.1677705772) | [ccip-read](https://github.com/smartcontractkit/ccip-read)                                                                                                                                                                                         | N/A                                                                                                                                                                                                                  |
| External Networks    | Decentralized Oracle Network (DON) | [LayerZero](https://layerzero.network/pdf/LayerZero_Whitepaper_Release.pdf), [docs](https://layerzero.gitbook.io/docs/)                                                                                                                                                       | [LayerZero](https://github.com/LayerZero-Labs/LayerZero)                                                                                                                                                                                           | [https://theaptosbridge.com/bridge](https://theaptosbridge.com/bridge) [https://bitcoinbridge.network/bridge](https://bitcoinbridge.network/bridge) [https://bridge.harmony.one/one](https://bridge.harmony.one/one) |
| External Networks    | Multi-Party Communication (MPC)    | [Multichain bridge](https://docs.multichain.org/getting-started/introduction)                                                                                                                                                                                                 | [Cross-Chain-Bridge](https://github.com/anyswap/CrossChain-Bridge)                                                                                                                                                                                 | [https://bsc.anyswap.exchange/](https://bsc.anyswap.exchange/bridge#/router)                                                                                                                                         |
| External Networks    | Multi-Party Communication (MPC)    | [Synapse Protocol](https://medium.com/synapse-protocol/introducing-synapse-protocol-2af926143deb), [docs](https://docs.synapseprotocol.com/)                                                                                                                                  | [synapsecns](https://github.com/orgs/synapsecns/repositories)                                                                                                                                                                                      | [https://synapseprotocol.com/](https://synapseprotocol.com/)                                                                                                                                                         |

### Others

| Sub Category         | Type                               | Design/Docs                                                                                                                                                                                                                                                                   | Implementation                                                                                                                                                                                                                                     | Frontend                                                                                                                                                                                                             |
| ----------------- | -------------------- | ---------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| rollup-to-rollup  |                      |                                    | [Hop Protocol](https://hop.exchange/whitepaper.pdf), [docs](https://docs.hop.exchange/basics/a-short-explainer)                                                                                                                                                               | [contracts](https://github.com/hop-protocol/contracts)                                                                                                                                                                                             | [https://app.hop.exchange/](https://app.hop.exchange/)                                                                                                                                                               |
| mesh-network      |                      |                                    | [Router Protocol](https://docs.routerprotocol.com/whitepaper/introducing-router-protocol/architecture), [docs](https://dev.routerprotocol.com/)                                                                                                                               | [Router Protocol](https://github.com/orgs/router-protocol/repositories)                                                                                                                                                                            | [https://app.thevoyager.io/swap](https://app.thevoyager.io/swap)                                                                                                                                                     |
| Bridge Components |                      |                                    | [Parity Bridges Common](https://github.com/paritytech/parity-bridges-common#high-level-architecture)                                                                                                                                                                          | [parity-bridges-common](https://github.com/paritytech/parity-bridges-common)                                                                                                                                                                       | TBD                                                                                                                                                                                                                  |

### Miscellaneous

- TVL of bridges can be found on [DeFi Llama](https://defillama.com/protocols/Bridge)
- Some tools and queries are already prepared on Dune Analytics for analysis of bridge volume. See for example: <https://dune.com/queries/511393>.

## Bridging Components

Following are the main components for Cross-Chain Bridges we review

- Approach : The design approach for the bridge
- Proving Mechanisms: How do we ensure transactions are valid
  - Transaction Proofs: How do we ensure a transacion was included in a valid block
  - Block Proofs: How do we ensure a block was included in the canonical chain
- Relayer Mechanisms
  - Relaying: How do we relay messages (blocks and transactions) between chains
- Light Clients: What Light client approaches can we leverage
- Token Lockers: How do we safely store bridged assets in a trustless cost effective way
- Multi-chain support: What chains are supported and what is the proces to add additional chains.
- Economics: What are the costs for bridging between chains and how do we secure and incentivize validators and relayers.

## Cross Chain Communication Protocols

- [INTER‑BLOCKCHAINCOMMUNICATION PROTOCOL](https://ibcprotocol.org/)
- [Cosmos IBC: Interchain Standards](https://github.com/cosmos/ibc)
- [IBC Update— The Internet of Blockchains Is Growing Fast](https://blog.cosmos.network/ibc-update-the-internet-of-blockchains-is-growing-fast-dae883228ebf)
- [Polkadot Cross-Consensus Message (XCM) Format](https://github.com/paritytech/xcm-format/blob/master/README.md)
- [XCMP Design](https://research.web3.foundation/en/latest/polkadot/XCMP/index.html)
- [HRMP Channels](https://research.web3.foundation/en/latest/polkadot/XCMP/HRMP%20channels.html)
- [The Path of a Parachain Block](https://polkadot.network/blog/the-path-of-a-parachain-block/)
- [Parity Bridges Common](https://github.com/paritytech/parity-bridges-common/blob/master/README.md)

## Bridge Attack Vectors and Hacks

Following is an overview of some common bridge attack vectors.

- [Vitalik; security limits of bridges](https://old.reddit.com/r/ethereum/comments/rwojtk/ama_we_are_the_efs_research_team_pt_7_07_january/hrngyk8/)

> Now, imagine what happens if you move 100 ETH onto a bridge on Solana to get 100 Solana-WETH, and then Ethereum gets 51% attacked. The attacker deposited a bunch of their own ETH into Solana-WETH and then reverted that transaction on the Ethereum side as soon as the Solana side confirmed it. The Solana-WETH contract is now no longer fully backed, and perhaps your 100 Solana-WETH is now only worth 60 ETH. Even if there's a perfect ZK-SNARK-based bridge that fully validates consensus, it's still vulnerable to theft through 51% attacks like this.
>
> It's always safer to hold Ethereum-native assets on Ethereum or Solana-native assets on Solana than it is to hold Ethereum-native assets on Solana or Solana-native assets on Ethereum. And in this context, "Ethereum" refers not just to the base chain, but also any proper L2 that is built on it. If Ethereum gets 51% attacked and reverts, Arbitrum and Optimism revert too, and so "cross-rollup" applications that hold state on Arbitrum and Optimism are guaranteed to remain consistent even if Ethereum gets 51% attacked. And if Ethereum does not get 51% attacked, there's no way to 51% attack Arbitrum and Optimism separately. Hence, holding assets issued on Optimism wrapped on Arbitrum is still perfectly safe.
>
> Why a rollup can't just "go use another data layer". If a rollup stores its data on Celestia or BCH or whatever else but deals with assets on Ethereum, if that layer gets 51% attacked you're screwed. The DAS on Celestia providing 51% attack resistance doesn't actually help you because the Ethereum network isn't reading that DAS; it would be reading a bridge, which would be vulnerable to 51% attacks. To be a rollup that provides security to applications using Ethereum-native assets, you have to use the Ethereum data layer (and likewise for any other ecosystem).

Here are some sample hacks

- [Vulnerabilities in Cross-chain Bridge Protocols Emerge as Top Security Risk](https://blog.chainalysis.com/reports/cross-chain-bridge-hacks-2022/)

> Following last night’s exploit of the Nomad Bridge, Chainalysis estimates that $2 billion in cryptocurrency has been stolen across 13 separate cross-chain bridge hacks, the majority of which was stolen this year. Attacks on bridges account for 69% of total funds stolen in 2022 so far.

- [EXPLAINED: THE QUBIT HACK (JANUARY 2022)](https://halborn.com/explained-the-qubit-hack-january-2022/)

> The exploited contract used a modified safeTransferFrom() function which instead of making use of functionCall() to verify that the target address contained contract code, used the call() function directly. As the 0 address has no code at all, no code is run, and the call is completed successfully without reverting. As a result, the deposit function executed successfully but no real tokens were deposited.
>
> The Ethereum QBridge caught the Deposit event and interpreted it as a valid deposit of ETH.  As a result, qXETH tokens were minted for the attacker on BSC.

- [EXPLAINED: THE WORMHOLE HACK (FEBRUARY 2022)](https://halborn.com/explained-the-wormhole-hack-february-2022/)

> The actual extraction of 120k ETH from the Wormhole bridge came at the end of a series of events.  The actual flow of the attack was:
>
> 1. The attacker creates a validator action approval (VAA) with a call to post_vaa
> 2. This VAA was used in a call to complete_wrapped to mint the 120,000 ETH extracted in the attack
> 3. The attacker “legitimately” extracted the minted tokens from the bridge
>
> The vulnerability that made the attack possible was a failure to perform proper signature verification in the VAA creation process.  The role of signature verification is delegated several times from post_vaa to verify_signatures to Secp256k1.
- [EXPLAINED: THE RONIN HACK (MARCH 2022)](https://halborn.com/explained-the-ronin-hack-march-2022/)

> The Ronin Network attack was extremely stealthy.  In fact, the hack wasn’t noticed until six days after it occurred when the project team was notified by a user that they couldn’t withdraw about 5k ETH from the project’s bridge.  Further investigation discovered the largest hack in DeFi history to date.
>
> The Ronin Network hack was made possible by compromised private keys.  The Ronin Network uses a set of nine validator nodes to approve transactions on the bridge, and a deposit or withdrawal requires approval by a majority of five of these nodes.  The attacker gained control of four validators controlled by Sky Mavis and a third-party Axie DAO validator that signed their malicious transactions.

- [EXPLAINED: THE HARMONY HORIZON BRIDGE HACK](https://halborn.com/explained-the-harmony-horizon-bridge-hack/)

> Like most cross-chain bridges, the Harmony Horizon Bridge has a validation process for approving transactions being transferred over the bridge.  In this case, the approvals process uses a multi-signature scheme with five validators.
>
> However, the bridge only used a 2 of 5 validation scheme.  This means that only two blockchain accounts needed to be compromised for an attacker to approve any malicious transaction that they wished.
>
> The Harmony Horizon bridge was exploited via the theft of two private keys.  These private keys were encrypted with both a passphrase and a key management service, and no system had access to multiple plaintext keys.  However, the attacker managed to access and decrypt multiple keys.
>
> With access to two of the bridge’s private keys, the attacker could create a transaction extracting $100 million from the bridge and confirm it using two accounts under their control.

- [THE NOMAD BRIDGE HACK: A DEEPER DIVE](https://halborn.com/the-nomad-bridge-hack-a-deeper-dive/)

> On August 1, DeFi bridge Nomad was hacked for over $190M.
>
> After a frenzied hack from hundreds of wallets, the bridge’s TVL dropped from $190,740,000 to $1,794 in mere hours. The hack involved a total of 960 transactions with 1,175 individual withdrawals from the bridge.
According to Nomad’s post-mortem, an implementation bug in a June 21 smart contract upgrade caused the Replica contract to fail to authenticate messages properly.  This issue meant that any message could be forged as long as it had not already been processed.
>
> As a result, contracts relying on the Replica for authentication of inbound messages suffered security failures.  From there, this authentication failure resulted in fraudulent messages being passed to the Nomad BridgeRouter contract.

## References
<!-- Background and Overview -->
- [Harmony’s Cross-Chain Future](https://medium.com/harmony-one/harmonys-cross-chain-future-41d02d53b10)
- [Awesome Interoperability](https://github.com/nomad-xyz/awesome-interop): A curated list of awesome interoperability resources, libraries, tools and more.
- [Vitalik: why the future will be *multi-chain*, but it will not be *cross-chain*](https://twitter.com/vitalikbuterin/status/1479501366192132099?lang=en)
- [Vitalik’s Annotated Ethereum 2.0 Spec](https://notes.ethereum.org/@vbuterin/SkeyEI3xv)

<!-- Background and Overview (Zero Knowledge Related) -->
- [Bridging the Multichain Universe with Zero Knowledge Proofs](https://medium.com/@ingonyama/bridging-the-multichain-universe-with-zero-knowledge-proofs-6157464fbc86)
- [awesome-zkml](https://github.com/worldcoin/awesome-zkml)

<!-- Mathematical Theory -->
- [Elliptic Curve Cryptography: a gentle introduction](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/)
- [Exploring Elliptic Curve Pairings](https://vitalik.ca/general/2017/01/14/exploring_ecp.html)

<!-- Mathematical Theory (Zero Knowledge Related) -->
- [KZG polynomial commitments](https://dankradfeist.de/ethereum/2020/06/16/kate-polynomial-commitments.html)

<!-- Research Papers -->
- [Fraud and Data Availability Proofs](https://arxiv.org/pdf/1809.09044.pdf): Maximising Light Client Security and Scaling Blockchains with Dishonest Majorities. *Light clients, also known as Simple Payment Verification (SPV) clients, are nodes which only download a small portion of the data in a blockchain, and use indirect means to verify that a given chain is valid.*

<!-- Research Articles -->
- [Paths toward single-slot finality](https://notes.ethereum.org/@vbuterin/single_slot_finality): A look at how to improve Ethereum’s LMD GHOST + Casper FFG consensus.

<!-- Research Papers (Zero Knowledge Related) -->
- [zkBridge: Trustless Cross-chain Bridges Made Practical](https://rdi.berkeley.edu/zkp/zkBridge/uploads/paper.pdf)
- [zkPoS: End-to-End Trustless](https://hyperoracle.medium.com/zkpos-end-to-end-trustless-65edccd87c5a): HyperOracle article on how zkPoS provides the ability of proving the consensus with ZK.
- [Caulk: Lookup Arguments in Sublinear Time](https://eprint.iacr.org/2022/621.pdf)
- [HyperPlonk: Plonk with Linear-Time Prover and High-Degree Custom Gates](https://eprint.iacr.org/2022/1355.pdf)

<!-- Research Articles (Zero Knowledge Related) -->
- [SLONK—a simple universal SNARK](https://ethresear.ch/t/slonk-a-simple-universal-snark/6420): a simplification to PLONK called SLONK. We replace the permutation argument (the “P” in PLONK) in favour of a shift argument (the “S” in SLONK). We get a universal SNARK with the smallest known proof size and verification time.
- [Kate commitments from the Lagrange basis without FFTs](https://notes.ethereum.org/T0ZVaaywQAqP4jegqO3asg?view): how to commit, evaluate and open polynomials in the Lagrange basis without FFTs. This is the first part in a series (see part 1, part 2, part 3) showing how to do PLONK-style universal SNARKs without FFTs
- [Hadamard checks from the Lagrange basis without FFTs](https://notes.ethereum.org/Il4z42lmQtaUYFigsjsk2Q?view): how to prove Hadamard relations between polynomials in the Lagrange basis without FFTs. This is the second part (see part 1, part 2, part 3) in a series showing how to do PLONK-style universal SNARKs without FFTs.
- [PLONK-style SNARKs without FFTs](https://notes.ethereum.org/DLRqK9V7RIOsTZkab8Hm_Q?view): how to do PLONK-style universal SNARKs without FFTs. This is part 3 in a series (part 1, part 2, part 3).

<!-- Implementation Articles -->
- [zkBridge: Trustless Cross-chain Bridges Made Practical](https://rdi.berkeley.edu/zkp/zkBridge/zkBridge.html)
- [Succinct Towards the endgame of blockchain interoperability with proof of consensus](https://blog.succinct.xyz/post/2022/09/20/proof-of-consensus)

<!-- Implementations -->
- [Wormhole ethereum contracts Implementaion.sol](https://github.com/wormhole-foundation/wormhole/blob/dev.v2/ethereum/contracts/Implementation.sol)
- [bls verification contract](https://github.com/semaraugusto/bls-verification-contract/blob/master/contracts/verifier.sol)

<!-- Documentation -->
- [ETHEREUM DEVELOPMENT DOCUMENTATION](https://ethereum.org/en/developers/docs/)
- [MINA docs](https://docs.minaprotocol.com/)

<!-- Additional References -->

- [nil-Foundation ETH-Mina bridge live on Ethereum testnet Ropsten](https://minacrypto.com/2022/04/27/nil-foundation/)

## Bridge Implementation References

- [Harmony Horizon Bridge](./harmony-horizon): Detailed code review
  - [Horizon](https://github.com/johnwhitton/horizon/tree/refactorV2): javascript, solidity
- [Near Rainbow Bridge](./ethereum-near): Detailed code review
  - [Near Rainbow Bridge](https://github.com/aurora-is-near/rainbow-bridge): rust, go, solidity, javascript
  - [Near Rainbow Token Connector](https://github.com/aurora-is-near/rainbow-token-connector): soldity
  - SDK
    - [Near Rainbow Bridge Client](https://github.com/aurora-is-near/rainbow-bridge-client/tree/main/packages/client): typescript
  - Frontend
    - [NEAR Rainbow Bridge Frontend](https://github.com/aurora-is-near/rainbow-bridge-frontend)
- [Nomad monprepo](https://github.com/nomad-xyz/monorepo): Nomad is a cross-chain communication protocol. This repo contains the following: Smart contracts for the core Nomad protocol, Smart contracts for the Nomad token bridge SDKs for Nomad's core protocol, bridge, and governance systems, Tooling for local environment simulation and Smart contract deployment tooling.
  - [Nomad rust](https://github.com/nomad-xyz/rust): Nomad is a cross-chain communication standard that supports passing messages between blockchains easily and inexpensively. Like IBC light clients and similar systems, Nomad establishes message-passing channels between chains. Once a channel is established, any application on that chain can use it to send messages to others chains.
  - [Nomad gelato-sdk](https://github.com/nomad-xyz/gelato-sdk): This crate reimplements Gelato's Relay SDK in Rust. It simply wraps Gelato Relay requests and responses to/from Gelato endpoints with Rust types and methods.
- [Succinct labs](../bridge/succinct): Deep dive on Succinct labs Proof of Consensus for Ethreum.
  - [Proof of Consensus for Ethereum](https://github.com/succinctlabs/eth-proof-of-consensus): contains both the zkSNARK circuits as well as the smart contracts needed for our succinct light client implementation, as well as prototype message passing contracts and bridge contracts.
- [Datachain lcp](https://github.com/datachainlab/harmony-cosmos-bridge-demo)A proxy for light client verification executed in TEE.
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
