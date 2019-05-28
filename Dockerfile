FROM ruby:2.6.2 as build

ENV LANG C.UTF-8

WORKDIR /app
EXPOSE 3000

RUN \
  curl -sL https://deb.nodesource.com/setup_9.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  apt remove -y cmdtest && \
  apt-get update -qq && \
  apt-get install -y build-essential nodejs yarn && \
  mkdir -p /root && \
  rm -rf /var/cache/apt/* && \
  gem install bundler && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts


# This is to make use of docker cache
COPY Gemfile Gemfile.lock .ruby-version  ./
RUN \
  bundle install --jobs 20 --retry 5

COPY . /app

# Asset
RUN \
    yarn install && \
    bundle exec rake assets:precompile


# Final image
FROM build

WORKDIR /app
EXPOSE 300

CMD ["puma", "-C", "config/puma.rb"]
