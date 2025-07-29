FROM ruby:3.1-alpine

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    git \
    nodejs \
    npm \
    tzdata

# Set working directory
WORKDIR /srv/jekyll

# Copy Gemfile and Gemfile.lock first for better caching
COPY Gemfile* ./

# Install Jekyll and dependencies
RUN gem install bundler jekyll && \
    bundle install

# Copy the entire Jekyll site into the container
COPY . .

RUN cp _config_dev.yml _config.yml

# Create a volume mount point for persistent data
VOLUME ["/srv/jekyll/_site", "/srv/jekyll/.jekyll-cache"]

# Expose port 4000
EXPOSE 4000

# Set default command
CMD ["bundle", "exec", "jekyll", "serve", "--host", "0.0.0.0", "--port", "4000", "--livereload"]
