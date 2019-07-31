#!/bin/bash

cat > index.html <<EOF
<h1>Hello, World.</h1>
<p>Brought to you by Terraform Automation</p>
<p> Hosted on server $HOSTNAME</p>
EOF

nohup busybox httpd -f -p "80" &
