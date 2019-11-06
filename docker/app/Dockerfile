FROM ruby:2.3.0-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git build-essential libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/sockets

WORKDIR /usr/src
COPY Gemfile* ./
RUN bundle install
COPY . .

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
