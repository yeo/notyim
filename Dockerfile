FROM ruby:2.6.2 as build

ARG RAILS_ENV 
ENV LANG=C.UTF-8 \
  GEM_HOME=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH


WORKDIR /app
EXPOSE 3000

RUN \
  curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
  apt remove -y cmdtest && \
  apt-get update -qq && \
  apt-get install -y build-essential nodejs yarn && \
  rm -rf /var/cache/apt/* && \
  gem install bundler && \
  mkdir ~/.ssh && \
  ssh-keyscan github.com >> ~/.ssh/known_hosts

# This is to make use of docker cache
COPY Gemfile Gemfile.lock .ruby-version  ./
RUN \
  bundle install --jobs 20 --retry 5

COPY . /app

# Asset
RUN \
    yarn install && \
    bundle exec rake assets:precompile && \
    bundle exec rake webpacker:compile

RUN mkdir -p /app/tmp/pids /app/tmp/sockets

# NGINX  DOCKER IMAGE
# Our primary nginx image in front-of Rails app with puma
FROM nginx as web

# Install dependencies
RUN apt-get update -qq && apt-get -y install apache2-utils

# copy over static assetss
COPY --from=build /app/public/ /app/public
COPY app/scripts/docker/nginx.conf /etc/nginx/conf.d/noty.conf

# Use the "exec" form of CMD so Nginx shuts down gracefully on SIGTERM (i.e. `docker stop`)
CMD [ "nginx", "-g", "daemon off;" ]


# Final image
FROM build as app

ENV RAILS_ENV production

CMD ["puma", "-C", "config/puma.rb"]


# PRIMARY APP DOCKER IMAGE
# Our primary Rails app image
FROM build as app

EXPOSE 3000
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
