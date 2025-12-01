#!/bin/bash
set -e

# Update system
apt-get update -y

# Install dependencies
apt-get install -y wget curl

# Install CloudWatch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i -E ./amazon-cloudwatch-agent.deb || apt-get install -f -y

# Install NGINX (if not already installed)
apt-get install -y nginx

# Ensure NGINX access log exists and has correct permissions
mkdir -p /var/log/nginx
touch /var/log/nginx/access.log
chmod 644 /var/log/nginx/access.log

# Create CloudWatch Agent configuration directory
mkdir -p /opt/aws/amazon-cloudwatch-agent/etc

# Create CloudWatch Agent configuration JSON
cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<EOF
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "cwagent"
  },
  "metrics": {
    "namespace": "CWAgent",
    "metrics_collected": {
      "mem": {
        "measurement": [
          {
            "name": "mem_used_percent",
            "rename": "MemoryUtilization",
            "unit": "Percent"
          }
        ],
        "metrics_collection_interval": 60
      }
    }
  },
  "logs": {
    "logs_collected": {
      "files": {
        "collect_list": [
          {
            "file_path": "/var/log/nginx/access.log",
            "log_group_name": "${log_group_name}",
            "log_stream_name": "${instance_name}",
            "retention_in_days": 7
          }
        ]
      }
    }
  }
}
EOF

# Start CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
  -a fetch-config -m ec2 \
  -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
  -s

# Enable CloudWatch Agent to start on boot
systemctl enable amazon-cloudwatch-agent
systemctl start amazon-cloudwatch-agent

