---
title: Cosmos IBC
category: bridge
date: 2023-02-24
last_update: 2023-04-04
---

# Cosmos IBC

## Overview

Cosmos is a network of the many blockchains built on IBC protocol. The IBC protocol is a universal interoperability protocol that allows two different blockchains to communicate with one another. IBC guarantees reliable, ordered, and authenticated communication. See [Cosmos Network Whitepaper](https://v1.cosmos.network/resources/whitepaper)

Blockchains based on IBC protocol may use validity based proofs for interchain communication. See [IBC Protocol ELI5: What is IBC?](https://medium.com/the-interchain-foundation/eli5-what-is-ibc-def44d7b5b4c)

### Protocol

* [Design](https://github.com/cosmos/ibc): the primary repository for development and documentation
* [Docs](https://tutorials.cosmos.network/academy/3-ibc/): a quick introduction. See also [ibc-go documentation](https://ibc.cosmos.network/)
* [Implementation](https://github.com/cosmos/ibc-go): Implementation in Golang, built as a Cosmos SDK module.
* [Roadmap](https://ibc.cosmos.network/main/roadmap/roadmap.html)

### Bridging

* [Relayer](https://github.com/cosmos/relayer): "...blockchains do not directly pass messages to each other over the network. This is where relayer comes in. A relayer process monitors for updates on opens paths between sets of IBC enabled chains..."
* [Light Clients](https://ibc.cosmos.network/main/ibc/light-clients/overview.html): "...Light clients operate under a strict set of rules which provide security guarantees for state updates and facilitate the ability to verify the state of a remote blockchain using merkle proofs"

### Utilities

* [Explorer](https://hub.mintscan.io/chains/ibc-network): Monitoring interchain activities and messaging in 3D
* [Keplr](https://www.keplr.app/): Wallet designed to work across blockchains on IBC (see [Getting Started with Cosmos IBC Transfers](https://catdotfish.medium.com/getting-started-with-ibc-transfers-276e9ce91e17))

(to be continued)

<!--============ Content below requires significant revision ==========

## Code Review 

Following is a review of [ibc-go](https://github.com/cosmos/ibc-go)

### Signing Mechanisms from [cosmos-sdk](https://github.com/cosmos/cosmos-sdk)
* [bcrypt](https://www.usenix.org/legacy/event/usenix99/provos/provos.pdf)
  * [cosmos-sdk bcrypt](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/bcrypt)
* [ed25519](https://ed25519.cr.yp.to/ed25519-20110926.pdf)
  * [cosmos-sdk ed25519](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/ed25519)
* [ecdsa](https://en.wikipedia.org/wiki/Elliptic_Curve_Digital_Signature_Algorithm)
  * [cosmos-sdk ecdsa](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/internal/ecdsa)
* [secp256k1](https://www.secg.org/sec2-v2.pdf)
  * [cosmos-sdk secp256k1](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/secp256k1)
  * [secp256r1](https://www.secg.org/sec2-v2.pdf)
    * [cosmos-sdk secp256r1](https://github.com/cosmos/cosmos-sdk/tree/main/crypto/keys/secp256r1)

* [merkle.go](https://github.com/cosmos/ibc-go/blob/main/modules/core/23-commitment/types/merkle.go)

### Proving Mechanisms

### Relayer Mechanisms

* [e2e relayer.go](https://github.com/cosmos/ibc-go/blob/main/e2e/relayer/relayer.go) uses [strangelove-ventures interchaintest relayer](https://github.com/strangelove-ventures/interchaintest/tree/main/relayer)
  * [cosmos-relayer.go](https://github.com/strangelove-ventures/interchaintest/blob/main/relayer/rly/cosmos_relayer.go)

### Light Client Functionality
* [light-clients](https://github.com/cosmos/ibc-go/tree/main/modules/light-clients)

### Token Lockers

## References

## Appendices-->
