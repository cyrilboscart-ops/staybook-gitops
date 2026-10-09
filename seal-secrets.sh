#!/bin/sh
set -e

kubectl create secret generic postgres-hotels -n staybook-dev --dry-run=client -o yaml \
  --from-literal=POSTGRES_DB=hotels --from-literal=POSTGRES_USER=hotels --from-literal=POSTGRES_PASSWORD=hotels \
  | kubeseal --format yaml --cert pub-cert.pem > overlays/dev/sealed-secrets.yaml

kubectl create secret generic postgres-reservations -n staybook-dev --dry-run=client -o yaml \
  --from-literal=POSTGRES_DB=reservations --from-literal=POSTGRES_USER=reservations --from-literal=POSTGRES_PASSWORD=reservations \
  | kubeseal --format yaml --cert pub-cert.pem >> overlays/dev/sealed-secrets.yaml

kubectl create secret generic postgres-hotels -n staybook-prod --dry-run=client -o yaml \
  --from-literal=POSTGRES_DB=hotels --from-literal=POSTGRES_USER=hotels --from-literal=POSTGRES_PASSWORD=hotels \
  | kubeseal --format yaml --cert pub-cert.pem > overlays/prod/sealed-secrets.yaml

kubectl create secret generic postgres-reservations -n staybook-prod --dry-run=client -o yaml \
  --from-literal=POSTGRES_DB=reservations --from-literal=POSTGRES_USER=reservations --from-literal=POSTGRES_PASSWORD=reservations \
  | kubeseal --format yaml --cert pub-cert.pem >> overlays/prod/sealed-secrets.yaml

echo "=== fini ==="
grep -c 'kind: SealedSecret' overlays/dev/sealed-secrets.yaml overlays/prod/sealed-secrets.yaml
