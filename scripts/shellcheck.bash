#!/usr/bin/env bash

exec shellcheck -s bash -x \
  setup.bash \
  bin/* -P lib/
