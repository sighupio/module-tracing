<!-- markdownlint-disable MD033 MD045 -->
<h1 align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
  <source media="(prefers-color-scheme: light)" srcset="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/black-logo.png">
  <img alt="Shows a black logo in light color mode and a white one in dark color mode." src="https://raw.githubusercontent.com/sighupio/distribution/refs/heads/main/docs/assets/white-logo.png">
</picture><br/>
  Tracing Module
</h1>
<!-- markdownlint-enable MD033 MD045 -->

![Release](https://img.shields.io/badge/Latest%20Release-v1.5.0-blue)
![License](https://img.shields.io/github/license/sighupio/module-tracing?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <SD-DOCS> -->

**Tracing Module** provides a tracing stack for [SIGHUP Distribution (SD)][kfd-repo].

If you are new to SD please refer to the [official documentation][kfd-docs] on how to get started with SD.

## Overview

**Tracing Module** uses a collection of open source tools to provide a resilient and robust tracing stack for the cluster, built around Grafana [Tempo][tempo-page]. All the components are deployed in the `tracing` namespace.

## Packages

The following packages are included in Tracing Module:

| Package                                        | Version                        | Description                     |
| ---------------------------------------------- | ------------------------------ | ------------------------------- |
| [tempo-distributed](katalog/tempo-distributed) | `2.10.5`                       | Distributed Tempo deployment    |
| [minio-ha](katalog/minio-ha)                   | `RELEASE.2026-05-20T23-44-52Z` | Three nodes HA MinIO deployment |

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.29.x`           | :white_check_mark: | No known issues |
| `1.30.x`           | :white_check_mark: | No known issues |
| `1.31.x`           | :white_check_mark: | No known issues |
| `1.32.x`           | :white_check_mark: | No known issues |
| `1.33.x`           | :white_check_mark: | No known issues |
| `1.34.x`           | :white_check_mark: | No known issues |
| `1.35.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

**Tracing Module** is part of SIGHUP Distribution (SD) and is deployed automatically by [`furyctl`][furyctl-repo] when you create or update a cluster. You don't need to download, vendor or install its packages manually.

### Configuration

You configure the module under `spec.distribution.modules.tracing` in your `furyctl.yaml`. The `type` field selects whether the tracing stack is deployed: `tempo` to deploy Grafana Tempo (the default), or `none` to disable the module. The other fields are optional and fall back to sensible defaults.

```yaml
apiVersion: kfd.sighup.io/v1alpha2
kind: KFDDistribution
spec:
  distribution:
    modules:
      tracing:
        type: tempo
        minio:
          storageSize: "20Gi"
```

See the configuration reference for your cluster kind for the full list of available options: [EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd] or [OnPremises][schema-reference-onprem].

To install SD from scratch, follow the [Getting started][getting-started] guide.

### Sending traces to Tempo

To send traces from an instrumented application to Tempo, point the application to the Distributor's service:

```plaintext
tempo-distributed-distributor.tracing.svc.cluster.local:4317
```

> [!NOTE]
> `4317` is the port for the OpenTelemetry Protocol (OTLP). The Distributor supports other protocols, but OTLP is recommended for performance reasons.

> [!WARNING]
> For production workloads, it is better to use something like the [OpenTelemetry Collector][otel-collector] instead of pushing traces directly to Tempo, so the application can offload traces quickly and minimize the impact on its performance.

<!-- Links -->

[tempo-page]: https://github.com/grafana/tempo
[kfd-repo]: https://github.com/sighupio/distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kfd-docs]: https://docs.sighup.io/docs/distribution/
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulestracing
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulestracing
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulestracing
[getting-started]: https://docs.sighup.io/docs/getting-started/
[compatibility-matrix]: https://github.com/sighupio/module-tracing/blob/main/docs/COMPATIBILITY_MATRIX.md
[otel-collector]: https://opentelemetry.io/docs/collector/#when-to-use-a-collector

<!-- </SD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](https://github.com/sighupio/distribution/blob/main/docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problem with the module, please [open a new issue](https://github.com/sighupio/module-tracing/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE).

<!-- </FOOTER> -->
