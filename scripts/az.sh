
az account set --name Platform

az containerapp create \
    --name ca-patient \
    --resource-group rg-platform \
    --yaml ./.github/kustomize/kustomized.yaml

az containerapp update \
    --name ca-patient \
    --resource-group rg-platform \
    --yaml ./.github/kustomize/kustomized.yaml

az containerapp show \
    --name ca-patient \
    --resource-group rg-platform

# ----------------------------------------------------------
# Traffic management
# ----------------------------------------------------------

# Scenario 1: Latest revision
az containerapp ingress traffic set \
    --name ca-patient \
    --resource-group rg-platform \
    --revision-weight latest=100

# Scenario 2: Stable revision(s)
# - seems like we can do without this step...
# az containerapp ingress traffic set \
#     --name ca-patient \
#     --resource-group rg-platform \
#     --revision-weight latest=0
#     # --revision-weight latest=0 ca-patient--v0-0-75=100

# set staging label to latest revision
az containerapp revision label add \
    --name ca-patient \
    --resource-group rg-platform \
    --label staging \
    --revision latest \
    --no-prompt

# check ingress traffic
az containerapp ingress traffic show \
    --name ca-patient \
    --resource-group rg-platform \
    --query '[?weight == `0` && label == null].revisionName'

# list active revisions
latestRevision=$(az containerapp revision list \
    --name ca-patient \
    --resource-group rg-platform \
    --query '[-1:].name | @[0]')

echo $latestRevision | jq -r '.name'

az containerapp revision restart \
	--name ca-otel-test \
	--resource-group rg-platform \
	--revision "ca-otel-test--v0-0-7"