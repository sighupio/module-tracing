#!/usr/bin/env bats
# Copyright (c) 2020 SIGHUP s.r.l All rights reserved.
# Use of this source code is governed by a BSD-style
# license that can be found in the LICENSE file.

# shellcheck disable=SC2154

load helper

set -o pipefail

@test "applying monitoring" {
  info
  kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.1/katalog/prometheus-operator/crds/0podmonitorCustomResourceDefinition.yaml
  kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.1/katalog/prometheus-operator/crds/0prometheusruleCustomResourceDefinition.yaml
  kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.1/katalog/prometheus-operator/crds/0servicemonitorCustomResourceDefinition.yaml
  kubectl apply -f https://raw.githubusercontent.com/sighupio/fury-kubernetes-monitoring/v2.0.1/katalog/prometheus-operator/crds/0probeCustomResourceDefinition.yaml
  kubectl create ns tracing
}

@test "testing minio-ha apply" {
  info
  apply katalog/minio-ha
}

@test "wait for apply to settle minio and dump state to dump.json" {
  info
  max_retry=0
  echo "=====" $max_retry "=====" >&2
  while kubectl get pods --all-namespaces | grep -ie "\(Pending\|Error\|CrashLoop\|ContainerCreating\|PodInitializing\)" >&2
  do
    [ $max_retry -lt 30 ] || ( kubectl describe all --all-namespaces >&2 && return 1 )
    sleep 10 && echo "# waiting..." $max_retry >&3
    max_retry=$((max_retry+1))
  done
}

@test "testing tempo apply" {
  info
  apply katalog/tempo-distributed
}

@test "wait for apply to settle tempo-distributed and dump state to dump.json" {
  info
  max_retry=0
  echo "=====" $max_retry "=====" >&2
  while kubectl get pods --all-namespaces | grep -ie "\(Pending\|Error\|CrashLoop\|ContainerCreating\|PodInitializing\)" >&2
  do
    [ $max_retry -lt 30 ] || ( kubectl describe all --all-namespaces >&2 && return 1 )
    sleep 10 && echo "# waiting..." $max_retry >&3
    max_retry=$((max_retry+1))
  done
}

@test "check minio-ha" {
  info
  test(){
    data=$(kubectl get sts -n tracing -l app=minio -o json | jq '.items[] | select(.metadata.name == "minio-tracing" and .status.replicas == .status.readyReplicas)')
    if [ "${data}" == "" ]; then return 1; fi
  }
  loop_it test 60 5
  status=${loop_it_result}
  [[ "$status" -eq 0 ]]
}

@test "check tempo-ingester" {
  info
  test(){
    data=$(kubectl get sts -n tracing -l app.kubernetes.io/component=ingester -o json | jq '.items[] | select(.metadata.name == "tempo-distributed-ingester" and .status.replicas == .status.readyReplicas)')
    if [ "${data}" == "" ]; then return 1; fi
  }
  loop_it test 120 5
  status=${loop_it_result}
  [[ "$status" -eq 0 ]]
}