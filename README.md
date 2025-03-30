# Notes

# Usage

## Kubernetes Deployment with Helm

To deploy the application on Kubernetes using Helm, you need to configure the Helm chart with the appropriate values for your environment. Here's how to do it:

1. Copy the `kube/charts/values.yaml` file and name it according to your streamer's name, for example, `values-j_alexander_hs.yaml`.
2. Edit the copied values file with the streamer's details and any other configurations you want to customize. For example:
   ```yaml
   streamer:
     name: "j_alexander_hs"
     twitchName: "j_alexander_hs"
   ```
3. Save the changes to your new values file.
4. To deploy the Helm chart with your custom values, run the following command from the root of the project:
   ```shell
   helm install youtube-dl-chart ./kube/charts --values ./kube/charts/values-j_alexander_hs.yaml
   ```
   Replace `youtube-dl-chart` with the name you want to give your Helm release, and adjust the paths if your chart is located elsewhere.
5. To update your deployment with new values or after changing the chart, use the `helm upgrade` command:
   ```shell
   helm upgrade youtube-dl-chart ./kube/charts --values ./kube/charts/values-j_alexander_hs.yaml
   ```
6. If you need to remove the deployment, you can use the `helm uninstall` command:
   ```shell
   helm uninstall youtube-dl-chart
   ```

For more details on configuring the Helm chart, refer to the comments in the `values.yaml` file and the Helm documentation.

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
