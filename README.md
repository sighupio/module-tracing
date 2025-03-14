<!-- markdownlint-disable MD033 MD045 -->
<h1>
    <img src="https://github.com/sighupio/fury-distribution/blob/main/docs/assets/fury-epta-white.png?raw=true" align="left" width="90" style="margin-right: 15px"/>
    Kubernetes Fury Tracing
</h1>
<!-- markdownlint-enable MD033 MD045 -->

![Release](https://img.shields.io/badge/Latest%20Release-v1.2.0-blue)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-tracing?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <KFD-DOCS> -->

**Kubernetes Fury Tracing** provides a tracing stack for the [Kubernetes Fury Distribution (KFD)][kfd-repo].

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Overview

**Kubernetes Fury Tracing** uses a collection of open source tools to provide the most resilient and robust tracing stack for the cluster.

The module contains the [tempo][tempo-page] tool from grafana.

All the components are deployed in the `tracing` namespace in the cluster.

| Package                                        | Version                         | Description                     |
| ---------------------------------------------- | ------------------------------- | ------------------------------- |
| [tempo-distributed](katalog/tempo-distributed) | `2.3.1`                         | Distributed Tempo deployment    |
| [minio-ha](katalog/minio-ha)                   | `vRELEASE.2023-01-12T02-06-16Z` | Three nodes HA MinIO deployment |

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.29.x`           | :white_check_mark: | No known issues |
| `1.30.x`           | :white_check_mark: | No known issues |
| `1.31.x`           | :white_check_mark: | No known issues |
| `1.32.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional information about previous releases of the modules.

## Usage

### Prerequisites

| Tool                        | Version    | Description                                                                                                                                                    |
| --------------------------- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.25.0` | The recommended tool to download and manage KFD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.3`  | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |

### Deployment

Include the tracing module configuration in your `furyctl.yaml` file, specifically under the `spec.distribution.modules.tracing` section. This streamlined approach enhances the deployment process by seamlessly integrating with the Kubernetes Fury Distribution management tools.

Here is an example snippet for the `furyctl.yaml` file that demonstrates how to configure the tracing module with Tempo as the tracing system and High Availability (HA) MinIO instance for storage:

```yaml
spec:
  distribution:
    modules:
      tracing:
        type: tempo
        minio:
          storageSize: "20Gi"
```

#### Sending Traces to Tempo

To send traces form an instrumented application to Tempo, point the application to the Distributor's service:

```plaintext
tempo-distributed-distributor.tracing.svc.cluster.local:4317/

> [!NOTE]
> `4317` is the port for the OpenTelemetry Protocol (OTLP), the Distributor supports other protocols but it is recommended to use OTLP for performance reasons.

> [!WARNING]
> For production workloads, it is better to use something like the [OpenTelemetry Collector][otel-collector] instead of pushing the traces directly to Tempo, so the application can oflload the traces quickly and minimize impact on the application's performance.

### Legacy Deployment

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: tracing
    version: "v1.0.3"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl legacy vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/tracing`.

4. Define a `kustomization.yaml` that includes the `./vendor/katalog/tracing` directory as resource.

```yaml
resources:
- ./vendor/katalog/tracing/minio-ha
- ./vendor/katalog/tracing/tempo-distributed
```

5. To deploy the packages to your cluster, execute:

```bash
kustomize build . | kubectl apply -f -
```

> Note: When installing the packages, you need to ensure that the Prometheus operator is also installed.
> Otherwise, the API server will reject all ServiceMonitor resources.

<!-- Links -->

[tempo-page]: https://github.com/grafana/tempo
[kfd-repo]: https://github.com/sighupio/fury-distribution
[furyctl-repo]: https://github.com/sighupio/furyctl
[kustomize-repo]: https://github.com/kubernetes-sigs/kustomize
[kfd-docs]: https://docs.kubernetesfury.com/docs/distribution/
[compatibility-matrix]: https://github.com/sighupio/fury-kubernetes-tracing/blob/master/docs/COMPATIBILITY_MATRIX.md
[otel-collector]: https://opentelemetry.io/docs/collector/#when-to-use-a-collector

<!-- </KFD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problems with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-tracing/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
