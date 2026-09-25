# Bare-Metal DevOps Automation Platform

A hands-on DevOps automation project that demonstrates end-to-end CI/CD, infrastructure automation, configuration management, deployment validation, and operational automation on an existing bare-metal Kubernetes environment.

## Project Goal

The goal of this project is to build a reproducible automation platform using:

- Jenkins for CI/CD orchestration
- Terraform for Kubernetes platform resource management
- Ansible for Linux and Kubernetes node automation
- Docker for application containerization
- Harbor as a private container registry
- Trivy for container image security scanning
- Kubernetes for application deployment
- Rook-Ceph for persistent storage
- Prometheus and Grafana for monitoring

The project is designed around an existing 3-node bare-metal Kubernetes cluster.

## High-Level Automation Flow

```text
Developer
    |
    | git push
    v
GitHub
    |
    v
Jenkins
    |
    +-----------------------+
    |                       |
    v                       v
Application CI         Infrastructure Validation
    |                       |
Unit Tests             Terraform Validate
Docker Build           Ansible Lint
Trivy Scan             Configuration Checks
    |                       |
    +-----------+-----------+
                |
                v
             Harbor
                |
                v
          Deployment Stage
                |
        +-------+-------+
        |               |
        v               v
    Terraform        Ansible
        |               |
Kubernetes Platform   Bare-Metal Nodes
Resources             Configuration
        |               |
        +-------+-------+
                |
                v
           Kubernetes
                |
                v
         Deployment Tests
                |
         +------+------+
         |             |
      Success        Failure
         |             |
       Done          Rollback
```

## Current Environment

The lab currently consists of:

- 3-node bare-metal Kubernetes cluster
- Rook-Ceph storage running inside Kubernetes
- Linux-based Kubernetes nodes
- Existing containerized workload experience
- Git-based source control

## Responsibilities of Each Tool

### Jenkins

Jenkins will act as the central CI/CD automation engine.

It will:

- Detect code changes
- Run application tests
- Validate Terraform code
- Validate Ansible code
- Build Docker images
- Scan images using Trivy
- Push images to Harbor
- Trigger deployments
- Perform post-deployment validation
- Handle deployment failure and rollback

### Terraform

Terraform will manage reproducible Kubernetes platform resources.

Examples include:

- Namespaces
- RBAC
- Resource quotas
- Limit ranges
- ConfigMaps
- Network policies
- Persistent storage resources
- Helm releases
- Application platform resources

Terraform will not provision the physical Kubernetes cluster because the cluster already exists.

### Ansible

Ansible will automate configuration and operational tasks on the physical Kubernetes nodes.

Examples include:

- Linux baseline configuration
- Package management
- User management
- SSH configuration
- Kernel modules
- sysctl settings
- Time synchronization
- Monitoring agents
- Maintenance tasks
- Backup automation
- Kubernetes node operational tasks

## Project Phases

The project will be implemented incrementally:

1. Repository and project foundation
2. Environment baseline documentation
3. Jenkins installation and configuration
4. Application CI pipeline
5. Ansible node automation
6. Terraform Kubernetes automation
7. Jenkins continuous deployment integration
8. Staging and production promotion workflow
9. Health checks and automated rollback
10. Monitoring and observability
11. Security and pipeline hardening
12. Final documentation and portfolio preparation

## Repository Structure

```text
baremetal-devops-automation-platform/
├── app/
├── ansible/
│   ├── group_vars/
│   ├── inventory/
│   ├── playbooks/
│   └── roles/
├── terraform/
│   ├── environments/
│   │   ├── dev/
│   │   ├── staging/
│   │   └── production/
│   └── modules/
├── jenkins/
├── scripts/
├── docs/
├── Jenkinsfile
├── .gitignore
└── README.md
```

## Project Status

🚧 Work in progress.

The project is being built phase-by-phase with each phase documented and version-controlled in Git.
