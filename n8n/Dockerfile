FROM python:3.13-alpine3.22 AS python

FROM n8nio/n8n:2.16.1
USER root
COPY --from=python /usr/local /usr/local
USER node
