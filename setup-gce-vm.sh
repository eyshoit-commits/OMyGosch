#!/bin/bash
set -e

PROJECT_ID="bkg-ai"
ZONE="europe-west1-c"
INSTANCE_NAME="opencode-vm"
MACHINE_TYPE="e2-medium"  # Günstig: 2 vCPUs, 4GB RAM
BOOT_DISK_SIZE="30GB"
IMAGE="europe-west1-docker.pkg.dev/bkg-ai/bkg-ai/opencode-ohmygosh:latest"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}=========================================="
echo "Google Compute Engine VM Setup"
echo "Günstige Konfiguration für OpenCode"
echo -e "==========================================${NC}\n"

# .env laden
if [ ! -f ".env" ]; then
  echo -e "${RED}Error: .env file not found${NC}"
  exit 1
fi

echo -e "${BLUE}1. Lade .env Konfiguration...${NC}"
# Extrahiere kritische Variablen aus .env
AUTH_SECRET=$(grep '^AUTH_SECRET=' .env | cut -d'=' -f2-)
OPENCODE_SERVER_PORT=$(grep '^OPENCODE_SERVER_PORT=' .env | cut -d'=' -f2- || echo "5551")
PROCESS_START_WAIT_MS=$(grep '^PROCESS_START_WAIT_MS=' .env | cut -d'=' -f2- || echo "5000")
PROCESS_VERIFY_WAIT_MS=$(grep '^PROCESS_VERIFY_WAIT_MS=' .env | cut -d'=' -f2- || echo "3000")
HEALTH_CHECK_INTERVAL_MS=$(grep '^HEALTH_CHECK_INTERVAL_MS=' .env | cut -d'=' -f2- || echo "5000")
HEALTH_CHECK_TIMEOUT_MS=$(grep '^HEALTH_CHECK_TIMEOUT_MS=' .env | cut -d'=' -f2- || echo "120000")
MAX_FILE_SIZE_MB=$(grep '^MAX_FILE_SIZE_MB=' .env | cut -d'=' -f2- || echo "50")
MAX_UPLOAD_SIZE_MB=$(grep '^MAX_UPLOAD_SIZE_MB=' .env | cut -d'=' -f2- || echo "50")
DEBUG=$(grep '^DEBUG=' .env | cut -d'=' -f2- || echo "false")
ADMIN_EMAIL=$(grep '^ADMIN_EMAIL=' .env | cut -d'=' -f2- || echo "")
ADMIN_PASSWORD=$(grep '^ADMIN_PASSWORD=' .env | cut -d'=' -f2- || echo "")
ADMIN_PASSWORD_RESET=$(grep '^ADMIN_PASSWORD_RESET=' .env | cut -d'=' -f2- || echo "false")

# Container ENV File erstellen
echo -e "\n${BLUE}2. Erstelle Container Environment File...${NC}"
cat > /tmp/container-env.env <<EOF
NODE_ENV=production
HOST=0.0.0.0
PORT=5003
OPENCODE_SERVER_PORT=${OPENCODE_SERVER_PORT}
DATABASE_PATH=/opt/app/data/opencode.db
WORKSPACE_PATH=/home/bkg/workspace
AUTH_SECRET=${AUTH_SECRET}
PROCESS_START_WAIT_MS=${PROCESS_START_WAIT_MS}
PROCESS_VERIFY_WAIT_MS=${PROCESS_VERIFY_WAIT_MS}
HEALTH_CHECK_INTERVAL_MS=${HEALTH_CHECK_INTERVAL_MS}
HEALTH_CHECK_TIMEOUT_MS=${HEALTH_CHECK_TIMEOUT_MS}
MAX_FILE_SIZE_MB=${MAX_FILE_SIZE_MB}
MAX_UPLOAD_SIZE_MB=${MAX_UPLOAD_SIZE_MB}
DEBUG=${DEBUG}
ADMIN_EMAIL=${ADMIN_EMAIL}
ADMIN_PASSWORD=${ADMIN_PASSWORD}
ADMIN_PASSWORD_RESET=${ADMIN_PASSWORD_RESET}
AUTH_SECURE_COOKIES=true
EOF

echo "   ✓ Environment File erstellt"

# Firewall Regel erstellen
echo -e "\n${BLUE}3. Erstelle Firewall Regel...${NC}"
gcloud compute firewall-rules create allow-opencode \
  --project=${PROJECT_ID} \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:5003 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=opencode-server 2>/dev/null \
  && echo "   ✓ Firewall Regel erstellt" \
  || echo "   ℹ Firewall Regel existiert bereits"

