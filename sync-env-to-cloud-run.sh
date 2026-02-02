#!/bin/bash
set -e

PROJECT_ID="bkg-ai"
REGION="europe-west1"
SERVICE_NAME="bkg"

# Farben für Output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================="
echo "Cloud Run Env Sync von .env"
echo -e "==========================================${NC}\n"

# .env Datei laden
if [ ! -f ".env" ]; then
  echo -e "${RED}Error: .env file not found${NC}"
  exit 1
fi

echo -e "${BLUE}1. Lade Umgebungsvariablen aus .env...${NC}"

# Extrahiere relevante Variablen aus .env (nur die, die nicht leer sind)
source .env 2>/dev/null || true

# Cloud Run Service URL ermitteln
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} \
  --region=${REGION} \
  --project=${PROJECT_ID} \
  --format="value(status.url)" 2>/dev/null || echo "https://${SERVICE_NAME}-1039981257574.${REGION}.run.app")

echo "   Service URL: ${SERVICE_URL}"

# AUTH_SECRET generieren falls nicht gesetzt oder "changeme"
if [ -z "$AUTH_SECRET" ] || [ "$AUTH_SECRET" = "changeme-supersecret" ]; then
  echo -e "\n${BLUE}2. Generiere neues AUTH_SECRET...${NC}"
  AUTH_SECRET=$(openssl rand -base64 32)
  echo "   ✓ AUTH_SECRET generiert"
else
  echo -e "\n${BLUE}2. Verwende AUTH_SECRET aus .env${NC}"
fi

# Timeouts aus .env oder Defaults
PROCESS_START_WAIT_MS=${PROCESS_START_WAIT_MS:-5000}
PROCESS_VERIFY_WAIT_MS=${PROCESS_VERIFY_WAIT_MS:-3000}
HEALTH_CHECK_INTERVAL_MS=${HEALTH_CHECK_INTERVAL_MS:-5000}
HEALTH_CHECK_TIMEOUT_MS=${HEALTH_CHECK_TIMEOUT_MS:-120000}
MAX_FILE_SIZE_MB=${MAX_FILE_SIZE_MB:-50}
MAX_UPLOAD_SIZE_MB=${MAX_UPLOAD_SIZE_MB:-50}
DEBUG=${DEBUG:-false}

# Cloud Run spezifische Overrides
NODE_ENV="production"
HOST="0.0.0.0"
OPENCODE_SERVER_PORT=${OPENCODE_SERVER_PORT:-5551}
DATABASE_PATH="/opt/app/data/opencode.db"
WORKSPACE_PATH="/home/bkg/workspace"
AUTH_TRUSTED_ORIGINS="${SERVICE_URL}"
AUTH_SECURE_COOKIES="true"
PASSKEY_RP_ID="${SERVICE_NAME}-1039981257574.${REGION}.run.app"
PASSKEY_RP_NAME="${PASSKEY_RP_NAME:-OpenCode Manager}"
PASSKEY_ORIGIN="${SERVICE_URL}"

# OAuth Providers (optional)
GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID:-}
GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET:-}
GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID:-}
GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET:-}
DISCORD_CLIENT_ID=${DISCORD_CLIENT_ID:-}
DISCORD_CLIENT_SECRET=${DISCORD_CLIENT_SECRET:-}
ADMIN_EMAIL=${ADMIN_EMAIL:-}
ADMIN_PASSWORD=${ADMIN_PASSWORD:-}
ADMIN_PASSWORD_RESET=${ADMIN_PASSWORD_RESET:-false}

echo -e "\n${BLUE}3. Aktualisiere Cloud Run Service...${NC}"

