# Security Policy

## Overview

MedStock Monitor follows a **Shift-Left DevSecOps** approach by integrating automated security validation into every stage of the software delivery lifecycle. Security scanning is performed before deployment so that vulnerabilities, insecure infrastructure configurations, and container risks are identified and remediated during development rather than after release.

Every Pull Request must successfully complete dependency scanning, container image scanning, Infrastructure as Code (IaC) scanning, automated testing, and linting before it can be merged into the protected `main` branch. The Continuous Deployment (CD) pipeline executes only after these checks succeed, ensuring only verified artifacts are deployed to the Azure production environment.

This document records the security controls implemented throughout the project, the findings discovered during development, remediation actions taken, and any accepted risks together with their engineering justification.

## Security Objectives

The security objectives of MedStock Monitor are to:

- Detect vulnerabilities before deployment using automated security scanning.
- Prevent insecure Infrastructure as Code from reaching production.
- Ensure production container images are continuously scanned for known vulnerabilities.
- Protect secrets by storing credentials in GitHub Secrets instead of source control.
- Enforce secure deployment through GitHub Actions Continuous Integration and Continuous Deployment pipelines.
- Deploy application workloads to Microsoft Azure using least-privilege principles.
- Maintain a documented risk register for any accepted security exceptions.

## DevSecOps Pipeline

Security validation is integrated directly into the software delivery lifecycle.

Developer Commit
↓
Pull Request
↓
GitHub Actions CI

• ESLint
• Jest Tests
• npm audit
• Trivy Container Scan
• Checkov IaC Scan

↓
Merge to main

↓
GitHub Actions CD

• Build Production Image
• Push Image to Azure Container Registry (ACR)
• Connect to Azure Infrastructure
• Execute Ansible Playbook
• Pull Latest Image
• Restart Application
• Verify Deployment

↓
Production Environment (Microsoft Azure)

## Secrets Management

Sensitive credentials are never committed to the repository.

Production secrets are securely stored using GitHub Secrets and injected into GitHub Actions workflows at runtime.

Examples include:

- Azure Service Principal credentials
- Azure Subscription ID
- Azure Tenant ID
- Azure Container Registry credentials
- SSH private key for deployment
- Database connection credentials

No production secrets are stored in Git history or committed source files.