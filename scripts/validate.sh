#!/usr/bin/env bash

# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###############################################################################
#
# This file validates that all resources have been created and work as expected.
#
###############################################################################

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -euo pipefail

# Directory of this script.
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "$ROOT"/scripts/common.sh

# Ensure the bastion SSH tunnel/proxy is up/running
# shellcheck source=scripts/proxy.sh
source "$ROOT"/scripts/proxy.sh

# Set the HTTPS_PROXY env var to allow kubectl to bounce through
# the bastion host over the locally forwarded port 8888.
export HTTPS_PROXY=localhost:8888

test_des "pgAdmin is deployed on the cluster"
test_cmd "$(kubectl rollout status --timeout=10s \
  -f "${ROOT}/manifests/pgadmin-deployment.yaml" 2>&1)"

test_des "pgAdmin is able to connect to the database instance"
test_cmd "$(kubectl exec -it -n default \
  "$(kubectl get pod -l 'app=pgadmin4' \
  -ojsonpath='{.items[].metadata.name}')" -c pgadmin4 \
  -- pg_isready -h localhost -t 10 2>&1)"
