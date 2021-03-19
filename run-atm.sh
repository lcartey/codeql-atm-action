#!/bin/bash
set -exu

db="${RUNNER_TEMP}/codeql_databases/javascript"
ml_models_dir="$(dirname ${CODEQL_PATH})/ml-models"
model_dir="${ml_models_dir}/$(ls -1 ${ml_models_dir})"
offline_embeddings_prefix="${model_dir}/model_data/offline-embeddings/offline_embeddings_"
${CODEQL_PATH} database analyze ${db} \
  codeql-javascript-atm/UntrustedDataToExternalAPIATM.ql \
  --threads 2 --ram 6144 --keep-full-cache --min-disk-free 1024 \
  --format sarif-latest \
  --output external-api-atm.sarif \
  --external offlineSinkEmbeddingsNosqlInjection=${offline_embeddings_prefix}NosqlInjectionRelease.csv \
  --external offlineSinkEmbeddingsSqlInjection=${offline_embeddings_prefix}SqlInjectionRelease.csv \
  --external offlineSinkEmbeddingsTaintedPath=${offline_embeddings_prefix}TaintedPathRelease.csv \
  --external offlineSinkEmbeddingsXss=${offline_embeddings_prefix}XssRelease.csv