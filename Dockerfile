# Use latest official ruby image as base
FROM ruby:2.2

# Create app source directory
RUN mkdir -p /app/bin

# Use app dir as current dir
WORKDIR /app

# Add app bin-dir to PATH
ENV PATH /app/bin:$PATH

# Add gemfile and install gems
# for docker build speed improvements
ADD Gemfile /app/
ADD Gemfile.lock /app/
RUN bundle install --deployment

# Add remaining app source
ADD . /app
