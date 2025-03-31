# Notes

# Usage

## Kubernetes Deployment with Helm

This project publishes its Helm chart to GitHub Container Registry (GHCR), allowing for easy installation.

**Prerequisites:**
*   Helm v3.8.0 or later (for OCI support).
*   Access to your Kubernetes cluster configured (`kubectl` context).

**Installation:**

1.  **Install the Chart:** Install the Helm chart directly from the GHCR OCI registry.
    *   Replace `<release-name>` with a name for your deployment (e.g., `youtube-dl-streamer1`).
    *   Replace `<chart-version>` with the specific chart version you want to deploy (e.g., `3.1.0`). Find available versions on the repository's Packages page. Note that chart versions in the registry do not have the `v` prefix.

    ```shell
    helm install <release-name> oci://ghcr.io/liofal/youtube-dl/youtube-dl-chart --version <chart-version>
    ```

2.  **Customize Installation (Optional):** You can override default values from `values.yaml` during installation:
    *   Using `--set` (example for streamer 'j_alexander_hs', assuming chart version `3.1.0`):
        ```shell
        helm install <release-name> oci://ghcr.io/liofal/youtube-dl/youtube-dl-chart --version 3.1.0 --set streamer.name=j_alexander_hs --set streamer.twitchName=j_alexander_hs
        ```
    *   Using a custom values file (example for streamer 'j_alexander_hs', assuming chart version `3.1.0`): Create a `my-values.yaml` file and use `-f`:
        ```yaml
        # my-values.yaml
        streamer:
          name: "j_alexander_hs"
          twitchName: "j_alexander_hs"
        # schedule: "*/30 * * * *" # Example override
        ```
        ```shell
        helm install <release-name> oci://ghcr.io/liofal/youtube-dl/youtube-dl-chart --version 3.1.0 -f my-values.yaml
        ```

**Upgrading:**

To upgrade an existing release to a new chart version (e.g., `3.2.0`) or with changed values:
```shell
helm upgrade <release-name> oci://ghcr.io/liofal/youtube-dl/youtube-dl-chart --version <new-chart-version> [-f my-values.yaml] [--set key=value,...]
```

**Uninstalling:**

To remove the deployment:
```shell
helm uninstall <release-name>
```

**(Note on Authentication):** Since the GHCR package for this chart is public, `helm registry login ghcr.io` is typically not required for installation or upgrades. Login might only be necessary for specific actions or if the package visibility changes in the future.*

## Docker Deployment with compose
service definition is now through environment variable, multiple ways are supported, see here:
https://docs.docker.com/compose/environment-variables/

an easy way to make it dynamic:
ie:
```
export TWITCH=j_alexander_hs
docker-compose up youtube-dl
```

# Versioning Change Notice

**Important:** Starting from version `v3.0.0`, this project has adopted Semantic Versioning (SemVer) using the `vX.X.X` format (e.g., `v3.0.0`, `v3.1.0`).

Previously, versions might have been tagged without the leading `v` (e.g., `3.0`, `2.3`). This change aligns the project with standard versioning practices for clearer release management.

If you are pulling images using specific version tags, please ensure you use the new `vX.X.X` format going forward (e.g., `image:tag` becomes `image:v3.0.0`). Users pulling the `latest` tag are generally unaffected by this change in tagging convention but relying on `latest` is not recommended for production environments.

## 3.0
support for kubernetes deployment via helm charts.

## 2.3
addition of cookies file for support of download of subscribers only vod's

## 2.2
adapting for twitch stream to prevent download of vod of ongoing livestream
addition of devcontainer definition

## 2.0
youtube-dl being discontinued, migrate to [yt-dlp](https://github.com/yt-dlp/yt-dlp) fork of youtube-dl

## 1.3.1
Add retries default to 5

## 1.3
Upgrade to python 3.11
