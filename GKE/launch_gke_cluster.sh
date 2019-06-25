#!/bin/bash

REGION=us-central1
ZONE=$REGION-a
# YOURNAME=jhnftzptrck
# CLUSTER_NAME=$YOURNAME-cluster
# source config

CLUSTER_NAME=sysdig-training-cluster

if ! [ -x "$(command -v gccloud)" ]; then
  echo 'You must have Google CLoud CLI installed. See https://cloud.google.com/pubsub/docs/quickstart-cli ' >&2
  exit 1
fi

if [ "$(gcloud container clusters list)" ]; then
  echo 'You already have a cluster running' >&2
  gcloud container clusters list >&2
  exit 1
fi

if ! [ -x "$(command -v kubectl)" ]; then
  echo 'You must have 'kubectl' installed. See https://kubernetes.io/docs/tasks/tools/install-kubectl/ ' >&2
  exit 1
fi

echo "Your Google cloud projects are: "
echo ""
gcloud projects list
echo ""

echo -n "Enter the PROJECT_ID for where you would like your Kubernetes cluster: "
read -r PROJECT_ID

gcloud config set project "$PROJECT_ID"

echo ""
echo "Creating cluster '$CLUSTER_NAME' in project '$PROJECT_ID' and zone '$ZONE'"
echo ""
echo ""

gcloud container clusters create $CLUSTER_NAME \
 --machine-type "$MACHINE_TYPE" \
 --image-type "$IMAGE_TYPE"
echo ""
echo "Cluster created"
echo ""
echo ""

echo "Retreiving cluster credentials"
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID
echo ""

echo "Confirming registration with 'kubectl get nodes'"
kubectl get nodes
echo ""

echo "Checking for admin access with 'kubectl auth can-i create node'"
kubectl auth can-i create node
echo ""

echo "Your cluster is ready. You can access it at
https://console.cloud.google.com/kubernetes/workload_/gcloud/$ZONE/$CLUSTER_NAME?project=$PROJECT_ID"
echo ""
echo "Once you're finished, remember to delete your cluser using the command 'gcloud container clusters delete $CLUSTER_NAME'"
echo ""
