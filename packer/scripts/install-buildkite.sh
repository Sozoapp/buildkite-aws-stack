#!/bin/bash -eu

cat << EOF | sudo tee -a  /etc/yum.repos.d/buildkite-agent.repo
[buildkite-agent]
name = Buildkite Pty Ltd
baseurl = https://yum.buildkite.com/buildkite-agent/stable/x86_64/
enabled=1
gpgcheck=0
priority=1
EOF

sudo yum -y -q install buildkite-agent
sudo usermod -a -G docker buildkite-agent

# Allow buildkite to fix checkout permissions
sudo cp /tmp/conf/buildkite-sudoers.conf /etc/sudoers.d/buildkite
sudo chmod 440 /etc/sudoers.d/buildkite
sudo mv /tmp/conf/scripts/fix-checkout-permissions /usr/bin/

# move custom hooks into place
chmod +x /tmp/conf/hooks/*
sudo cp -a /tmp/conf/hooks/* /etc/buildkite-agent/hooks
sudo chown -R buildkite-agent: /etc/buildkite-agent/hooks