#######################################################################
#                              Base Node                              #
#######################################################################
FROM gradle:jdk8-alpine as base

#######################################################################
#                            Dependencies                             #
#######################################################################
FROM base AS dependencies

# Create the build directory and set the permissions
# properly so that Gradle can actually generate the
# build output without crashing.
USER root
RUN apk add --no-cache curl tar bash procps
ENV HOME /home/gradle
ENV GRADLE_USER_HOME="${HOME}/.gradle"

# Go back to the Gradle user, copy the build scripts in and
# resolve all necessary dependencies.
# This is done separately so editing the source code doesn't
# cause the dependencies to be redownloaded.
USER gradle
WORKDIR ${HOME}
RUN mkdir -p "${HOME}/output"
RUN mkdir -p "${HOME}/.gradle"
RUN mkdir -p "${HOME}/.cache"

COPY --chown=gradle:gradle config/ "${HOME}"/config
COPY --chown=gradle:gradle src/ "${HOME}/src"
COPY --chown=gradle:gradle lib/ "${HOME}/lib"
COPY --chown=gradle:gradle *.gradle ${HOME}/
# COPY --chown=gradle:gradle gradle.* ${HOME}/
# COPY --chown=gradle:gradle gradle/ ${HOME}/gradle
RUN chown -R gradle:gradle "${HOME}"
RUN chmod -R 0776 "${HOME}"

#######################################################################
#                                Test                                 #
#######################################################################
FROM dependencies AS test
# Copy the source code in and build it
# TODO(grant): this seems to duplicate downloads that the
# install already does
#RUN gradle bundleWithDependencies integrationTest --stacktrace --no-daemon
RUN gradle test

ENTRYPOINT ["gradle"]
CMD ["run"]
