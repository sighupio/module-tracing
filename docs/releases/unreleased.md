# Tracing Core Module Release vTBD

Welcome to the latest release of the `tracing` module of [`SIGHUP Distribution`](https://github.com/sighupio/distribution)
maintained by team SIGHUP by ReeVo.

This release adds the support to Kubernetes 1.36 and updates Grafana Tempo & MinIO.

## Component Images 🚢

| Component  | Supported Version                                                                                             | Previous Version               |
|------------|---------------------------------------------------------------------------------------------------------------|--------------------------------|
| `tempo-distributed` | [`2.10.8`](https://github.com/grafana/tempo/releases/tag/v2.10.8)           | `2.10.5`              |
| `minio-ha` | [`RELEASE.2026-07-17T12-07-51Z`](https://github.com/chainguard-forks/minio/tree/RELEASE.2026-07-17T12-07-51Z) | `RELEASE.2026-05-20T23-44-52Z` |

## Features ✨

### MinIO

Added two new Prometheus alerts:

- `MinioClusterErasureSetQuorumLost`, fired when an erasure set loses quorum and MinIO can no longer guarantee
  reads/writes for that pool.
- `MinioKmsUnavailable`, fired when the KMS backend is offline and SSE-KMS operations fail.

## Breaking Changes 💔

None.

## Update Guide 🦮

### Upgrade using the distribution

To upgrade the module using the distribution please refer to the [`official documentation`](https://docs.sighup.io/docs/upgrades/upgrades)

### Manual Upgrade

ℹ️ **Note:** Manually upgrading the module is deprecated. It is recommended to use it with the [`SIGHUP Distribution`](https://github.com/sighupio/distribution).

To upgrade the module run:

```bash
kustomize build | kubectl apply -f - --server-side
```
