FROM node:15.3

LABEL "version"="1.0.0"
LABEL "repository"="https://github.com/natac13/docusaurus-deploy-action"
LABEL "homepage"="https://github.com/natac13/docusaurus-deploy-action"
LABEL "maintainer"="Sean Campbell <sean.campbell13@gmail.com>"

EXPOSE 3000

RUN apt-get update && \
  apt-get install \
  curl \
  git

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  mkdir /website

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
