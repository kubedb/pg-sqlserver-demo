## Kubestash release v2024.12.9

```
helm install kubestash oci://ghcr.io/appscode-charts/kubestash \
  --version v2024.12.9 \
  --namespace stash --create-namespace \
  --set-file global.license=/path/to/the/license.txt \
  --wait --burst-limit=10000 --debug
```

kubectl apply -f https://raw.githubusercontent.com/kubestash/apimachinery/refs/heads/master/crds/storage.kubestash.com_snapshots.yaml

## Update kubedb provisioner image

kubectl -n kubedb set image deployment/kubedb-kubedb-provisioner operator=arnobkumarsaha/kubedb-provisioner:v0.49.0_linux_amd64



