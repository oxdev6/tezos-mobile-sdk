# Audit Preparation Checklist

- Dependency review (versions pinned):
  - iOS: CryptoKit (system), URLSession, SwiftPM
  - Android: OkHttp, Moshi, BouncyCastle
- Cryptography:
  - Ed25519 signing watermark (0x03) verified
  - No private key egress or logging
- Network:
  - HTTPS enforced in RPC clients
  - Proper Content-Type/Accept usage
- Operations:
  - Forge/sign/inject flow unit tests planned with mocks
- Beacon:
  - Base64 JSON codecs for pairing/requests
  - Deep-links validated for Temple/Kukai schemes
- CI/CD:
  - Linting and build checks for both SDKs
- Docs:
  - Examples included; API docs generation next
