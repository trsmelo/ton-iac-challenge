# ton-iac-challenge
Repository created for TON IaC Challenge.

The script do the Deployment of an AWS/EC2 Ubuntu Instance using Terraform with security configuration, monitoring, CW CPU alert, and install NGINX.

## Things to be improved:
- Installation of CloudWatchAgent to collect other types of metrics
- Finish the configuration of TLS on NGINX to respond on port 443 - is responding only on default port (80)
