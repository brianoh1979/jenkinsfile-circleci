#! /bin/bash

set -eu

parent_path=$( cd "$(dirname "${BASH_SOURCE[0]}")" ; pwd -P )

validate_configs() {
  configs=($(find ${parent_path}/../artifacts -name "*.yml"))
  failed=0
  passed=0
  if [[ $configs ]]; then
    for i in "${!configs[@]}"; do
      if ! circleci config validate "${configs[i]}"
      then
        continue
        ((failed++)) 
        echo "Failed to validate ${configs[i]}"
      else
        continue
        ((passed++))
      fi
    done
  else
    echo "No configs!"
    exit 1
  fi
  
  echo "$passed tests passed out of $(( failed+passed ))"
  
  if [ "$failed" > 0 ]
  then
    exit 1
  fi
}

validate_configs