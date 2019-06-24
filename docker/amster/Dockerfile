FROM gcr.io/forgerock-io/amster:6.5.2

ENV SERVER_URI /am

# We replace some of the entry point scripts with others need for skaffold.
COPY  --chown=forgerock . /opt/amster
