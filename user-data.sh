#!/bin/bash
HOST=`hostname`
cat > index.html <<EOF
<h1>Hello, World.</h1>
<p>Brought to you by Terraform Automation</p>
<p> Hosted on server $HOST</p>
EOF

nohup busybox httpd -f -p "80" &
