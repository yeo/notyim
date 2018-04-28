FROM ruby:2.5.1

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
  rm -rf /var/cache/apt/* && \
  gem install --no-doc --no-ri bundler

# This is to make use of docker cache
COPY Gemfile Gemfile.lock .ruby-version  ./
RUN \
  bundle install --jobs 20 --retry 5

COPY . /app

# Asset
RUN \
    yarn install && \
    bundle exec rake assets:precompile

CMD ["puma", "-C", "config/puma.rb"]
