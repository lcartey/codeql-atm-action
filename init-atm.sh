#!/bin/bash

container_url="https://atmcodeqlpublicdata.blob.core.windows.net/atmpublic"
base_url="${container_url}/external-api-ship/v1.3.0+9d427b0"
cli_additions_checksum="c95225c5676af0c3252f849815203f44d88d1d4d6cd45f6832a0a544bd79b77d7b0851c325ce65fecb5a54683b9be169ca67f820f8b81a80ed7e8edfcdce5edb"
qlpack_checksum="79b918a6342adc4ec7ccc9c010a8ef185aeed52d80cee17d5fe54ab7a884aa2f4011edac08d831b1a71f860ae068ae0730b1fb3284590998e6ea3e959bab7fd5"
cli_root="$(dirname ${CODEQL_PATH})"
echo "Using CodeQL CLI root at ${cli_root}"
echo "::group::Initialize ATM additions to the CodeQL CLI"
cli_additions_url="${base_url}/codeql-external-api-cli-additions.tar.gz"
echo "Attempting to download ATM CLI additions from ${cli_additions_url}"
azcopy10 cp "${cli_additions_url}" cli-additions.tar.gz
if ! echo "${cli_additions_checksum} *cli-additions.tar.gz" | sha512sum -c; then
  echo "::error::Failed to validate ATM CLI additions checksum. Expected ${cli_additions_checksum}, was " \
    "$(sha512sum -b cli-additions.tar.gz | awk '{ print $1 }')"
  exit 1
fi
tar -xvzf cli-additions.tar.gz -C ${cli_root}
rm cli-additions.tar.gz
ls -lR ${cli_root}/lib-extra
ls -lR ${cli_root}/ml-models
echo "::endgroup::"
echo "::group::Initialize ATM query pack"
qlpack_url="${base_url}/codeql-external-api-qlpack.tar.gz"
echo "Attempting to download ATM query pack from ${qlpack_url}"
azcopy10 cp "${qlpack_url}" qlpack.tar.gz
if ! echo "${qlpack_checksum} *qlpack.tar.gz" | shasum -c; then
  echo "::error::Failed to validate ATM query pack checksum. Expected ${qlpack_checksum}, was " \
    "$(sha512sum -b qlpack.tar.gz | awk '{ print $1 }')"
  exit 1
fi
atm_qlpack_path="$(pwd)/codeql-javascript-atm"
mkdir ${atm_qlpack_path}
tar -xvzf qlpack.tar.gz -C ${atm_qlpack_path}
rm qlpack.tar.gz
ls -lR ${atm_qlpack_path}
echo "::endgroup::"