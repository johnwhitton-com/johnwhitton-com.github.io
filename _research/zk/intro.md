---
title:  Zero Knowledge Research
category: zk-intro
date: 2023-02-04
---

## Overview

Here we do a deep dive on Zero Knowledge

* Approach
* Emerging Use Cases
* Proof Systems
* Efficient Signatures
* Proof Aggregation
* Tokenomics

## Learning Material

### Foundational

* [An Introduction to Mathematical Cryptography](https://www.amazon.com/Introduction-Mathematical-Cryptography-Undergraduate-Mathematics/dp/1493917102)
* [Introduction to Applied Linear Algebra](https://www.amazon.com/Introduction-Applied-Linear-Algebra-Matrices/dp/1316518965)
* [Calculus I - Differentiation and Integration](https://www.amazon.com/Calculus-Differentiation-Integration-Hamilton-Education-ebook/dp/B07BPHW4VL)
* [An Introduction to Mathematical Cryptography](https://www.amazon.com/Introduction-Mathematical-Cryptography-Undergraduate-Mathematics-ebook/dp/B00PULZOCI/): the mathematics behind the theory of public key cryptosystems and digital signature schemes.
* [Cryptography Algorithms](https://www.amazon.com/Next-generation-Cryptography-Algorithms-Explained-implementation/dp/1789617138)
* [Number Theory](https://crypto.stanford.edu/pbc/notes/numbertheory/)
* [zkSNARKs in a nutshell](https://blog.ethereum.org/2016/12/05/zksnarks-in-a-nutshell)
* [Quadratic Arithmetic Programs: from Zero to Hero](https://medium.com/@VitalikButerin/quadratic-arithmetic-programs-from-zero-to-hero-f6d558cea649)
* [Exploring Elliptic Curve Pairings](https://medium.com/@VitalikButerin/exploring-elliptic-curve-pairings-c73c1864e627)
* [Zk-SNARKs: Under the Hood](https://medium.com/@VitalikButerin/zk-snarks-under-the-hood-b33151a013f6)
* [The MoonMath Manual to zk-SNARKs](https://leastauthority.com/static/publications/MoonMath080822.pdf)
* [Elliptic Curve Cryptography: a gentle introduction](https://andrea.corbellini.name/2015/05/17/elliptic-curve-cryptography-a-gentle-introduction/)
* [Exploring Elliptic Curve Pairings](https://vitalik.ca/general/2017/01/14/exploring_ecp.html)
* [KZG polynomial commitments](https://dankradfeist.de/ethereum/2020/06/16/kate-polynomial-commitments.html)
* [plookup](https://eprint.iacr.org/2020/315.pdf): A simplified polynomial protocol for
lookup tables.
* [Casting out Primes](https://blog.polygon.technology/wp-content/uploads/2022/10/casting-3.pdf): a nondeterministic method for bignum arithmetic. It is inspired by the “casting out nines” technique, where some identity is checked modulo 9, providing a probabilistic result.

### Zero Knowledge
<!-- Research Articles -->
* [Fraud and Data Availability Proofs](https://arxiv.org/pdf/1809.09044.pdf): Maximising Light Client Security and Scaling Blockchains with Dishonest Majorities. *Light clients, also known as Simple Payment Verification (SPV) clients, are nodes which only download a small portion of the data in a blockchain, and use indirect means to verify that a given chain is valid.*
<!-- Research Papers (Zero Knowledge Related) -->
* [zkBridge: Trustless Cross-chain Bridges Made Practical](https://rdi.berkeley.edu/zkp/zkBridge/uploads/paper.pdf)
* [Caulk: Lookup Arguments in Sublinear Time](https://eprint.iacr.org/2022/621.pdf): position-hiding linkability for vector commitment schemes: one can prove in zero knowledge that one or m values that comprise commitment cm all belong to the vector of size N committed to in C.
* [HyperPlonk: Plonk with Linear-Time Prover and High-Degree Custom Gates](https://eprint.iacr.org/2022/1355.pdf)
* [SLONK—a simple universal SNARK](https://ethresear.ch/t/slonk-a-simple-universal-snark/6420): a simplification to PLONK called SLONK. We replace the permutation argument (the “P” in PLONK) in favour of a shift argument (the “S” in SLONK). We get a universal SNARK with the smallest known proof size and verification time.
* [Kate commitments from the Lagrange basis without FFTs](https://notes.ethereum.org/T0ZVaaywQAqP4jegqO3asg?view): how to commit, evaluate and open polynomials in the Lagrange basis without FFTs. This is the first part in a series (see part 1, part 2, part 3) showing how to do PLONK-style universal SNARKs without FFTs
* [Hadamard checks from the Lagrange basis without FFTs](https://notes.ethereum.org/Il4z42lmQtaUYFigsjsk2Q?view): how to prove Hadamard relations between polynomials in the Lagrange basis without FFTs. This is the second part (see part 1, part 2, part 3) in a series showing how to do PLONK-style universal SNARKs without FFTs.
* [PLONK-style SNARKs without FFTs](https://notes.ethereum.org/DLRqK9V7RIOsTZkab8Hm_Q?view): how to do PLONK-style universal SNARKs without FFTs. This is part 3 in a series (part 1, part 2, part 3).
* [An efficient verifiable state for zk-EVM and beyondfrom the Anemoi hash function](https://eprint.iacr.org/2022/1487.pdf)
* [Plonky2: Fast Recursive Arguments with PLONK and FRI](https://github.com/mir-protocol/plonky2/blob/main/plonky2/plonky2.pdf)

<!-- articles and learning resources -->
* [Bridging the Multichain Universe with Zero Knowledge Proofs](https://medium.com/@ingonyama/bridging-the-multichain-universe-with-zero-knowledge-proofs-6157464fbc86)
* [awesome-zkml](https://github.com/worldcoin/awesome-zkml)
* [https://learn.0xparc.org/](https://learn.0xparc.org/): ZK Learning Resources
* [Delendum ZKP Knowledge base](https://kb.delendum.xyz/)
* [https://appliedzkp.org](https://appliedzkp.org/): Privacy and Scaling Exploration
* [https://zkp.science/](https://zkp.science/): Zero-Knowledge Proofs
* [https://starkware.co/stark-101/](https://starkware.co/stark-101/): Stark 101: write a STARK prover from scratch
* [https://docs.starkware.co/starkex/index.html](https://docs.starkware.co/starkex/index.html): - Starkware StarkeEx
* [Noir](https://docs.aztec.network/developers/noir) Noir is a Domain Specific Language for developing ZK-provable programs. (Rust based)
  * [article](https://medium.com/aztec-protocol/introducing-noir-the-universal-language-of-zero-knowledge-ff43f38d86d9)
  * [tweet](https://twitter.com/aztecnetwork/status/1578082456212643840)
  * [Grants](https://aztec.network/grants/)
* [Arkworks](https://github.com/arkworks-rs)
* [zkrepl.dev](https://zkrepl.dev/)
* [succinct](https://blog.succinct.xyz/)
* [ZK BATCH ECDSA](https://blog.succinct.xyz/post/2022/10/03/batch-ecdsa/)
* [Batch ECDSA Verification](https://github.com/puma314/batch-ecdsa)
* [Bringing IBC to Ethereum using ZK-Snarks](https://ethresear.ch/t/bringing-ibc-to-ethereum-using-zk-snarks/13634)
* [MINA docs](https://docs.minaprotocol.com/)

<!-- implementation articles -->
* [zkPoS: End-to-End Trustless](https://hyperoracle.medium.com/zkpos-end-to-end-trustless-65edccd87c5a): HyperOracle article on how zkPoS provides the ability of proving the consensus with ZK.
* [Succinct Towards the endgame of blockchain interoperability with proof of consensus](https://blog.succinct.xyz/post/2022/09/20/proof-of-consensus)

### Codebases

* [Circom](https://github.com/iden3/circom) a novel domain-specific language for defining arithmetic circuits that can be used to generate zero-knowledge proofs
* [DarkForest](https://github.com/darkforest-eth) zkSNARK space warfare
  * [Awesome List](https://github.com/snowtigersoft/awesome-darkforest)
  * [Our front end code (the game is open source!)](https://github.com/darkforest-eth/client/tree/master/src/Frontend)
  * [Twitter](https://twitter.com/darkforest_eth)
* [Discord](https://discord.gg/2u2TN6v8r6)
  * [Team Blog](http://blog.zkga.me/)
    * [Dark Forest v0.6](https://blog.zkga.me/announcing-v6)
    * [Exploiting DF v0.5 Artifact Minting](https://blog.zkga.me/artifact-minting-exploit)
    * [v0.5 Plugins Contest Winners](https://blog.zkga.me/v5-plugins-contest-winners)
    * [Zero-Knowledge Proofs for Engineers](https://blog.zkga.me/intro-to-zksnarks)
    * [Announcing Dark Forest](https://blog.zkga.me/announcing-darkforest)
    * [The Strongest Crypto Gaming Thesis: Why we're building Dark Forest](https://gubsheep.mirror.xyz/nsteOfjATPSKH0J8lRD0j2iynmvv_C8i8eb483UzcTM)
  * [Community plugins](http://plugins.zkga.me/)
  * [Community-run wiki](http://dfwiki.net/)
  * Player-made content
    * [Dark Forest GPU universe explorer](https://www.longrocklabs.com/articles/the-exploration-era-begins/)
    * [Getting started with Dark Forest](https://www.youtube.com/watch?v=keY4a9cKmgg)
    * [Setting up a remote miner](https://www.youtube.com/watch?v=Kus4fWNg3zo)
    * [Dark Forest battle timelapse](https://www.youtube.com/watch?v=o9A-cfDanTY)

* [halo2ecc-s](https://github.com/DelphinusLab/halo2ecc-s): Re-implement an ecc circuits with halo2

* [plonky2](https://github.com/mir-protocol/plonky2): a SNARK implementation based on techniques from PLONK and FRI. It has since expanded to include tools such as Starky, a highly performant STARK implementation.
  * [plonky2-solidity-verifier](https://github.com/polymerdao/plonky2-solidity-verifier)
  * [plonky2-circom](https://github.com/polymerdao/plonky2-circom): Plonky2 verifier in Circom
  * [plonky2-ed25519](https://github.com/polymerdao/plonky2-ed25519): SNARK verification circuits of a digital signature scheme Ed25519 implemented with Plonky2.
  * [plonky2-sha256](https://github.com/polymerdao/plonky2-sha256): SNARK circuits of a cryptographic hash function SHA-256 implemented with Plonky2.
  * [plonky2-sha512](https://github.com/polymerdao/plonky2-sha512):  SNARK circuits of a cryptographic hash function SHA-512 implemented with Plonky2.
  * [plonky2-pairing](https://github.com/polymerdao/plonky2-pairing)

### Presentations

* [Devcon VI](https://archive.devcon.org/archive/playlists/devcon-6/)
* [Light Client After the Merge](https://archive.devcon.org/archive/watch/6/light-clients-after-the-merge/?playlist=Devcon%206&tab=YouTube) [video](https://www.youtube.com/watch?v=ZHNrAXf3RDE)
* [What to Know about Zero Knowledge](https://archive.devcon.org/archive/watch/6/what-to-know-about-zero-knowledge/?playlist=Devcon%206&tab=YouTube)
* [ZK Application ShowCase](https://archive.devcon.org/archive/watch/6/zk-application-showcase/?playlist=Devcon%206&tab=YouTube)
* [ZK Badges: How to prove that you donated to Gitcoin grants](https://archive.devcon.org/archive/watch/6/zk-badges/?playlist=Devcon%206&tab=YouTube)
* [ZK Security Self Led Session](https://archive.devcon.org/archive/watch/6/zk-security-self-led-session/?playlist=Devcon%206&tab=YouTube)
* [zkEVM Vs EVM: Full Equivalence?](https://archive.devcon.org/archive/watch/6/zkevm-vs-evm-full-equivalence/?playlist=Devcon%206&tab=YouTube)
* [ZK Application Design Patterns](https://archive.devcon.org/archive/watch/6/zk-application-design-patterns/?playlist=Devcon%206&tab=YouTube) [video](https://www.youtube.com/watch?v=-PUKinjbLR8)
* [Applied ZK SLS presentations](https://www.notion.so/360fcd3f2a824759b1373ddeef5bf564)

### Additional Information

* Review [ENS Bridging Strategy](https://medium.com/the-ethereum-name-service/mvp-of-ens-on-l2-with-optimism-demo-video-how-to-try-it-yourself-b44c390cbd67) and [repo](https://github.com/ensdomains/l2gateway-demo/)
* [Succinct](https://blog.succinct.xyz/post/2022/09/20/proof-of-consensus) [$600K](https://forum.gnosis.io/t/gip-57-should-gnosis-dao-support-research-of-a-zksnark-enabled-light-client-and-bridge/5421) [tweet](https://twitter.com/succinctlabs/status/1572299292177481729) [Demo](https://www.zkbridge.wtf/) [github](https://github.com/succinctlabs)  [video](https://youtu.be/Ct6H5GcnA0A?t=15554) built using [circom](https://docs.circom.io/)
* [circom](https://docs.circom.io/)
* [Arkworks](https://github.com/arkworks-rs/), [tutorial](https://github.com/arkworks-rs/r1cs-tutorial/), [twitter](https://twitter.com/arkworks_rs), [video](https://youtu.be/Ct6H5GcnA0A?t=7429)
* [Aztec.network](http://Aztec.network) [Noir](https://aztec.network/noir) [intro](https://medium.com/aztec-protocol/introducing-noir-the-universal-language-of-zero-knowledge-ff43f38d86d9), [github](https://github.com/noir-lang/noir), [twitter](https://twitter.com/aztecnetwork), [docs](https://noir-lang.github.io/book/index.html)
* [GNark](https://github.com/ConsenSys/gnark)
* [ElectronLabs](https://electronlabs.org/)
* [ZKU](https://zku.one/) [Learning](https://www.notion.so/Learning-50b5a6ecc45b46248323f0e552b6885f)
* Review [matter-labs knowledge base](https://github.com/matter-labs/awesome-zero-knowledge-proofs#learn)

* [zkSNARKS explained like you're someone who knows some math and some coding](https://www.reddit.com/r/zkTech/comments/tfjvrj/zksnarks_explained_like_youre_someone_who_knows/)
  
* [The Halo2 Book](https://zcash.github.io/halo2/concepts/proofs.html)
* [A survey of elliptic curves for proof systems](https://eprint.iacr.org/2022/586.pdf)
* zkEVM
  * [zkSync Era](https://era.zksync.io/docs/dev/)
  * [Polygon zkEVM](https://wiki.polygon.technology/docs/zkEVM/develop/)
  * [zkSync zkEVM](https://docs.zksync.io/zkevm/)
  * [ConsenSys zkEVM](https://docs.zkevm.consensys.net/overview)
