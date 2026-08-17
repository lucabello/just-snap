set allow-duplicate-recipes
set allow-duplicate-variables
import? 'snaps.just'

[private]
@default:
  just --list
  echo ""
  echo "For help with a specific recipe, run: just --usage <recipe>"

# Test a snap with `snapcraft test`
#
# Overrides the centralized recipe from snaps.just: spread's craft backend
# only runs on the host's own architecture, so cross-built arm64/riscv64
# platforms can't be executed here and are restricted to amd64.
[group("dev")]
test version="latest":
  #!/usr/bin/env bash
  set -e
  cp spread.yaml "{{version}}/spread.yaml"
  test_exit=0; (cd "{{version}}" && snapcraft test --platform amd64) || test_exit=$?
  rm -f "{{version}}/spread.yaml"
  if [ "$test_exit" -ne 0 ]; then echo "× snapcraft test failed"; exit "$test_exit"; fi
  echo "✓ 'snapcraft test' passed."
