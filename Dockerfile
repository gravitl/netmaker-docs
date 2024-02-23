FROM sphinxdoc/sphinx:latest as builder
WORKDIR /netmaker-docs
COPY . /netmaker-docs/
RUN pip install sphinx_material

RUN ["make","html"]
RUN ["/bin/ls"]

FROM nginx:1.19
COPY --from=builder /netmaker-docs/_build/html /usr/share/nginx/html
RUN sed -i '/rel=\"next\"\ title=\"About\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/\"\ />' /usr/share/nginx/html/index.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/server-installation.html\"\ />' /usr/share/nginx/html/server-installation.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/license.html\"\ />' /usr/share/nginx/html/license.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/pro/pro-metrics.html\"\ />' /usr/share/nginx/html/pro/pro-metrics.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/pro/pro-setup.html\"\ />' /usr/share/nginx/html/pro/pro-setup.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/pro/pro-users.html\"\ />' /usr/share/nginx/html/pro/pro-users.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/pro/index.html\"\ />' /usr/share/nginx/html/pro/index.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/about.html\"\ />' /usr/share/nginx/html/about.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/acls.html\"\ />' /usr/share/nginx/html/acls.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/api.html\"\ />' /usr/share/nginx/html/api.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/conduct.html\"\ />' /usr/share/nginx/html/conduct.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/architecture.html\"\ />' /usr/share/nginx/html/architecture.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/troubleshoot.html\"\ />' /usr/share/nginx/html/troubleshoot.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/nmctl.html\"\ />' /usr/share/nginx/html/nmctl.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/usage.html\"\ />' /usr/share/nginx/html/usage.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/external-clients.html\"\ />' /usr/share/nginx/html/external-clients.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/egress-gateway.html\"\ />' /usr/share/nginx/html/egress-gateway.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/netclient.html\"\ />' /usr/share/nginx/html/netclient.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/quick-start.html\"\ />' /usr/share/nginx/html/quick-start.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/support.html\"\ />' /usr/share/nginx/html/support.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/upgrades.html\"\ />' /usr/share/nginx/html/upgrades.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/getting-started.html\"\ />' /usr/share/nginx/html/getting-started.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/advanced-client-install.html\"\ />' /usr/share/nginx/html/advanced-client-install.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/install.html\"\ />' /usr/share/nginx/html/install.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/oauth.html\"\ />' /usr/share/nginx/html/oauth.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/pro/pro-relay-server.html\"\ />' /usr/share/nginx/html/pro/pro-relay-server.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/ui-reference.html\"\ />' /usr/share/nginx/html/ui-reference.html

RUN sed -i '/link rel=\"prev\"/a \ \ \ \ <link rel=\"canonical\"\ href=\"https://docs.netmaker.io/integrating-non-native-devices.html\"\ />' /usr/share/nginx/html/integrating-non-native-devices.html