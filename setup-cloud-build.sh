#!/bin/bash
set -e

PROJECT_ID="bkg-ai"
REGION="europe-west1"
TRIGGER_NAME="ohmygosch-main-trigger"
REPO_NAME="OMyGosch"
REPO_OWNER="eyshoit-commits"

echo "=========================================="
echo "Google Cloud Build Setup für ${PROJECT_ID}"
echo "=========================================="

# 1. Artifact Registry Repository erstellen (falls nicht vorhanden)
echo ""
echo "1. Erstelle Artifact Registry Repository..."
gcloud artifacts repositories create bkg-ai \
  --repository-format=docker \
  --location=${REGION} \
  --project=${PROJECT_ID} \
  --description="Docker images for OpenCode OhMyGosch" 2>/dev/null \
  && echo "✓ Repository erstellt" \
  || echo "ℹ Repository existiert bereits"

# 2. Cloud Build Service Account Permissions
echo ""
echo "2. Konfiguriere Service Account Berechtigungen..."
PROJECT_NUMBER=$(gcloud projects describe ${PROJECT_ID} --format="value(projectNumber)")
SERVICE_ACCOUNT="${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com"

gcloud projects add-iam-policy-binding ${PROJECT_ID} \
  --member="serviceAccount:${SERVICE_ACCOUNT}" \
  --role="roles/artifactregistry.writer" \
  --condition=None 2>/dev/null \
  && echo "✓ Artifact Registry Writer Berechtigung gesetzt" \
  || echo "ℹ Berechtigung bereits vorhanden"

# 3. GitHub App Connection (manuell erforderlich)
echo ""
echo "3. GitHub Connection einrichten..."
echo "   Bitte besuche: https://console.cloud.google.com/cloud-build/triggers/connect?project=${PROJECT_ID}"
echo "   - Wähle 'GitHub (Cloud Build GitHub App)'"
echo "   - Authentifiziere dich mit GitHub"
echo "   - Wähle Repository: ${REPO_OWNER}/${REPO_NAME}"
echo ""
read -p "Drücke Enter wenn GitHub verbunden ist..."

# 4. Build Trigger erstellen
echo ""
echo "4. Erstelle Build Trigger..."
gcloud builds triggers create github \
  --project=${PROJECT_ID} \
  --name="${TRIGGER_NAME}" \
  --repo-name="${REPO_NAME}" \
  --repo-owner="${REPO_OWNER}" \
  --branch-pattern="^main$" \
  --build-config="cloudbuild.yaml" \
  --region=${REGION} \
  && echo "✓ Build Trigger erstellt" \
  || echo "⚠ Trigger konnte nicht erstellt werden (möglicherweise existiert er bereits)"

# 5. Test Build starten
echo ""
echo "5. Möchtest du einen Test-Build starten? (y/n)"
read -p "> " START_BUILD

if [[ "$START_BUILD" == "y" ]]; then
  echo "Starte Build..."
  gcloud builds submit \
    --config cloudbuild.yaml \
    --project=${PROJECT_ID} \
    --region=${REGION}
fi

echo ""
echo "=========================================="
echo "✓ Setup abgeschlossen!"
echo "=========================================="
echo ""
echo "Nächste Schritte:"
echo "1. 'git push' führt jetzt automatisch einen Build aus"
echo "2. Builds überwachen: https://console.cloud.google.com/cloud-build/builds?project=${PROJECT_ID}"
echo "3. Images anzeigen: https://console.cloud.google.com/artifacts/docker/${PROJECT_ID}/${REGION}/bkg-ai?project=${PROJECT_ID}"
echo ""
