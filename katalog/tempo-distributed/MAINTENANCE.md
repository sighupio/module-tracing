# Tempo - maintenance

> [!WARNING]
> Ensure that changes made in this package are also aligned with the corresponding patches in the
> [distribution](https://github.com/sighupio/distribution/tree/main/templates/distribution/manifests/tracing/patches) if needed.

To update the Tempo package to the latest chart version, run:

```bash
bash upgrade.sh
```

The script will:

1. Pull the latest `grafana-community/tempo-distributed` Helm chart
2. Update image tags in `MAINTENANCE.values.yaml` and `kustomization.yaml`
3. Re-render `deploy.yaml` from the chart using `MAINTENANCE.values.yaml`

After running the script, review the changes in `deploy.yaml` and adjust if needed. The script updates chart resources and image tags, but does not update or validate `configs/`.

What was customized:

- `useExternalConfig: true` — ConfigMaps are managed via Kustomize (`configMapGenerator` in `kustomization.yaml` using `configs/tempo.yaml` and `configs/overrides.yaml`)
- `metricsGenerator.enabled: false`
- `memcachedExporter.enabled: false`
- `queryFrontend.query.enabled: false`
- Storage backend set to S3 (MinIO)

## Monitoring deprecations and breaking changes

`configs/` is managed externally by Kustomize and is not validated by `upgrade.sh`. Before every upgrade, review the [Tempo release notes](https://github.com/grafana/tempo/releases) and [changelog](https://github.com/grafana/tempo/blob/main/CHANGELOG.md), then check `configs/tempo.yaml` and `configs/overrides.yaml` for deprecated or removed options.

## Testing the tracing stack

You can use the manifest in `katalog/tests/sample-traces-cronjob.yaml` to create a cronjob that generates traces and sends them to Tempo.

Once the crojob has run for some time, you can go to Grafana's Explore view, swith the datasource to Tempo, then select the "Search" query type.

In the "Service Name" drop down you should be able to chose the value "telemetrygen", chose that and search for traces.

The cronjob definition has been taken and adapted from: <https://grafana.com/docs/tempo/latest/setup/set-up-test-app/>
