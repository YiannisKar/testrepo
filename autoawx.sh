#!/bin/bash

minikube start
cat >  kustomization.yaml <<EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - github.com/ansible/awx-operator/config/default?ref=2.2.1

images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.2.1 

namespace: awx 
EOF

kubectl apply -k .
kubectl config set-context --current --namespace=awx
cat > awx-demo.yaml <<EOF
---
apiVersion: awx.ansible.com/v1beta1
kind: AWX
metadata:
  name: awx-demo
spec:
  service_type: nodeport

EOF
cat > kustomization.yaml <<EOF

apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - github.com/ansible/awx-operator/config/default?ref=2.2.1
  - awx-demo.yaml
images:
  - name: quay.io/ansible/awx-operator
    newTag: 2.2.1

namespace: awx
EOF
kubectl apply -k .
minikube service -n awx awx-demo-service --url
kubectl get secret awx-demo-admin-password -o jsonpath="{.data.password}" | base64 --decode ; echo
yDL2Cx5Za94g9MvBP6B73nzVLlmfgPjR
