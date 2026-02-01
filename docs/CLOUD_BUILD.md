# Google Cloud Build Setup

Automatisierte Docker Image Builds für OpenCode OhMyGosch auf Google Cloud Platform.

## 📋 Voraussetzungen

- Google Cloud Projekt: `bkg-ai`
- `gcloud` CLI installiert und konfiguriert
- GitHub Repository: `eyshoit-commits/OMyGosch`
- Berechtigungen auf dem GCP-Projekt

## 🚀 Schnellstart

### 1. Automatisches Setup

```bash
./setup-cloud-build.sh
```

Das Script führt automatisch aus:

- ✓ Artifact Registry Repository erstellen
- ✓ Service Account Berechtigungen konfigurieren
- ✓ GitHub Connection einrichten (Anleitung)
- ✓ Build Trigger erstellen
- ✓ Optional: Test-Build starten

### 2. Manuelles Setup

#### A. Artifact Registry erstellen

```bash
gcloud artifacts repositories create bkg-ai \
  --repository-format=docker \
  --location=europe-west1 \
  --project=bkg-ai \
  --description="Docker images for OpenCode OhMyGosch"
```

#### B. Service Account Berechtigungen

```bash
PROJECT_NUMBER=$(gcloud projects describe bkg-ai --format="value(projectNumber)")
gcloud projects add-iam-policy-binding bkg-ai \
  --member="serviceAccount:${PROJECT_NUMBER}@cloudbuild.gserviceaccount.com" \
  --role="roles/artifactregistry.writer"
```

#### C. GitHub Connection

1. Öffne: <https://console.cloud.google.com/cloud-build/triggers/connect?project=bkg-ai>
2. Wähle "GitHub (Cloud Build GitHub App)"
3. Authentifiziere mit GitHub
4. Wähle Repository: `eyshoit-commits/OMyGosch`

#### D. Build Trigger erstellen

```bash
gcloud builds triggers create github \
  --project=bkg-ai \
  --name="ohmygosch-main-trigger" \
  --repo-name="OMyGosch" \
  --repo-owner="eyshoit-commits" \
  --branch-pattern="^main$" \
  --build-config="cloudbuild.yaml" \
  --region=europe-west1
```

## 🔨 Build manuell starten

### Nur Image bauen (ohne Deployment)

```bash
gcloud builds submit \
  --config cloudbuild.yaml \
  --project=bkg-ai \
  --region=europe-west1
```

### Mit automatischem Cloud Run Deployment

```bash
gcloud builds submit \
  --config cloudbuild-with-deploy.yaml \
  --project=bkg-ai \
  --region=europe-west1
```

## 🚢 Cloud Run Deployment

### Schnelles Deployment

```bash
./deploy-cloud-run.sh
```

Das Script führt automatisch aus:

- ✓ Neuestes Image aus Artifact Registry verwenden
- ✓ AUTH_SECRET generieren (falls nicht gesetzt)
- ✓ Service mit korrekten Environment Variables deployen
- ✓ Port, Memory, CPU und Timeouts konfigurieren

### Manuelles Deployment

```bash
# AUTH_SECRET generieren
export AUTH_SECRET=$(openssl rand -base64 32)

# Zu Cloud Run deployen
gcloud run deploy bkg \
  --image=europe-west1-docker.pkg.dev/bkg-ai/bkg-ai/opencode-ohmygosh:latest \
  --region=europe-west1 \
  --project=bkg-ai \
  --platform=managed \
  --port=5003 \
  --timeout=300 \
  --memory=4Gi \
  --cpu=2 \
  --cpu-boost \
  --no-cpu-throttling \
  --max-instances=3 \
  --allow-unauthenticated \
  --update-env-vars="NODE_ENV=production,HOST=0.0.0.0,AUTH_SECRET=${AUTH_SECRET}"
```

### Cloud Run Service URL

Nach dem Deployment ist der Service erreichbar unter:

- **Prod**: <https://bkg-1039981257574.europe-west1.run.app>
- **Health Check**: <https://bkg-1039981257574.europe-west1.run.app/api/health>

## 📊 Monitoring

### Build Status anzeigen

```bash
# Alle Builds
gcloud builds list --project=bkg-ai --limit=10

# Spezifischer Build
gcloud builds describe BUILD_ID --project=bkg-ai

# Logs streamen
gcloud builds log BUILD_ID --project=bkg-ai --stream
```

