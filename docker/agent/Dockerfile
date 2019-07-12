#
# Copyright (c) 2019 ForgeRock AS. Use of this source code is subject to the
# Common Development and Distribution License (CDDL) that can be found in the LICENSE file
#
FROM httpd:2.4

# Install unzip requred for upacking agent file
RUN apt-get update; \
    apt-get install unzip -y

# Enable HTTP2 protocol and proxy
RUN sed -i 's/#LoadModule http2/LoadModule http2/g' /usr/local/apache2/conf/httpd.conf; \
    sed -i 's/#LoadModule proxy_http2_module /LoadModule proxy_http2_module /g' /usr/local/apache2/conf/httpd.conf; \
    sed -i 's/#LoadModule proxy_module /LoadModule proxy_module /g' /usr/local/apache2/conf/httpd.conf; \
    sed -i 's/#LoadModule proxy_http_/LoadModule proxy_http_/g' /usr/local/apache2/conf/httpd.conf; \
    sed -i 's@Include conf/extra/proxy-html.conf@#Include conf/extra/proxy-html.conf@g' /usr/local/apache2/conf/httpd.conf; \
    sed -i '/Listen 80/a Protocols h2c h2 http/1.1' /usr/local/apache2/conf/httpd.conf; \
    sed -i '/# Configure mod_proxy/a ProxyPassReverse /agent/ http://pentest-app:80/web/' /usr/local/apache2/conf/httpd.conf; \
    sed -i '/# Configure mod_proxy/a ProxyPass /agent/ http://pentest-app:80/web/' /usr/local/apache2/conf/httpd.conf;

# Copy Agent file to image
COPY web-agent-5.6.1.0-Apache_v24_Linux_64bit.zip /opt/agent.zip

# Unzip agent file and delete it
RUN cd /opt; \
    unzip ./agent.zip; \
    rm -rf ./agent.zip

# Install the agent
RUN echo "FRp@ssw0rd89!" > /opt/pwd; \
    /opt/web_agents/apache24_agent/bin/agentadmin --s \
    "/usr/local/apache2/conf/httpd.conf" \
    "https://default.pentest.forgeops.com:443/am" \
    "http://agent:80" \
    "/" \
    "agent-profile" \
    "/opt/pwd" \
    --changeOwner --acceptLicence --forceInstall; \
    rm -rf /opt/pwd

USER root