# VM erstellen
echo -e "\n${BLUE}4. Erstelle Compute Engine VM...${NC}"
echo "   Instance: ${INSTANCE_NAME}"
echo "   Machine Type: ${MACHINE_TYPE}"
echo "   Zone: ${ZONE}"
echo "   Boot Disk: ${BOOT_DISK_SIZE}"

gcloud compute instances create-with-container ${INSTANCE_NAME} \
  --project=${PROJECT_ID} \
  --zone=${ZONE} \
  --machine-type=${MACHINE_TYPE} \
  --boot-disk-size=${BOOT_DISK_SIZE} \
  --boot-disk-type=pd-standard \
  --tags=opencode-server,http-server \
  --container-image=${IMAGE} \
  --container-restart-policy=always \
  --container-env-file=/tmp/container-env.env \
  --container-mount-host-path=mount-path=/opt/app/data,host-path=/mnt/disks/data,mode=rw \
  --scopes=https://www.googleapis.com/auth/cloud-platform

# Warte auf VM Start
echo -e "\n${BLUE}5. Warte auf VM Start...${NC}"
sleep 20

# Externe IP abrufen
EXTERNAL_IP=$(gcloud compute instances describe ${INSTANCE_NAME} \
  --project=${PROJECT_ID} \
  --zone=${ZONE} \
  --format="get(networkInterfaces[0].accessConfigs[0].natIP)")

echo -e "\n${GREEN}=========================================="
echo "✓ VM erfolgreich erstellt!"
echo -e "==========================================${NC}"
echo ""
echo -e "${GREEN}VM Details:${NC}"
echo "   Name: ${INSTANCE_NAME}"
echo "   Zone: ${ZONE}"
echo "   Machine Type: ${MACHINE_TYPE}"
echo "   External IP: ${EXTERNAL_IP}"
echo ""
echo -e "${GREEN}Service URLs:${NC}"
echo "   OpenCode UI: http://${EXTERNAL_IP}:5003"
echo "   Health Check: http://${EXTERNAL_IP}:5003/api/health"
echo ""
echo -e "${BLUE}Nächste Schritte:${NC}"
echo "1. SSH Connect: gcloud compute ssh ${INSTANCE_NAME} --zone=${ZONE} --project=${PROJECT_ID}"
echo "2. Logs: gcloud compute ssh ${INSTANCE_NAME} --zone=${ZONE} --project=${PROJECT_ID} --command='sudo docker logs \$(sudo docker ps -q)'"
echo "3. Container Status: gcloud compute ssh ${INSTANCE_NAME} --zone=${ZONE} --project=${PROJECT_ID} --command='sudo docker ps'"
echo ""
echo -e "${RED}⚠ Kosten:${NC}"
echo "   e2-medium (2 vCPU, 4GB): ~\$24/Monat (bei 100% Auslastung)"
echo "   Mit preemptible: ~\$7/Monat"
echo ""
echo -e "${BLUE}Zum Stoppen:${NC}"
echo "   gcloud compute instances stop ${INSTANCE_NAME} --zone=${ZONE} --project=${PROJECT_ID}"
echo ""
echo -e "${RED}Zum Löschen:${NC}"
echo "   gcloud compute instances delete ${INSTANCE_NAME} --zone=${ZONE} --project=${PROJECT_ID}"
echo ""

# .env aktualisieren mit neuer IP
echo -e "${BLUE}Möchtest du .env mit der VM IP aktualisieren? (y/n)${NC}"
read -p "> " UPDATE_ENV

if [[ "$UPDATE_ENV" == "y" ]]; then
  sed -i "s|AUTH_TRUSTED_ORIGINS=.*|AUTH_TRUSTED_ORIGINS=http://localhost:5173,http://localhost:5003,http://${EXTERNAL_IP}:5003|g" .env
  sed -i "s|PASSKEY_ORIGIN=.*|PASSKEY_ORIGIN=http://${EXTERNAL_IP}:5003|g" .env
  sed -i "s|PASSKEY_RP_ID=.*|PASSKEY_RP_ID=${EXTERNAL_IP}|g" .env
  echo -e "${GREEN}✓ .env aktualisiert${NC}"
fi

rm -f /tmp/container-env.env
