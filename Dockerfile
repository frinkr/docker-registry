FROM registry:2

RUN mkdir -p /registry

ADD certs/domain.crt /registry/certs/domain.crt
ADD certs/domain.key /registry/certs/domain.key

ENV REGISTRY_HTTP_TLS_CERTIFICATE=/registry/certs/domain.crt
ENV REGISTRY_HTTP_TLS_KEY=/registry/certs/domain.key

EXPOSE 5000