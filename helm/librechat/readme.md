# LibreChat Helm Chart

Deploys the full LibreChat stack on Kubernetes, including all supporting services.

## Services

| Service | Type | Default | Purpose |
|---------|------|---------|---------|
| **LibreChat** | Deployment | enabled | Main application (API + frontend) |
| **MongoDB** | StatefulSet (Bitnami) | enabled | Primary database |
| **Meilisearch** | StatefulSet | enabled | Full-text search |
| **Redis** | StatefulSet (Bitnami) | enabled | Cache, sessions (DB 0), SearXNG (DB 1), Code Interpreter (DB 4) |
| **MinIO** | StatefulSet | enabled | S3-compatible file storage (50Gi) |
| **SearXNG** | Deployment | enabled | Meta-search engine for web search |
| **Firecrawl** | Deployment | enabled | Web scraping service |
| **Firecrawl Playwright** | Deployment | enabled | Headless browser for Firecrawl |
| **Firecrawl Redis** | Deployment | enabled | Dedicated Redis for Firecrawl (noeviction) |
| **RabbitMQ** | Deployment | enabled | Message queue for Firecrawl |
| **NUQ PostgreSQL** | StatefulSet | enabled | Firecrawl job queue DB (PG17 + pg_cron) |
| **Sandpack Bundler** | Deployment | enabled | Code artifact rendering |
| **Code Interpreter** | Deployment | enabled | Sandboxed code execution (DinD sidecar) |
| **RAG API** | Deployment | disabled | Retrieval-augmented generation |

## Prerequisites

- Kubernetes 1.29+ (Code Interpreter requires native sidecar support, KEP-753)
- Helm 3.x
- A CNI plugin supporting NetworkPolicies (Calico, Cilium, etc.) if enabling `networkPolicies`

## Quick Start

### 1. Create the credentials secret

Generate required secrets and create a Kubernetes Secret:

```bash
# Generate values
CREDS_KEY=$(openssl rand -hex 32)
CREDS_IV=$(openssl rand -hex 16)
JWT_SECRET=$(openssl rand -hex 32)
JWT_REFRESH_SECRET=$(openssl rand -hex 32)
MEILI_MASTER_KEY=$(openssl rand -hex 32)
SEARXNG_SECRET=$(openssl rand -hex 32)
REDIS_PASSWORD=$(openssl rand -hex 32)

# Create secret
kubectl create secret generic librechat-credentials-env \
  --from-literal=CREDS_KEY=$CREDS_KEY \
  --from-literal=CREDS_IV=$CREDS_IV \
  --from-literal=JWT_SECRET=$JWT_SECRET \
  --from-literal=JWT_REFRESH_SECRET=$JWT_REFRESH_SECRET \
  --from-literal=MEILI_MASTER_KEY=$MEILI_MASTER_KEY \
  --from-literal=REDIS_PASSWORD=$REDIS_PASSWORD \
  --from-literal=MINIO_ROOT_USER=minioadmin \
  --from-literal=MINIO_ROOT_PASSWORD=$(openssl rand -hex 32)
```

Add API keys as needed:

```bash
kubectl patch secret librechat-credentials-env -p \
  '{"stringData":{"OPENAI_API_KEY":"sk-..."}}'
```

### 2. Build subchart dependencies

```bash
helm dependency build helm/librechat
```

### 3. Install the chart

```bash
helm install librechat helm/librechat \
  --set searxng.secretKey=$SEARXNG_SECRET
```

The SearXNG `secretKey` is required and has no default. Pass it via `--set` or in a values override file.

## Secret Reference

The chart reads all sensitive values from a single Secret (default: `librechat-credentials-env`).

**Always required:**

| Key | How to generate |
|-----|-----------------|
| `CREDS_KEY` | `openssl rand -hex 32` |
| `CREDS_IV` | `openssl rand -hex 16` |
| `JWT_SECRET` | `openssl rand -hex 32` |
| `JWT_REFRESH_SECRET` | `openssl rand -hex 32` |
| `MEILI_MASTER_KEY` | `openssl rand -hex 32` |
| `REDIS_PASSWORD` | `openssl rand -hex 32` |
| `MINIO_ROOT_USER` | Choose a username |
| `MINIO_ROOT_PASSWORD` | `openssl rand -hex 32` |

**Required when `firecrawl.enabled`:**

| Key | Purpose |
|-----|---------|
| `FIRECRAWL_DB_USER` | NUQ PostgreSQL username |
| `FIRECRAWL_DB_PASSWORD` | NUQ PostgreSQL password |
| `FIRECRAWL_BULL_AUTH_KEY` | Firecrawl Bull queue auth key |

