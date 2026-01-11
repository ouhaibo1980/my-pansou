#!/bin/bash
set -Eeuo pipefail

cd "${COZE_WORKSPACE_PATH}"

echo "Installing frontend dependencies..."
cd frontend && pnpm install && cd ..

echo "Build completed successfully!"
