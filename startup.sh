#!/bin/bash
set -e 
CHART_DIR="./helm-manifest"
VALUES_DIR="./values"

for values_file in "$VALUES_DIR"/*-values.yaml; do
  filename=$(basename "$values_file")
  service_name="${filename%-values.yaml}"

  echo "Installing: $service_name"
  helm upgrade --install "$service_name" "$CHART_DIR" -f "$values_file" 

  if [ $? -ne 0 ]; then
    echo "ERROR: Failed to install $service_name"
    exit 1
  fi

  echo "Done: $service_name"
  echo "---"
done

echo "All services installed."

echo "Waiting for all services to be ready..."
echo "-----------------------------------------------"
echo "Once the service is up and running, you can access it using the following command:"
echo "kubectl port-forward svc/frontend-external 9090:80"


echo "==============================================="
echo "To clean up the environment, run the following command:"
echo "helm ls | awk 'NR > 1 { print  $1}' | xargs helm uninstall"
