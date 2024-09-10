#!/bin/bash

# Function to display the menu
show_menu() {
    
  echo
  echo "Select a category:"
  echo "1) Verify Resource Status"
  echo "2) Edit Resource"
  echo "3) Pods Specific Commands"
  echo "4) Exit"
  echo "5) Logout and exit"
}

# Function to handle 'Verify Resource Status' commands
verify_resource_status() {
  echo "\n Insert the resource you want to work with"
  read -p ": " resource_type
  echo
  oc get $resource_type
  echo  
  echo "Select a command:"
  echo "1) oc describe $resource_type <resource-name>"
  echo "2) oc status"
  echo "3) oc rollout status  $resource_type <my-deployment>"
  echo "4) oc rollout history $resource_type <my-deployment>"
  echo "5) oc logs <pod-name>"
  echo "6) oc logs <pod-name> -c <container-name>"
  echo "7) oc logs -f <pod-name>"
  read -p "Enter command number: " cmd
  
  case $cmd in
    1) read -p "Enter resource-name: " resource_name; oc describe $resource_type $resource_name ;;
    2) oc status ;;
    3) read -p "Enter resource-name: " params; oc rollout status $resource_type $resource_name ;;
    4) read -p "Enter resource-name: " params; oc rollout history $resource_type $resource_name ;;
    5) read -p "Enter pod-name: " pod; oc logs $pod ;;
    6) read -p "Enter pod-name and container-name: " pod container; oc logs $pod -c $container ;;
    7) read -p "Enter pod-name: " pod; oc logs -f $pod ;;
    *) echo "Invalid option" ;;
  esac
}

# Function to handle 'Edit Resource' commands
edit_resource() {
  echo "\n Insert the resource you want to work with"
  read -p ": " resource_type
  echo
  oc get $resource_type
  echo  
  echo "Select a command:"
  echo "1) oc replace -f <file.yaml>"
  echo "2) oc apply -f <file.yaml>"
  echo "3) oc label $resource_type <resource-name> <label-key>=<label-value>"
  echo "4) oc edit $resource_type <resource-name>"
  echo "5) oc edit $resource_type <resource-name> -o <file-format>"
  echo "6) oc set image $resource_type <resource-name> <container-name>=<new-image>"
  echo "7) oc set env $resource_type <resource-name> <KEY>=<VALUE>"
  echo "8) oc set resources $resource_type <resource-name> --limits=cpu=<value>,memory=<value>"
  echo "9) oc scale $resource_type <resource-name> --replicas=<number>"
  echo "10) oc annotate $resource_type <resource-name> <description>=<my-description>"
  echo "11) oc delete $resource_type <resource-name>"
  read -p "Enter command number: " cmd
  
  case $cmd in
    1) read -p "Enter file.yaml: " file; oc replace -f $file ;;
    2) read -p "Enter file.yaml: " file; oc apply -f $file ;;
    3) read -p "Enter resource-name, label-key, and label-value: " resource_name label_key label_value; oc label $resource_type $resource_name $label_key=$label_value ;;
    4) read -p "Enter resource-name: " resource_name; oc edit $resource_type $resource_name ;;
    5) read -p "Enter resource-name, and file-format: " resource_name format; oc edit $resource_type $resource_name -o $format ;;
    6) read -p "Enter resource-name, container-name, and new-image: " resource_name container_name new_image; oc set image $resource_type $resource_name $container_name=$new_image ;;
    7) read -p "Enter resource-name, KEY, and VALUE: " resource_name key value; oc set env $resource_type $resource_name $key=$value ;;
    8) read -p "Enter resource-name, value for CPU, and value for memory: " resource_name cpu memory; oc set resources $resource_type $resource_name --limits=cpu=$cpu,memory=$memory ;;
    9) read -p "Enter resource-name, and number of replicas: " resource_name replicas; oc scale $resource_type $resource_name --replicas=$replicas ;;
    10) read -p "Enter resource-name, and description: " resource_name description; oc annotate $resource_type $resource_name $description ;;
    11) read -p "Enter resource-name: " resource_name; oc delete $resource_type $resource_name ;;
    *) echo "Invalid option" ;;
  esac
}

# Function to handle 'Pods Specific Commands' commands
pods_specific_commands() {
  
  echo
  oc get pods -o wide
  echo
  echo "Select a command:"
  echo "1) oc exec <pod-name> -- <command>"
  echo "2) oc exec -it <pod-name> -- /bin/bash"
  echo "3) oc exec -it <pod-name> -c <container-name> -- /bin/bash"
  echo "4) oc rsh <pod-name>"
  echo "5) oc cp /path/in/local <pod-name>:/path/in/container"
  echo "6) oc cp <pod-name>:/path/in/container /path/in/local"
  echo "7) oc port-forward <pod-name> <local-port>:<pod-port>"
  echo "8) oc attach <pod-name>"
  read -p "Enter command number: " cmd
  
  case $cmd in
    1) read -p "Enter pod-name and command: " pod command; oc exec $pod -- $command ;;
    2) read -p "Enter pod-name: " pod; oc exec -it $pod -- /bin/bash ;;
    3) read -p "Enter pod-name and container-name: " pod container; oc exec -it $pod -c $container -- /bin/bash ;;
    4) read -p "Enter pod-name: " pod; oc rsh $pod ;;
    5) read -p "Enter local path and pod path: " local_path pod_path; oc cp $local_path $pod:$pod_path ;;
    6) read -p "Enter pod path and local path: " pod_path local_path; oc cp $pod:$pod_path $local_path ;;
    7) read -p "Enter pod-name, local-port, and pod-port: " pod local_port pod_port; oc port-forward $pod $local_port:$pod_port ;;
    8) read -p "Enter pod-name: " pod; oc attach $pod ;;
    *) echo "Invalid option" ;;
  esac
}

#login
if oc whoami &> /dev/null; then
    echo "You are logged in to OpenShift."
else
  echo "You are not logged in to OpenShift, please insert you cluster data."
  read -p "Host: " oc_host
  read -p "Username: " oc_username
  read -p "Password: " -s oc_password
  oc login $oc_host --username=$oc_username --password=$oc_password
fi

while true; do
  show_menu
  read -p "Enter your choice [1-4]: " choice
  case $choice in
    1) verify_resource_status ;;
    2) edit_resource ;;
    3) pods_specific_commands ;;
    4) echo "Exiting..."; exit 0 ;;
    5) echo "Logout and exiti"; oc logout; exit 0;;
    *) echo "Invalid choice. Please select a number between 1 and 4." ;;
  esac
  echo ""
done

