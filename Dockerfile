FROM ruby:2.2
MAINTAINER Peter Esselius

# Create app source directory
RUN mkdir /app

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
