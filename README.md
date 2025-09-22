# Tezos Native Mobile SDKs

First-class, production-ready native SDKs for iOS (Swift) and Android (Kotlin) that seamlessly integrate Tezos into mobile applications, including support for Beacon (TZIP-10) wallet connections.

## Features

- **Native Mobile SDKs**: iOS (Swift Package Manager) and Android (Kotlin library)
- **Tezos RPC Integration**: Full RPC client with HTTPS enforcement
- **Key Management**: Ed25519 keypair generation and management
- **Operation Support**: Tez transfers, FA1.2, FA2 token transfers
- **Beacon Integration**: TZIP-10 wallet connection protocol
- **Enterprise Security**: Audited, well-documented, open-source
- **CI/CD Ready**: GitHub Actions for automated builds and tests

## Quick Start

### iOS (Swift)

```swift
import TezosMobileSDK

// Initialize RPC client
let rpcURL = URL(string: "https://mainnet.tezos.marigold.dev")!
let config = TezosRPCConfig(rpcURL: rpcURL)
let rpc = TezosRPCClient(config: config)

// Get head hash
let headHash = try await rpc.getHeadHash()
```

### Android (Kotlin)

```kotlin
import io.tezos.mobile.rpc.TezosRpcClient

// Initialize RPC client
val rpcURL = "https://mainnet.tezos.marigold.dev"
val rpc = TezosRpcClient(rpcURL)

// Get head hash
val headHash = rpc.getHeadHash()
```

## Installation

### iOS

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/oxdev6/tezos-mobile-sdk.git", from: "0.1.0")
]
```

### Android

Add to your `build.gradle.kts`:

```kotlin
dependencies {
    implementation("io.tezos:mobile-sdk:0.1.0")
}
```

## Documentation

- [API Documentation](docs/)
- [Live Demo](docs/index.html)
- [Security Policy](SECURITY.md)
- [Audit Preparation](AUDIT_PREP.md)
- [Changelog](CHANGELOG.md)

## Examples

- [iOS CLI Example](examples/ios-cli/)
- [Android App Example](examples/android-app/)

## Contributing

This project is open source and contributions are welcome. Please see our [Security Policy](SECURITY.md) for reporting vulnerabilities.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Website

For more information, visit: https://github.com/oxdev6/tezos-mobile-sdk
