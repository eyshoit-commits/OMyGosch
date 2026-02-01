#!/bin/bash
set -e

PROJECT_ID="bkg-ai"
REGION="europe-west1"
SERVICE_NAME="bkg"
IMAGE_REPO="bkg-ai"
IMAGE_NAME="opencode-ohmygosh"

# Farben für Output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}=========================================="
echo "Cloud Run Deployment für ${SERVICE_NAME}"
echo -e "==========================================${NC}\n"

# 1. Neuestes Image finden
echo -e "${BLUE}1. Suche neuestes Image...${NC}"
LATEST_IMAGE="${REGION}-docker.pkg.dev/${PROJECT_ID}/${IMAGE_REPO}/${IMAGE_NAME}:latest"
echo "   Image: ${LATEST_IMAGE}"

# 2. AUTH_SECRET generieren (falls nicht gesetzt)
if [ -z "$AUTH_SECRET" ]; then
  echo -e "\n${BLUE}2. Generiere AUTH_SECRET...${NC}"
  export AUTH_SECRET=$(openssl rand -base64 32)
  echo "   ✓ AUTH_SECRET generiert"
else
  echo -e "\n${BLUE}2. Verwende existierendes AUTH_SECRET${NC}"
fi

# 3. Service URL bestimmen (für CORS/Auth)
echo -e "\n${BLUE}3. Prüfe Service URL...${NC}"
SERVICE_URL=$(gcloud run services describe ${SERVICE_NAME} \
  --region=${REGION} \
  --project=${PROJECT_ID} \
  --format="value(status.url)" 2>/dev/null || echo "")

if [ -z "$SERVICE_URL" ]; then
  echo "   Service existiert noch nicht, wird erstellt..."
  SERVICE_URL="https://${SERVICE_NAME}-${PROJECT_ID}.${REGION}.run.app"
else
  echo "   Service URL: ${SERVICE_URL}"
fi

# 4. Deploy zu Cloud Run
echo -e "\n${BLUE}4. Deploying to Cloud Run...${NC}"
gcloud run deploy ${SERVICE_NAME} \
  --image=${LATEST_IMAGE} \
  --region=${REGION} \
  --project=${PROJECT_ID} \
  --platform=managed \
  --port=5003 \
  --timeout=300 \
  --memory=4Gi \
  --cpu=2 \
  --cpu-boost \
  --no-cpu-throttling \
  --max-instances=3 \
  --min-instances=0 \
  --concurrency=80 \
  --allow-unauthenticated \
  --set-env-vars="NODE_ENV=production,HOST=0.0.0.0,OPENCODE_SERVER_PORT=5551,DATABASE_PATH=/opt/app/data/opencode.db,WORKSPACE_PATH=/home/bkg/workspace,AUTH_SECRET=${AUTH_SECRET},PROCESS_START_WAIT_MS=2000,PROCESS_VERIFY_WAIT_MS=1000,HEALTH_CHECK_INTERVAL_MS=5000,HEALTH_CHECK_TIMEOUT_MS=30000,MAX_FILE_SIZE_MB=50,MAX_UPLOAD_SIZE_MB=50,DEBUG=false,AUTH_TRUSTED_ORIGINS=${SERVICE_URL},AUTH_SECURE_COOKIES=true,PASSKEY_RP_ID=${SERVICE_NAME}-${PROJECT_ID}.${REGION}.run.app,PASSKEY_RP_NAME=OpenCode Manager,PASSKEY_ORIGIN=${SERVICE_URL}"

# 5. Deployment verifizieren
echo -e "\n${BLUE}5. Verifiziere Deployment...${NC}"
DEPLOYED_URL=$(gcloud run services describe ${SERVICE_NAME} \
  --region=${REGION} \
  --project=${PROJECT_ID} \
  --format="value(status.url)")

echo -e "\n${GREEN}=========================================="
echo "✓ Deployment erfolgreich!"
echo -e "==========================================${NC}"
echo ""
echo -e "${GREEN}Service URL:${NC} ${DEPLOYED_URL}"
echo -e "${GREEN}Health Check:${NC} ${DEPLOYED_URL}/api/health"
echo ""
echo -e "${BLUE}Nächste Schritte:${NC}"
echo "1. Teste: curl ${DEPLOYED_URL}/api/health"
echo "2. Öffne: ${DEPLOYED_URL}"
echo "3. Logs: gcloud run services logs read ${SERVICE_NAME} --region=${REGION} --project=${PROJECT_ID}"
echo ""
echo -e "${RED}⚠ WICHTIG:${NC} Speichere dein AUTH_SECRET sicher!"
echo "   AUTH_SECRET=${AUTH_SECRET}"
echo ""
