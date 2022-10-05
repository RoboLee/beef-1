FROM ruby:2.7.6-slim
LABEL maintainer "Ilya Glotov <contact@ilyaglotov.com>"

ARG COMMIT=6adad0911b2616e164960357f344be469d97c387

ENV LANG="C.UTF-8" \
    DEPS="build-essential \
          libsqlite3-dev \
          libcurl4-openssl-dev \
          wget"

RUN apt-get update \
  && apt-get install -y $DEPS \
                        sqlite3 \
                        nodejs \
  && useradd -m beef \
  && wget -q https://github.com/beefproject/beef/tarball/$COMMIT -O beef.tgz \
  && mkdir /home/beef/beef \
  && tar -xzf beef.tgz --strip 1 -C /home/beef/beef \
  && cd /home/beef/beef \
  && chown -R beef:beef /home/beef \
  && bundle install --without test development \
  \
  && rm -rf beef.tgz \
  && apt-get purge -y $DEPS \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/beef/beef

USER beef

EXPOSE 3000 6789 61985 61986

COPY entrypoint.sh /tmp/entrypoint.sh

ENTRYPOINT ["/tmp/entrypoint.sh"]
