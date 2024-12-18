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


## Update the catalog resources

https://raw.githubusercontent.com/kubedb/pg-sqlserver-demo/refs/heads/archiver-demo/archiver/catalog-15.5-tds-fdw.yaml

https://github.com/kubedb/pg-sqlserver-demo/blob/archiver-demo/archiver/catalog-16.1-tds-fdw.yaml

## Create database with archiver:true labels and wait untill db get ready

Exec into primary pod and insert some data
```bash
kubectl exec -it -n demo ha-postgres-0 -- bash

ha-postgres-0:/$ psql
psql (15.5)
Type "help" for help.

postgres=# create table hi(id int);
CREATE TABLE
postgres=# insert into hi(id) values(generate_series(1,11111));
INSERT 0 11111
postgres=# select pg_switch_wal();
 pg_switch_wal 
---------------
 0/160D8818
(1 row)
```
> note: use select pg_switch_wal(); if you want to restore to the latest point in time.

Now create restore database giving any time that surpasses current time. DB should be restored time the time mentioned in the `incremental snapshot`.

### incremental snapshot

 kubectl get snapshots -n demo ha-postgres-incremental-snapshot -oyaml

```yaml
apiVersion: storage.kubestash.com/v1alpha1
kind: Snapshot
metadata:
  creationTimestamp: "2024-12-18T06:32:07Z"
  finalizers:
  - kubestash.com/cleanup
  generation: 1
  name: ha-postgres-incremental-snapshot
  namespace: demo
  resourceVersion: "212504"
  uid: 75575e15-373e-4cfe-a97e-e3107ccf317a
spec:
  appRef:
    kind: Postgres
    name: ha-postgres
    namespace: demo
  deletionPolicy: Delete
  repository: ha-postgres-full
  snapshotID: 01JFC7EX6652W37BDFM86569SN
  type: IncrementalBackup
  version: v1
status:
  components:
    wal:
      logStats:
        end: "2024-12-18T07:24:45.483001Z"
        lsn: 0/160D87D8
  conditions:
  - lastTransitionTime: "2024-12-18T06:41:53Z"
    message: Recent snapshot list updated successfully
    reason: SuccessfullyUpdatedRecentSnapshotList
    status: "True"
    type: RecentSnapshotListUpdated
  - lastTransitionTime: "2024-12-18T06:41:54Z"
    message: Metadata uploaded to backend successfully
    reason: SuccessfullyUploadedSnapshotMetadata
    status: "True"
    type: SnapshotMetadataUploaded
  phase: Running
  totalComponents: 1
```

your database should be restored till `status.compontents.wal.logStats.end`
