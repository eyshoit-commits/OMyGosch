#!/bin/bash
# Deploy OpenCode container to GCE VM

IMAGE="europe-west1-docker.pkg.dev/bkg-ai/cloud-run-source-deploy/omygosch/bkg@sha256:b65f3cd84ecb4de5b53fab9d0831a638c106a6880765d2ef393238ea7885048a"

# Stop and remove existing container
docker stop opencode 2>/dev/null || true
docker rm opencode 2>/dev/null || true

# Create persistent directories
sudo mkdir -p /opt/opencode-data /opt/opencode-workspace

# Run container with all environment variables
docker run -d \
  --name opencode \
  --restart=always \
  -p 5003:5003 \
  -p 5551:5551 \
  -v /opt/opencode-data:/opt/app/data \
  -v /opt/opencode-workspace:/home/bkg/workspace \
  -e NODE_ENV=production \
  -e HOST=0.0.0.0 \
  -e PORT=5003 \
  -e OPENCODE_SERVER_PORT=5551 \
  -e DATABASE_PATH=/opt/app/data/opencode.db \
  -e WORKSPACE_PATH=/home/bkg/workspace \
  -e AUTH_SECRET=QAcdU53JFw2pkToYdaQ6OFvnmUypC3cR5lWihLWooRE= \
  -e PROCESS_START_WAIT_MS=5000 \
  -e PROCESS_VERIFY_WAIT_MS=3000 \
  -e HEALTH_CHECK_INTERVAL_MS=5000 \
  -e HEALTH_CHECK_TIMEOUT_MS=120000 \
  -e MAX_FILE_SIZE_MB=50 \
  -e MAX_UPLOAD_SIZE_MB=50 \
  -e DEBUG=false \
  -e AUTH_TRUSTED_ORIGINS=http://34.140.172.83.nip.io:5003 \
  -e AUTH_SECURE_COOKIES=false \
  -e ADMIN_EMAIL=admin@bkg-ai.local \
  -e ADMIN_PASSWORD=ChangeMe123! \
  -e ADMIN_PASSWORD_RESET=false \
  -e PASSKEY_RP_ID=34.140.172.83.nip.io \
  -e PASSKEY_RP_NAME="OpenCode Manager - BKG AI" \
  -e PASSKEY_ORIGIN=http://34.140.172.83.nip.io:5003 \
  -e GOOGLE_CLIENT_ID=1039981257574-o779h1p40rkcfn02kqjkkd7hod8hdo9e.apps.googleusercontent.com \
  -e GOOGLE_CLIENT_SECRET=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 \
  "$IMAGE"

echo "Waiting for container to start..."
sleep 10

echo "Container status:"
docker ps -a | grep opencode

echo ""
echo "Container logs:"
docker logs opencode | tail -n 30
