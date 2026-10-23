# Lab6: AWS, Ansible, Docker and Obserbility stack

This repository contains the infrastructure-as-code and configuration management playbooks required to deploy a public instance on AWS and a nginx container with an integrated, GitOps-driven observability stack powered by **Prometheus** and **Grafana**.

---

## 🏛️ Architecture Overview

The infrastructure consists of a public-facing proxy layer and an isolated private application layer running on **Amazon Linux 2023**:

```
[ Local Admin / Ansible ]
          |
          |  SSH Jump / Agent Forwarding
          v
+-------------------------------------------------------+
| Public Subnet                                         |
|                                                       |
|  +-------------------------------------------------+  |
|  | Public EC2 instance                             |  |
|  |  - Public IP                                    |  |
|  |  - swap                                         |  |
|  |  - docker app                                   |  |
|  |  - Prometheus Server                            |  |
|  |  - Grafana Visualizations                       |  |
|  |  - Node Exporter (:9100)                        |  |
|  +-------------------------------------------------+  |
+-------------------------------------------------------+
```
---

## Repository Layout
```
.
├── ansible
│   ├── ansible.cfg                         # Main configuration to be used with AWS
│   ├── inventory
│   │   └── aws_ec2.yml                     # Dynamuc AWS EC2 inventory
│   ├── roles
│   │   ├── docker_app
│   │   │   ├── tasks
│   │   │   │   └── main.yml                # tasks to be perform for docker_app role
│   │   │   └── templates
│   │   │       └── index.html.j2           # index file used for the nginx service on the container
│   │   ├── grafana
│   │   │   ├── handlers
│   │   │   ├── tasks
│   │   │   │   └── main.yml                # tasks to be perform for grafana role
│   │   │   └── templates
│   │   ├── node_exporter
│   │   │   ├── handlers
│   │   │   │   └── main.yml                # handlers to be perform for node_exporter role
│   │   │   └── tasks
│   │   │       └── main.yml                # tasks to be perform for node_exporter role
│   │   ├── prometheus
│   │   │   ├── handlers
│   │   │   │   └── main.yml                # handlers to be perform for prometheus role
│   │   │   ├── tasks
│   │   │   │   └── main.yml                # tasks to be perform for prometheus role
│   │   │   └── templates
│   │   │       └── prometheus.yml.j2       # template used for prometheus role
│   │   ├── swap
│   │   │   └── tasks
│   │   │       └── main.yml                # task to be perform for swap role
│   └── site.yml                            # main playbook
├── README.md                               # This README file
└── terraform
    ├── backend.tf                          # S3 backend used to store state file
    ├── datasource.tf                       # AMI and instnace_type datasource
    ├── main.tf                             # Main terraform file
    ├── outpurs.tf                          # Output to get public ip and AZs
    ├── providers.tf                        # AWS provider confif
    └── variables.tf                        # Environment variable used
```

# Prerequisites

- Terraform CLI installed (v1.0.0+).
- Ansible installed
- AWS CLI configured via aws configure.
- An SSH key pair created on your AWS account (for this practice we used one called "MyEC2KeyPair")

# Step-by-Step Deployment Guide

### Step 1: Clone the Repository & Navigate to Terraform Directory
```
git clone [https://github.com/](https://github.com/)/.git
cd /terraform
```
### Step 2: Initialize Terraform
Download the required AWS provider modules:
```
terraform init
```
### Step 3: Preview the Execution Plan
Review all resources Terraform intends to provision:
```
terraform plan
```
### Step 4: Apply Configuration
Deploy the architecture to AWS:
```
terraform apply -auto-approve
```
Upon completion, Terraform will output the server details:
- public_ip_ec2

# Start Configuration Management via Ansible

### Step 1: Navigate to Ansible Directory
```
cd /ansible
```
### Step 2: Verify that Ansible get proper info of inventory
```
ansible-inventory --graph
```
You should get the ip address of the ec2 public
If you get any error please confirm that the path of the `private_key_file` is the correct one where your key pair is located if not please update and save file

### Step 3: Apply Ansible Playbook 
```
ansible-playbook site.yml
```

## 🛠️ Ansible Automation & Swap Provisioning

The Ansible playbook manages system dependencies, swap management, and metric exporter deployment across all targets.

# Verification & Testing
## Nginx container service
1. Allow some minutes for the Ansible Playbook to finish installing and initializing Apache service.

2. Verify HTTP routing via `curl`:
```
curl http://<PUBLIC_IP>:8080
```
3. Alternatively, open your browser and navigate to:
```
http://<PUBLIC_IP>:8080
```

## 📊 Observability Stack Configuration of the Node

### 1. Prometheus Scrape Targets
Prometheus runs on the Public Proxy and pulls metrics every 15 seconds from all nodes across the environment.

* **Proxy Node Metric Endpoint**: `localhost:9100`
* **App Node Metric Endpoint**: `10.0.2.x:9100`
* **Grafana Endpoint**: `<PUBLIC_IP:3000>` 
    - Username/Password is admin/admin

### 2. Core PromQL Queries Used in Grafana

**CPU Utilization (%)**:
  ```promql
  100 - (avg by (instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
  ```

**CMemory Usage (%)**:
  ```promql
  (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100
  ```

**Root Disk Space Usage (%)**:
  ```promql
  (1 - (node_filesystem_free_bytes{mountpoint="/", fstype!~"tmpfs|fuse.lxc"} / node_filesystem_size_bytes{mountpoint="/", fstype!~"tmpfs|fuse.lxc"})) * 100
  ```
## 📊 Observability Stack Configuration of the Container
Prometheus runs on the Public Proxy and pulls metrics every 15 seconds from cadvisor installed from Ansible

### 1. Login into Grafana
### 2. Add a Panel or Import a Dashboard:
    - Go to Dashboards > Import.
    - Enter a community dashboard ID 11600
### 3. Enjoy the View: You’ll instantly get a polished, production-grade dashboard for containers
