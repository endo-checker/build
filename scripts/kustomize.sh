
revisionSuffix=$(echo "v1.0.0" | sed 's/\./-/g') \

kustomize edit add patch \
    --kind containerapp \
    --patch '[
        {"op": "replace", "path": "/properties/configuration/secrets/0/value", "value": "ACR_PASSWORD"},
        {"op": "replace", "path": "/properties/template/containers/0/image", "value": "IMAGE_NAME"},
        {"op": "replace", "path": "/properties/template/revisionSuffix", "value": "REVISION_SUFFIX"}
    ]'

kustomize build ./.github/kustomize | yq 'del(.metadata)' - > ./.github/kustomize/kustomized.yaml

# yq --inplace '
#     .[0].value = "ACR_PASSWORD" |
# 	.[1].value = "CONTAINER_IMAGE" |
# 	.[2].value = "REVISION_SUFFIX"
# ' ./.github/kustomize/patches-runtime.yaml

# yq --inplace '
#     (.properties.configuration.secrets[] | select(.name == "registry-secret") | .value) = "a6c9GfE47/EZXEOmlX7MX+S/iAXPtrBaSTOuof2B/f+ACRCt2DjE" |
#     .properties.template.containers[0].image = "acrendochecker.azurecr.io/traefik:latest" |
#     .properties.template.revisionSuffix = strenv(revisionSuffix)
# ' ./.github/kustomize/kustomized.yaml