### Web Console

- **Builds**: <https://console.cloud.google.com/cloud-build/builds?project=bkg-ai>
- **Triggers**: <https://console.cloud.google.com/cloud-build/triggers?project=bkg-ai>
- **Images**: <https://console.cloud.google.com/artifacts/docker/bkg-ai/europe-west1/bkg-ai?project=bkg-ai>

## ⚙️ Konfiguration

### cloudbuild.yaml

Die Build-Konfiguration beinhaltet:

1. **Docker Build** mit Layer Caching
2. **Image Push** zu Artifact Registry
3. **Optional**: Cloud Run Deployment

### Substitutions

```yaml
_REGION: europe-west1           # Artifact Registry Region
_AR_REPO: bkg-ai                # Repository Name
_SERVICE: opencode-ohmygosh     # Image Name
_COMPUTE_REGION: europe-west1   # Cloud Run Region
_CLOUD_RUN_SERVICE: opencode-app # Cloud Run Service Name
```

### Build Options

- **Machine Type**: `E2_HIGHCPU_8` (8 vCPUs)
- **Timeout**: 1800s (30 Minuten)
- **Logging**: Cloud Logging only

## 🚢 Cloud Run Deployment (Optional)

Um automatisches Deployment zu Cloud Run zu aktivieren, in `cloudbuild.yaml`:

1. Kommentiere den Cloud Run Deployment Step ein (remove `#`)
2. Passe die Umgebungsvariablen an
3. Commit und push

```bash
git add cloudbuild.yaml
git commit -m "Enable Cloud Run deployment"
git push origin main
```

## 📝 .gcloudignore

Folgende Dateien werden vom Build ausgeschlossen:

- `.git/`
- `node_modules/`
- `*.log`
- `README.md`
- `docs/`

## 🔄 Workflow

1. **Code ändern** → Lokale Entwicklung
2. **Git commit & push** → Trigger startet automatisch
3. **Cloud Build** → Image wird gebaut
4. **Artifact Registry** → Image gespeichert
5. **Optional**: Cloud Run Deployment

## 🐛 Troubleshooting

### Build schlägt fehl

```bash
# Logs anzeigen
gcloud builds log BUILD_ID --project=bkg-ai

# Build Details
gcloud builds describe BUILD_ID --project=bkg-ai
```

### Cloud Run: Container failed to start

**Problem**: `The user-provided container failed to start and listen on the port`

**Ursachen**:

1. **Fehlende AUTH_SECRET**: Container benötigt `AUTH_SECRET` Environment Variable
2. **Port Mismatch**: App läuft auf Port 5003, nicht 8080
3. **Zu kurzer Timeout**: Container braucht länger zum Starten

**Lösung**:

```bash
# Service mit korrekten Einstellungen updaten
./deploy-cloud-run.sh

# Oder manuell:
gcloud run services update bkg \
  --region=europe-west1 \
  --project=bkg-ai \
  --port=5003 \
  --timeout=300 \
  --update-env-vars="AUTH_SECRET=$(openssl rand -base64 32)"
```

### Cloud Run Logs anzeigen

```bash
# Neueste Logs
gcloud run services logs read bkg \
  --region=europe-west1 \
  --project=bkg-ai \
  --limit=100

# Live Logs streamen
gcloud run services logs tail bkg \
  --region=europe-west1 \
  --project=bkg-ai

# Spezifische Revision
gcloud logging read "resource.type=cloud_run_revision AND resource.labels.service_name=bkg" \
  --project=bkg-ai \
  --limit=50 \
  --format="table(timestamp,textPayload)"
```

### Permissions Error

```bash
# Service Account überprüfen
gcloud projects get-iam-policy bkg-ai \
  --flatten="bindings[].members" \
  --filter="bindings.members:*cloudbuild*"
```

### Trigger funktioniert nicht

1. GitHub Connection überprüfen
2. Branch Pattern überprüfen (`^main$`)
3. `cloudbuild.yaml` im Repository vorhanden?

## 📚 Weitere Ressourcen

- [Cloud Build Documentation](https://cloud.google.com/build/docs)
- [Artifact Registry](https://cloud.google.com/artifact-registry/docs)
- [Cloud Run Deployment](https://cloud.google.com/run/docs)
- [Build Triggers](https://cloud.google.com/build/docs/automating-builds/create-manage-triggers)
