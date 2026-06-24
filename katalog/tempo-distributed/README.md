# Tempo

<!-- <SD-DOCS> -->

## Overview

Grafana Tempo is an open-source, high-scale distributed tracing backend. Tempo is cost-efficient, requiring only object storage to operate, and is deeply integrated with Grafana, Prometheus and Loki. It can ingest common open source tracing protocols, including Jaeger, Zipkin and OpenTelemetry. In the Tracing Module it is deployed in distributed mode with MinIO as its object storage backend.

## Upstream project

This package is based on the upstream [Grafana Tempo][tempo-github].

## Deployment

This package is deployed as part of **Tracing Module** when you create a cluster with `furyctl`.

You can customize it under `spec.distribution.modules.tracing.tempo` in your `furyctl.yaml`. See the [module documentation](../../README.md) and the configuration reference ([EKSCluster][schema-reference-eks], [KFDDistribution][schema-reference-kfd], [OnPremises][schema-reference-onprem]) for the available options.

<!-- Links -->

[tempo-github]: https://github.com/grafana/tempo
[schema-reference-eks]: https://docs.sighup.io/docs/reference/ekscluster#specdistributionmodulestracing
[schema-reference-kfd]: https://docs.sighup.io/docs/reference/kfddistribution#specdistributionmodulestracing
[schema-reference-onprem]: https://docs.sighup.io/docs/reference/onpremises#specdistributionmodulestracing

<!-- </SD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)
