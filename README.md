# GitHub Actions

EReusable GitHub Action workflows and actions.

## Quick Start

### Workflows

To use a workflow, add a reference to the workflow in your repository's `.github/workflows` directory. For example, to use the `build-go.yml` workflow, add the following to your repository's `.github/workflows` directory:

```yaml
jobs:
  deploy:
    uses: endo-checker/github-actions/.github/workflows/container-app-deploy.yaml@main
    secrets: inherit
    with:
      resourceGroup: ${{ vars.RESOURCE_GROUP }}
      acrName: ${{ vars.ACR_NAME }}
```
