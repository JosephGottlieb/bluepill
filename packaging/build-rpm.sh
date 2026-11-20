#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT_DIR="${1:-${ROOT_DIR}/dist}"

VER="$(grep -m1 'project(bluepill VERSION' "${ROOT_DIR}/CMakeLists.txt" | sed -E 's/.*VERSION ([0-9.]+).*/\1/')"
RPM_TOP="$(mktemp -d)"
trap 'rm -rf "${RPM_TOP}"' EXIT

mkdir -p "${RPM_TOP}"/{BUILD,BUILDROOT,RPMS,SOURCES,SPECS,SRPMS} "${OUT_DIR}"

tar --exclude='.git' --exclude='build*' --exclude='dist' \
    --transform="s,^\.,bluepill-${VER}," \
    -czf "${RPM_TOP}/SOURCES/bluepill-${VER}.tar.gz" -C "${ROOT_DIR}" .

cp "${ROOT_DIR}/packaging/bluepill.spec" "${RPM_TOP}/SPECS/bluepill.spec"

rpmbuild --define "_topdir ${RPM_TOP}" --define "_version ${VER}" -bb "${RPM_TOP}/SPECS/bluepill.spec"

find "${RPM_TOP}/RPMS" -name '*.rpm' ! -name '*-debug*' -exec cp -v {} "${OUT_DIR}/" \;
echo "Built RPM package(s) in ${OUT_DIR}:"
ls -lh "${OUT_DIR}"/*.rpm
