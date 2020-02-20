
FROM ruby:latest

# --->
# ---> install the gems necessary to build test package and
# ---> release this ruby project.
# --->

RUN gem install gem-release cucumber aruba yard reek
