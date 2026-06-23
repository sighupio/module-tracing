# MinIO HA

<!-- <SD-DOCS> -->

## Overview

MinIO is a distributed object storage system that allows deploying highly available and scalable storage infrastructure. In the Tracing Module it provides the highly available (HA) object storage backend used by Tempo, deployed as a cluster of multiple MinIO nodes each backed by its own set of PVCs.

## Upstream project

This package is based on the upstream [MinIO][minio-github].

## Deployment

This package is deployed as part of **Tracing Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.tracing.minio` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[minio-github]: https://github.com/minio/minio
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulestracing
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulestracing
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulestracing

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)
