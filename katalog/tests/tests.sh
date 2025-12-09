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
  # Wait for minio statefulset to be ready
  test_sts(){
    check_sts_ready "minio-tracing" "tracing"
  }
  loop_it test_sts 30 10
  status=${loop_it_result}
  [ "$status" -eq 0 ] || ( kubectl describe sts -n tracing minio-tracing >&2 && return 1 )

  # Wait for bucket setup job to complete successfully
  test_job(){
    check_job_ready "minio-tracing-buckets-setup" "tracing"
  }
  loop_it test_job 30 10
  status=${loop_it_result}
  [ "$status" -eq 0 ] || ( kubectl describe job -n tracing minio-tracing-buckets-setup >&2 && kubectl logs -n tracing job/minio-tracing-buckets-setup >&2 && return 1 )
}

@test "testing tempo apply" {
  info
  apply katalog/tempo-distributed
}

@test "wait for apply to settle tempo-distributed and dump state to dump.json" {
  info
  test(){
    # Check no pods are in bad states in tracing namespace
    if kubectl get pods -n tracing | grep -qie "\(Pending\|Error\|CrashLoop\|ContainerCreating\|PodInitializing\|ImagePull\)"; then
      return 1
    fi
    return 0
  }
  loop_it test 30 10
  status=${loop_it_result}
  [ "$status" -eq 0 ] || ( kubectl describe all -n tracing >&2 && return 1 )
}

@test "check minio-ha" {
  info
  test(){
    check_sts_ready "minio-tracing" "tracing"
  }
  loop_it test 60 5
  status=${loop_it_result}
  [ "$status" -eq 0 ] || ( kubectl describe sts -n tracing minio-tracing >&2 && return 1 )
}

@test "check tempo-ingester" {
  info
  test(){
    check_sts_ready "tempo-distributed-ingester" "tracing"
  }
  loop_it test 60 5
  status=${loop_it_result}
  [ "$status" -eq 0 ] || ( kubectl describe sts -n tracing tempo-distributed-ingester >&2 && return 1 )
}