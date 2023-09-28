# Tempo

<!-- <KFD-DOCS> -->

Grafana Tempo is an open source, easy-to-use, and high-scale distributed tracing backend. Tempo is cost-efficient, requiring only object storage to operate, and is deeply integrated with Grafana, Prometheus, and Loki. Tempo can ingest common open source tracing protocols, including Jaeger, Zipkin, and OpenTelemetry.

## Requirements

- Kubernetes >= `1.24.0`
- Kustomize >= `v3.5.3`
- [prometheus-operator from KFD monitoring module][prometheus-operator]
- [grafana from KFD monitoring module][grafana]

## Image repository

- registry.sighup.io/fury/memcached
- registry.sighup.io/fury/grafana/tempo
- registry.sighup.io/fury/nginxinc/nginx-unprivileged

## Configuration

Tempo is configured with the distributed approach. By default we configure 3 fixed ingesters and the other components in autoscaling mode.

Each component has a default limit and request:

```
requests:
    cpu: 50m
    memory: 128Mi
limits:
    cpu: 512m 
    memory: 1024Mi
```


## Deployment

You can deploy tempo by running the following command in the root of
the project:

```shell
kustomize build | kubectl apply -f -
```

<!-- Links -->

[prometheus-operator]: https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/katalog/prometheus-operator
[grafana]: https://github.com/sighup-io/fury-kubernetes-monitoring/blob/master/katalog/grafana


<!-- </KFD-DOCS> -->

## License

For license details please see [LICENSE](../../LICENSE)
