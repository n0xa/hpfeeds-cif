FROM ubuntu:24.04

LABEL maintainer="n0xa"
LABEL name="hpfeeds-cif"
LABEL version="2.1.0"
LABEL release="1"
LABEL summary="HPFeeds CIFv3 handler"
LABEL description="HPFeeds CIFv3 handler is a tool for generating CIFv3 submissions for honeypot events."
LABEL authoritative-source-url="https://github.com/n0xa/hpfeeds-cif"
LABEL changelog-url="https://github.com/n0xa/hpfeeds-cif/commits/master"

ENV DEBIAN_FRONTEND "noninteractive"

# hadolint ignore=DL3008,DL3005
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install --no-install-recommends -y gcc git python3-dev python3-pip python3-venv build-essential libffi-dev libssl-dev \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Create virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY requirements.txt /opt/requirements.txt
RUN pip install --upgrade pip setuptools wheel \
  && pip install --upgrade -r /opt/requirements.txt \
  && pip install git+https://github.com/n0xa/hpfeeds3.git

COPY . /opt/
RUN chmod 0755 /opt/entrypoint.sh

ENTRYPOINT ["/opt/entrypoint.sh"]
