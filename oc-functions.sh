#!/bin/bash

function edit-replicas {
  echo -e "\nListing all project: \n"
  sleep 2
  oc projects
  echo -e "\nSelect a project"
  read -p ": " project_name

  echo -e "\nSet number of replicas"
  read -p ": " replicas_number

  for deployment in $(oc get deployments -n $project_name -o name); do
    oc scale $deployment -n $project_name --replicas=$replicas_number
  done

  echo
  oc get deployment
}


function restart-unhealthy-pods {
  echo -e "\nListing all project: \n"
  sleep 2
  oc projects
  echo -e "\nSelect a project"
  read -p ": " project_name 

  echo "Checking pod status in project: $project_name"
  oc get pods -n $project_name --field-selector=status.phase!=Running -o name | while read pod; do
    echo "Restarting $pod"
      oc delete $pod -n $project_name
  done
}


function rollback-deployment {
  echo -e "\nListing all project: \n"
  sleep 2
  oc projects
  echo -e "\nSelect a project"
  read -p ": " project_name  
  
  echo -e "\nListing deployments in project $project_name"
  oc get deployments -n $project_name
  echo -e "\nEnter deployment name"
  read -p ": " deployment_name

  oc rollout history deployment $deployment_name 
  echo -e "\n Enter revision to apply"
  read -p ": " revision_number
  oc rollout undo deployment $deployment_name -n $project_name --to-revision=$revision_number
}


function probe-check {
  echo -e "\nListing all projects: \n"
  sleep 2
  oc projects
  echo -e "\nSelect a project"
  read -p ": " project_name

  for pod in $(oc get pods -n $project_name -o name); do
    echo -e "\n$pod"

    liveness_output=$(oc describe $pod | grep -i liveness)
    if [ -z "$liveness_output" ]; then
      echo "Liveness probe not found."
    else
      echo "$liveness_output"
    fi

    readiness_output=$(oc describe $pod | grep -i readiness)
    if [ -z "$readiness_output" ]; then
      echo "Readiness probe not found."
    else
      echo "$readiness_output"
    fi

  done
}

