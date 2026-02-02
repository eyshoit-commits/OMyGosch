# gcloud-admin Context

## Key Commands

### Authentication & Configuration
- `gcloud auth list` - List authenticated accounts
- `gcloud config get-value project` - Show active project
- `gcloud config set project PROJECT_ID` - Set active project
- `gcloud projects list` - List all accessible projects

### Compute Engine (VMs)
- `gcloud compute instances list` - List all VM instances
- `gcloud compute instances create NAME --machine-type=e2-micro --zone=us-central1-a` - Create VM
- `gcloud compute instances describe NAME --zone=ZONE` - Get VM details
- `gcloud compute instances delete NAME --zone=ZONE` - Delete VM
- `gcloud compute zones list` - List available zones
- `gcloud compute machine-types list` - List machine types

### Cloud Storage
- `gcloud storage buckets list` - List buckets
- `gcloud storage buckets create gs://BUCKET_NAME --location=us-central1` - Create bucket
- `gcloud storage buckets delete gs://BUCKET_NAME` - Delete bucket
- `gsutil ls gs://BUCKET_NAME` - List bucket contents
- `gsutil cp FILE gs://BUCKET_NAME/` - Upload file
- `gsutil rm gs://BUCKET_NAME/OBJECT` - Delete object

### Cloud Run
- `gcloud run services list` - List services
- `gcloud run deploy SERVICE --image=IMAGE --region=us-central1` - Deploy service
- `gcloud run services describe SERVICE --region=us-central1` - Get service details
- `gcloud run services delete SERVICE --region=us-central1` - Delete service

### Cloud Functions
- `gcloud functions list` - List functions
- `gcloud functions deploy FUNCTION --runtime=python311 --trigger-http` - Deploy function
- `gcloud functions describe FUNCTION` - Get function details
- `gcloud functions delete FUNCTION` - Delete function

### BigQuery
- `bq ls` - List datasets
- `bq mk DATASET` - Create dataset
- `bq show DATASET.TABLE` - Show table schema
- `bq query 'SELECT * FROM project.dataset.table'` - Run query
- `bq rm -r -f DATASET` - Delete dataset

## File Structure

```
.opencode/
├── agent/
│   └── gcloud-admin.md          # Agent definition
└── context/project/
    └── gcloud-admin-context.md  # This file

~/gcp-deployments/
├── vm-scripts/                  # VM startup scripts
├── cloud-run/                   # Cloud Run service configs
├── functions/                   # Cloud Functions source
└── bigquery/                    # BigQuery query files
```

## Code Style

### Command Formatting
- Always use full flag names (`--machine-type` not `-m`)
- Include `--project` flag when not using default project
- Use `--format=json` for machine-readable output
- Sort flags alphabetically for consistency

### Resource Naming
- Use kebab-case for resource names (e.g., `web-server-prod`)
- Include environment suffix (`-dev`, `-staging`, `-prod`)
- Use descriptive names (e.g., `api-backend` not `instance-1`)

### Region/Zone Strategy
- Default: `us-central1` (Iowa) - best free tier coverage
- For EU data: `europe-west1` (Belgium)
- For Asia: `asia-east1` (Taiwan)
- Always specify zone for Compute Engine (e.g., `us-central1-a`)

## Workflow Rules

1. **Always verify project** - Before any operation, confirm the active project
2. **Check existing resources** - List before create to avoid duplicates
3. **Use dry-run for destructive ops** - Preview deletions with `--dry-run` when available
4. **Tag resources** - Add labels for cost tracking (`--labels=env=dev,team=backend`)
5. **Document outputs** - Save resource IDs and endpoints for reference

## Common Patterns

### VM Setup Pattern
```bash
# 1. Check existing VMs
gcloud compute instances list --filter="name:web-server"

# 2. Create if not exists
gcloud compute instances create web-server \
  --machine-type=e2-micro \
  --zone=us-central1-a \
  --image-family=debian-12 \
  --image-project=debian-cloud \
  --tags=http-server \
  --labels=env=dev,app=web

# 3. Verify
gcloud compute instances describe web-server --zone=us-central1-a
```

### Storage Bucket Pattern
```bash
# 1. Create with uniform access
gcloud storage buckets create gs://my-app-assets \
  --location=us-central1 \
  --uniform-bucket-level-access

# 2. Set lifecycle policy for cost optimization
gsutil lifecycle set lifecycle.json gs://my-app-assets

# 3. Verify
gcloud storage buckets describe gs://my-app-assets
```

### Cloud Run Deployment Pattern
```bash
# 1. Build and push image
gcloud builds submit --tag gcr.io/PROJECT_ID/my-service

# 2. Deploy
gcloud run deploy my-service \
  --image=gcr.io/PROJECT_ID/my-service \
  --region=us-central1 \
  --platform=managed \
  --allow-unauthenticated

# 3. Get URL
gcloud run services describe my-service --region=us-central1 --format='value(status.url)'
```

## Free Tier Limits

| Service | Free Tier |
|---------|-----------|
| Compute Engine | 1 non-preemptible e2-micro/month (US regions only) |
| Cloud Storage | 5 GB Standard Storage/month |
| Cloud Run | 2 million requests/month |
| Cloud Functions | 2 million invocations/month |
| BigQuery | 10 GB storage + 1 TB queries/month |

## Important Notes

- **Billing alerts**: Set up budget alerts at $1, $10, $50 thresholds
- **Preemptible VMs**: Use `--preemptible` for 80% cost savings on non-critical workloads
- **Labels for billing**: Always add labels to track costs by team/environment
- **Cleanup**: Use `gcloud compute instances delete --keep-disks=boot` to preserve data
- **IAM**: Check `gcloud projects get-iam-policy PROJECT_ID` before operations requiring specific roles
