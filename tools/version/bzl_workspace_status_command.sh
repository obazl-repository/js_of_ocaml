#!/bin/bash
echo "STABLE_GIT_COMMIT $(git rev-parse HEAD)"
echo "STABLE_GIT_VERSION $(git describe --always --dirty)"
