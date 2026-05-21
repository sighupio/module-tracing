#!/bin/bash
# Copyright (c) 2017-present SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

set -e

helm repo add grafana-community https://grafana-community.github.io/helm-charts
helm repo update

CHART_VERSION=$(helm search repo grafana-community/tempo-distributed -o json | yq '.[0].version')
echo "Found chart version $CHART_VERSION"

rm -r /tmp/tempo-distributed
helm pull grafana-community/tempo-distributed --version "$CHART_VERSION" --untar --untardir /tmp
echo "Downloaded chart with version $CHART_VERSION in /tmp/tempo-distributed"

TEMPO_TAG=$(yq '.appVersion' /tmp/tempo-distributed/Chart.yaml)
MEMCACHED_TAG=$(yq '.memcached.image.tag' /tmp/tempo-distributed/values.yaml)
NGINX_TAG=$(yq '.gateway.image.tag' /tmp/tempo-distributed/values.yaml)
echo "Found latest image tags: tempo=$TEMPO_TAG memcached=$MEMCACHED_TAG nginx=$NGINX_TAG"

yq -i ".tempo.image.tag = \"$TEMPO_TAG\"" MAINTENANCE.values.yaml
yq -i ".memcached.image.tag = \"$MEMCACHED_TAG\"" MAINTENANCE.values.yaml
yq -i ".gateway.image.tag = \"$NGINX_TAG\"" MAINTENANCE.values.yaml
echo "Updated image tags in MAINTENANCE.values.yaml"

yq -i "(.images[] | select(.name == \"docker.io/grafana/tempo\")).newTag = \"$TEMPO_TAG\"" kustomization.yaml
yq -i "(.images[] | select(.name == \"docker.io/memcached\")).newTag = \"$MEMCACHED_TAG\"" kustomization.yaml
yq -i "(.images[] | select(.name == \"docker.io/nginxinc/nginx-unprivileged\")).newTag = \"$NGINX_TAG\"" kustomization.yaml
echo "Updated image tags in kustomization.yaml"

helm template tempo-distributed /tmp/tempo-distributed -n tracing --values MAINTENANCE.values.yaml > deploy.yaml
echo "Built chart template in deploy.yaml file"

mise run add-license