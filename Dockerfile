FROM ruby:3.3

# Install curl and gnupg2 first (needed for adding Node.js repo)
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends curl gnupg2

# Add NodeSource Node.js repo
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash -

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libpq-dev nodejs git

# Set working directory
WORKDIR /myapp

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the application code
COPY . .

# Expose port
EXPOSE 3000

# Start the Rails server
CMD ["rails", "server", "-b", "0.0.0.0"]