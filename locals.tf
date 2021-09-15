locals {

  # Common tags to be assigned to all resources
  common_tags = {
    application = "Prisma Cloud Compute Sandbox VM"
  }


    user_data = <<EOF
#!/bin/bash
apt-get update && \
apt-get -y upgrade && \
apt-get -y install apt-transport-https ca-certificates curl gnupg lsb-release jq openjdk-11-jdk && \
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" && \
apt-get update && \
apt-get install docker-ce docker-ce-cli containerd.io -y && \
usermod -aG docker ${var.adminUsername} && \
curl -s -k -u ${var.console_username}:${var.console_password} --output /usr/local/bin/twistcli https://${var.console_url}/api/v1/util/twistcli && \
chmod +x /usr/local/bin/twistcli && \
echo "done"
EOF

}
