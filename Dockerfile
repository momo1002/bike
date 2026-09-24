FROM ruby:3.2.3

RUN apt-get update -qq && \
    apt-get install -y build-essential libpq-dev nodejs yarn

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

# entrypoint スクリプトに実行権限を付与
RUN chmod +x /app/bin/docker-entrypoint

# 起動時に必ず bin/docker-entrypoint を通過させる
ENTRYPOINT ["/app/bin/docker-entrypoint"]

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]