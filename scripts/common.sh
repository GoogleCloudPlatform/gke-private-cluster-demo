#!/bin/bash -e

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

# "---------------------------------------------------------"
# "-                                                       -"
# "-  Common commands for all scripts                      -"
# "-                                                       -"
# "---------------------------------------------------------"

# Locate the root directory. Used by scripts that source this one.
# shellcheck disable=SC2034
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# git is required for this tutorial
# https://git-scm.com/book/en/v2/Getting-Started-Installing-Git
command -v git >/dev/null 2>&1 || { \
 echo >&2 "I require git but it's not installed.  Aborting."
 echo >&2 "Refer to: https://git-scm.com/book/en/v2/Getting-Started-Installing-Git"
 exit 1
}

# glcoud is required for this tutorial
# https://cloud.google.com/sdk/install
command -v gcloud >/dev/null 2>&1 || { \
 echo >&2 "I require gcloud but it's not installed.  Aborting."
 echo >&2 "Refer to: https://cloud.google.com/sdk/install"
 exit 1
}

# Make sure kubectl is installed.  If not, refer to:
# https://kubernetes.io/docs/tasks/tools/install-kubectl/
command -v kubectl >/dev/null 2>&1 || { \
 echo >&2 "I require kubectl but it's not installed.  Aborting."
 echo >&2 "Refer to: https://kubernetes.io/docs/tasks/tools/install-kubectl/"
 exit 1
}

# Simple test helpers that avoids eval and complex quoting. Note that stderr is
# redirected to stdout so we can properly handle output.
# Usage: test_des "description"
test_des() {
  echo -n "Checking that $1... "
}

# Usage: test_cmd "$(command string 2>&1)"
test_cmd() {
  local result=$?
  local output="$1"

  # If command completes successfully, output "pass" and continue.
  if [[ $result == 0 ]]; then
    echo "pass"

  # If ccommand fails, output the error code, command output and exit.
  else
    echo -e "fail ($result)\\n"
    cat <<<"$output"
    exit $result
  fi
}