# Baue ENV_VARS String
ENV_VARS="NODE_ENV=${NODE_ENV}"
ENV_VARS="${ENV_VARS},HOST=${HOST}"
ENV_VARS="${ENV_VARS},OPENCODE_SERVER_PORT=${OPENCODE_SERVER_PORT}"
ENV_VARS="${ENV_VARS},DATABASE_PATH=${DATABASE_PATH}"
ENV_VARS="${ENV_VARS},WORKSPACE_PATH=${WORKSPACE_PATH}"
ENV_VARS="${ENV_VARS},AUTH_SECRET=${AUTH_SECRET}"
ENV_VARS="${ENV_VARS},PROCESS_START_WAIT_MS=${PROCESS_START_WAIT_MS}"
ENV_VARS="${ENV_VARS},PROCESS_VERIFY_WAIT_MS=${PROCESS_VERIFY_WAIT_MS}"
ENV_VARS="${ENV_VARS},HEALTH_CHECK_INTERVAL_MS=${HEALTH_CHECK_INTERVAL_MS}"
ENV_VARS="${ENV_VARS},HEALTH_CHECK_TIMEOUT_MS=${HEALTH_CHECK_TIMEOUT_MS}"
ENV_VARS="${ENV_VARS},MAX_FILE_SIZE_MB=${MAX_FILE_SIZE_MB}"
ENV_VARS="${ENV_VARS},MAX_UPLOAD_SIZE_MB=${MAX_UPLOAD_SIZE_MB}"
ENV_VARS="${ENV_VARS},DEBUG=${DEBUG}"
ENV_VARS="${ENV_VARS},AUTH_TRUSTED_ORIGINS=${AUTH_TRUSTED_ORIGINS}"
ENV_VARS="${ENV_VARS},AUTH_SECURE_COOKIES=${AUTH_SECURE_COOKIES}"
ENV_VARS="${ENV_VARS},PASSKEY_RP_ID=${PASSKEY_RP_ID}"
ENV_VARS="${ENV_VARS},PASSKEY_RP_NAME=${PASSKEY_RP_NAME}"
ENV_VARS="${ENV_VARS},PASSKEY_ORIGIN=${PASSKEY_ORIGIN}"
ENV_VARS="${ENV_VARS},ADMIN_PASSWORD_RESET=${ADMIN_PASSWORD_RESET}"

# Optional OAuth Provider Env Vars (nur wenn gesetzt)
[ -n "$GITHUB_CLIENT_ID" ] && ENV_VARS="${ENV_VARS},GITHUB_CLIENT_ID=${GITHUB_CLIENT_ID}"
[ -n "$GITHUB_CLIENT_SECRET" ] && ENV_VARS="${ENV_VARS},GITHUB_CLIENT_SECRET=${GITHUB_CLIENT_SECRET}"
[ -n "$GOOGLE_CLIENT_ID" ] && ENV_VARS="${ENV_VARS},GOOGLE_CLIENT_ID=${GOOGLE_CLIENT_ID}"
[ -n "$GOOGLE_CLIENT_SECRET" ] && ENV_VARS="${ENV_VARS},GOOGLE_CLIENT_SECRET=${GOOGLE_CLIENT_SECRET}"
[ -n "$DISCORD_CLIENT_ID" ] && ENV_VARS="${ENV_VARS},DISCORD_CLIENT_ID=${DISCORD_CLIENT_ID}"
[ -n "$DISCORD_CLIENT_SECRET" ] && ENV_VARS="${ENV_VARS},DISCORD_CLIENT_SECRET=${DISCORD_CLIENT_SECRET}"
[ -n "$ADMIN_EMAIL" ] && ENV_VARS="${ENV_VARS},ADMIN_EMAIL=${ADMIN_EMAIL}"
[ -n "$ADMIN_PASSWORD" ] && ENV_VARS="${ENV_VARS},ADMIN_PASSWORD=${ADMIN_PASSWORD}"

gcloud run services update ${SERVICE_NAME} \
  --region=${REGION} \
  --project=${PROJECT_ID} \
  --update-env-vars="${ENV_VARS}"

echo -e "\n${GREEN}=========================================="
echo "✓ Environment Variables synchronisiert!"
echo -e "==========================================${NC}"
echo ""
echo -e "${GREEN}Service URL:${NC} ${SERVICE_URL}"
echo -e "${GREEN}Health Check:${NC} ${SERVICE_URL}/api/health"
echo ""
echo -e "${RED}⚠ WICHTIG: Speichere dein AUTH_SECRET!${NC}"
echo "   AUTH_SECRET=${AUTH_SECRET}"
echo ""
