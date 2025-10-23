# docker-img-ansible

Multi-arch Docker image based on Node that includes Python, Git and ansible-core.

This repository contains:

- `Dockerfile` - builds a container from `node:<version>-slim` and installs Python packages and Ansible collections
- `pip-requirements.txt` - specifies Python package versions including ansible-core
- `galaxy-requirements.yml` - specifies Ansible collections to install
- `.github/workflows/docker-build.yml` - GitHub Actions workflow that builds multi-architecture images and pushes to GitHub Container Registry (ghcr.io)

## Image name

Images are published to GitHub Container Registry under your repository path:

```bash
ghcr.io/<your-username-or-org>/<repo-name>
```

For this repository the image path is:

```bash
ghcr.io/timherrm/docker-img-ansible
```

## Tags produced by the workflow

The workflow creates these tags on each build:

- `ansible-<version>` — the Ansible core version installed in the image (e.g. `ansible-2.19.3`)
- `ansible-<version>-<YYYYMMDDhhmm>` — Ansible version with build date and time (e.g. `ansible-2.19.3-20251023hhmm`)
- `latest` — points to the latest build on `main`

## Pulling the image

If the package is public you can pull without authentication:

```bash
docker pull ghcr.io/timherrm/docker-img-ansible:ansible-2.19.3
```

If the package is private you need a Personal Access Token (PAT) with `read:packages`:

```bash
export GHCR_PAT="ghp_..."
echo "$GHCR_PAT" | docker login ghcr.io -u <your-username> --password-stdin
docker pull ghcr.io/timherrm/docker-img-ansible:ansible-2.19.3-202510231200
```

## Managing Dependencies

### Python Packages

Python packages and their versions are managed in `pip-requirements.txt`. To change the ansible-core version or add new Python packages:

1. Edit `pip-requirements.txt`
2. Push to `main`
3. The workflow will build a new image with updated packages

### Ansible Collections

Ansible collections are managed in `galaxy-requirements.yml`. To add or update collections:

1. Edit `galaxy-requirements.yml`
2. Push to `main`
3. The workflow will build a new image with updated collections

## License

See `LICENSE` in this repository.