**Required when `codeInterpreter.enabled`:**

| Key | Purpose |
|-----|---------|
| `LIBRECHAT_CODE_API_KEY` | Shared API key between LibreChat and Code Interpreter |

**Optional (add as needed):**

| Key | Purpose |
|-----|---------|
| `OPENAI_API_KEY` | OpenAI API (TTS/STT via LiteLLM) |
| `AZURE_OPENAI_API_KEY` | Azure OpenAI |
| `AZURE_TTS_API_KEY` | Azure Text-to-Speech |
| `OCR_API_KEY` | OCR service |
| `OPENID_CLIENT_ID` | OpenID Connect client ID |
| `OPENID_CLIENT_SECRET` | OpenID Connect client secret |
| `OPENID_SESSION_SECRET` | OpenID session secret |

## Configuration

### Service discovery

The chart auto-generates connection strings for enabled services in the ConfigMap:

- `MONGO_URI` — MongoDB connection string
- `MEILI_HOST` — Meilisearch URL
- `REDIS_URI` — Redis URL (with auth)
- `SEARXNG_INSTANCE_URL` — SearXNG internal URL
- `FIRECRAWL_API_URL` — Firecrawl internal URL
- `AWS_ENDPOINT_URL` — MinIO internal URL
- `AWS_PRESIGN_ENDPOINT_URL` — Public-facing URL for MinIO presigned URLs (derived from Ingress)

These are generated only when the corresponding service is enabled and can be overridden via `librechat.configEnv`.

### Ingress

The chart configures multi-path Ingress routing:

| Path | Backend | Condition |
|------|---------|-----------|
| `/` | LibreChat | Always |
| `/librechat-files/` | MinIO | `minio.enabled` |
| `/code-interpreter-files/` | MinIO | `minio.enabled` and `codeInterpreter.enabled` |
| `/artifacts/` | Sandpack | `sandpack.enabled` |

MinIO presigned URL routes do **not** rewrite paths (the presigned signature includes the path).

### Disabling services

Any service can be disabled:

```yaml
firecrawl:
  enabled: false
sandpack:
  enabled: false
codeInterpreter:
  enabled: false
```

### NetworkPolicies

Disabled by default. When enabled, restricts inbound traffic to data stores and internal services:

```yaml
networkPolicies:
  enabled: true
```

Policies enforce that:
- MongoDB accepts connections only from LibreChat
- Redis accepts connections only from LibreChat, SearXNG, and Code Interpreter
- Meilisearch accepts connections only from LibreChat
- MinIO accepts connections only from LibreChat, Code Interpreter, and the MinIO Init Job
- Firecrawl internal services (Redis, RabbitMQ, PostgreSQL, Playwright) accept connections only from Firecrawl

Requires a CNI plugin that supports NetworkPolicies. If your namespace has a default-deny ingress policy, you will also need a NetworkPolicy allowing traffic from your ingress controller to LibreChat, Sandpack, and MinIO pods.

### Code Interpreter

Uses a Docker-in-Docker (DinD) sidecar pattern for containerd-based clusters. The DinD daemon runs as a K8s native sidecar (`initContainer` with `restartPolicy: Always`), requiring **Kubernetes 1.29+** (or 1.28 with the `SidecarContainers` feature gate enabled).

The DinD container requires `privileged: true`. Consider isolating it on a dedicated node pool with taints.

### Production values

See `values-production.yaml` for a production-ready configuration example with:
- Ingress TLS via cert-manager
- Resource limits
- NetworkPolicies enabled

```bash
helm install librechat helm/librechat \
  -f helm/librechat/values-production.yaml \
  --set searxng.secretKey=$(openssl rand -hex 32)
```

## Development

### Lint the chart

```bash
helm dependency build helm/librechat
helm lint helm/librechat --set searxng.secretKey=test
```

### Validate template rendering

```bash
helm template test helm/librechat --set searxng.secretKey=test > /dev/null
```

### CI

The `.github/workflows/helm-lint.yml` workflow runs on PRs touching `helm/**`:
- Lints with default values
- Lints with all optional services disabled
- Validates template rendering
- Validates template rendering with NetworkPolicies enabled

## Uninstall

```bash
helm uninstall librechat
```

PersistentVolumeClaims for MongoDB, Meilisearch, Redis, MinIO, and NUQ PostgreSQL are **not** deleted automatically. Remove them manually if you want to discard data:

```bash
kubectl delete pvc -l app.kubernetes.io/instance=librechat
```
