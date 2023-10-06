<h1>
    <img src="https://github.com/sighupio/fury-distribution/blob/main/docs/assets/fury-epta-white.png?raw=true" align="left" width="90" style="margin-right: 15px"/>
    Kubernetes Fury Observability
</h1>

![Release](https://img.shields.io/badge/Latest%20Release-v1.0.0-blue)
![License](https://img.shields.io/github/license/sighupio/fury-kubernetes-tracing?label=License)
![Slack](https://img.shields.io/badge/slack-@kubernetes/fury-yellow.svg?logo=slack&label=Slack)

<!-- <KFD-DOCS> -->

**Kubernetes Fury Tracing** provides a tracing stack for the [Kubernetes Fury Distribution (KFD)][kfd-repo].

If you are new to KFD please refer to the [official documentation][kfd-docs] on how to get started with KFD.

## Overview

**Kubernetes Fury Tracing** uses a collection of open source tools to provide the most resilient and robust tracing stack for the cluster.

The module right now contains only the [tempo][tempo-page] tool from grafana.

All the components are deployed in the `tracing` namespace in the cluster.

| Package                                        | Version                         | Description                     |
| ---------------------------------------------- | ------------------------------- | ------------------------------- |
| [tempo-distributed](katalog/tempo-distributed) | `2.2.2`                         | Distributed Tempo deployment    |
| [minio-ha](katalog/minio-ha)                   | `vRELEASE.2023-01-12T02-06-16Z` | Three nodes HA MinIO deployment |

Click on each package to see its full documentation.

## Compatibility

| Kubernetes Version |   Compatibility    | Notes           |
| ------------------ | :----------------: | --------------- |
| `1.24.x`           | :white_check_mark: | No known issues |
| `1.25.x`           | :white_check_mark: | No known issues |
| `1.26.x`           | :white_check_mark: | No known issues |

Check the [compatibility matrix][compatibility-matrix] for additional informations about previous releases of the modules.

## Usage

### Prerequisites

| Tool                        | Version   | Description                                                                                                                                                    |
| --------------------------- | --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [furyctl][furyctl-repo]     | `>=0.25.0` | The recommended tool to download and manage KFD modules and their packages. To learn more about `furyctl` read the [official documentation][furyctl-repo].     |
| [kustomize][kustomize-repo] | `>=3.5.3` | Packages are customized using `kustomize`. To learn how to create your customization layer with `kustomize`, please refer to the [repository][kustomize-repo]. |

### Deployment

1. List the packages you want to deploy and their version in a `Furyfile.yml`

```yaml
bases:
  - name: tracing
    version: "v1.0.0"
```

> See `furyctl` [documentation][furyctl-repo] for additional details about `Furyfile.yml` format.

2. Execute `furyctl legacy vendor -H` to download the packages

3. Inspect the download packages under `./vendor/katalog/tracing`.

4. Define a `kustomization.yaml` that includes the `./vendor/katalog/logging` directory as resource.

```yaml
resources:
- ./vendor/katalog/logging/minio-ha
- ./vendor/katalog/logging/tempo-distributed
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

<!-- </KFD-DOCS> -->

<!-- <FOOTER> -->

## Contributing

Before contributing, please read first the [Contributing Guidelines](docs/CONTRIBUTING.md).

### Reporting Issues

In case you experience any problems with the module, please [open a new issue](https://github.com/sighupio/fury-kubernetes-tracing/issues/new/choose).

## License

This module is open-source and it's released under the following [LICENSE](LICENSE)

<!-- </FOOTER> -->
