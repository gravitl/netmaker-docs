#!/bin/bash


sed -i '/rel=\"next\"\ title=\"About\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/\"\ />' /usr/share/nginx/html/index.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/server-installation.html\"\ />' /usr/share/nginx/html/server-installation.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/license.html\"\ />' /usr/share/nginx/html/license.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/ee/ee-metrics.html\"\ />' /usr/share/nginx/html/ee/ee-metrics.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/ee/ee-setup.html\"\ />' /usr/share/nginx/html/ee/ee-setup.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/ee/ee-users.html\"\ />' /usr/share/nginx/html/ee/ee-users.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/ee/index.html\"\ />' /usr/share/nginx/html/ee/index.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/about.html\"\ />' /usr/share/nginx/html/about.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/acls.html\"\ />' /usr/share/nginx/html/acls.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/api.html\"\ />' /usr/share/nginx/html/api.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/conduct.html\"\ />' /usr/share/nginx/html/conduct.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/architecture.html\"\ />' /usr/share/nginx/html/architecture.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/troubleshoot.html\"\ />' /usr/share/nginx/html/troubleshoot.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/nmctl.html\"\ />' /usr/share/nginx/html/nmctl.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/usage.html\"\ />' /usr/share/nginx/html/usage.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/external-clients.html\"\ />' /usr/share/nginx/html/external-clients.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/egress-gateway.html\"\ />' /usr/share/nginx/html/egress-gateway.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/netclient.html\"\ />' /usr/share/nginx/html/netclient.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/quick-start.html\"\ />' /usr/share/nginx/html/quick-start.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/support.html\"\ />' /usr/share/nginx/html/support.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/upgrades.html\"\ />' /usr/share/nginx/html/upgrades.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/getting-started.html\"\ />' /usr/share/nginx/html/getting-started.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/advanced-client-install.html\"\ />' /usr/share/nginx/html/advanced-client-install.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/install.html\"\ />' /usr/share/nginx/html/install.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/oauth.html\"\ />' /usr/share/nginx/html/oauth.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/ee/ee-relay-server.html\"\ />' /usr/share/nginx/html/ee/ee-relay-server.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/turn-server.html\"\ />' /usr/share/nginx/html/turn-server.html

sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/ui-reference.html\"\ />' /usr/share/nginx/html/ui-reference.html

pushd /usr/share/nginx/html/
find . -type f -name "*.html" -exec sed -i 's#</head>#<script async src="https://tag.clearbitscripts.com/v1/pk_2bb9a293aa7aab18e57c428ac8502408/tags.js" referrerpolicy="strict-origin-when-cross-origin"></script>\n</head>#' {} +
popd