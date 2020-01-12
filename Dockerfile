FROM ruby:2.6.3

RUN apt-get update && apt-get install -y curl gnupg

RUN apt-get -y update && \
      apt-get install --fix-missing --no-install-recommends -qq -y \
        build-essential \
        vim \
        wget gnupg \
        git-all \
        curl \
        ssh \
        sqlite3 libsqlite3-dev libpq5 libpq-dev -y && \
      wget -qO- https://deb.nodesource.com/setup_9.x  | bash - && \
      apt-get install -y nodejs && \
      wget -qO- https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
      echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
      apt-get update && \
      apt-get install yarn && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /onebitmessenger

WORKDIR /onebitmessenger

COPY Gemfile /onebitmessenger/Gemfile

COPY Gemfile.lock /onebitmessenger/Gemfile.lock

RUN bundle install

RUN yarn install --check-files

COPY . /onebitmessenger

RUN chown -R 1000:1000 /onebitmessenger

EXPOSE 3000

