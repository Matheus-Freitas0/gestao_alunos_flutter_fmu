#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
API_URL=${API_BASE_URL:-http://localhost:3000/api}

cleanup() {
  if [[ -n "${BACKEND_PID:-}" ]]; then
    kill "${BACKEND_PID}" >/dev/null 2>&1 || true
  fi
}

trap cleanup EXIT

echo "==> Iniciando backend (JavaScript)..."
pushd "${ROOT_DIR}/backend" >/dev/null
npm install
npm run dev &
BACKEND_PID=$!
popd >/dev/null

echo "==> Iniciando app Flutter..."
pushd "${ROOT_DIR}" >/dev/null
flutter pub get
flutter run --dart-define=API_BASE_URL="${API_URL}"
popd >/dev/null

