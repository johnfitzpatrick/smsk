#!/bin/bash

YOURNAME=jhnftzptrck
REGION=us-central1
ZONE=$REGION-a
# CLUSTER_NAME=$YOURNAME-cluster
CLUSTER_NAME=sysdig-training-cluster
# source config

echo "Your Google cloud projects are: "
echo ""
gcloud projects list
echo ""

echo -n "Enter the PROJECT_ID for where you would like your Kubernetes cluster: "
read PROJECT_ID

gcloud config set project $PROJECT_ID

echo "Creating cluster $CLUSTER_NAME in project $PROJECT_ID in zone $ZONE"
echo ""

gcloud container clusters create $CLUSTER_NAME \
 --machine-type "$MACHINE_TYPE" \
 --image-type "$IMAGE_TYPE"

echo "Cluster created"
echo ""

echo "Retreiving cluster credentials"
gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID
echo ""

echo "Confirming registratin with 'kubectl get nodes'"
kubectl get nodes
echo ""

echo "Checking for admin access with 'kubectl auth can-i create node'"
kubectl auth can-i create node
echo ""
