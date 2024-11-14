# Tempo - maintenance

To maintain the Tempo package, you should follow these steps.

```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm search repo grafana/tempo-distributed # get the latest chart version
helm pull grafana/tempo-distributed --version 1.19.0 --untar --untardir /tmp # this command will download the chart in /tmp/tempo-distributed
```

Run the following command:

```bash
helm template tempo-distributed /tmp/tempo-distributed -n tracing --values MAINTENANCE.values.yaml > tempo-distributed-built.yaml
```

With the `tempo-distributed-built.yaml` file, check differences with the current `deploy.yml` file and change accordingly.

What was customized:

- nginx-unprivileged image was bumped to the latest available version
- PodDisruptionBudget apiVersion bumped to policy/v1


## Testing the tracing stack

You can use the manifest in `katalog/tests/sample-traces-cronjob.yaml` to create a cronjob that generates traces and sends them to Tempo.

Once the crojob has run for some time, you can go to Grafana's Explore view, swith the datasource to Tempo, then select the "Search" query type.

In the "Service Name" drop down you should be able to chose the value "telemetrygen", chose that and search for traces.

The cronjob definition has been taken and adapted from: <https://grafana.com/docs/tempo/latest/setup/set-up-test-app/>
