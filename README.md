# Travis GCP Deploy Script

This script is used by [Travis CI](https://travis-ci.com/) to continuously deploy artifacts to a GCP bucket.

When Travis builds a push to your project (not a pull request), any files matching `target/*.{war,jar,zip}` will be uploaded to your GCP bucket with the prefix `builds/$DEPLOY_BUCKET_PREFIX/deploy/$BRANCH/$BUILD_NUMBER/`. Pull requests will upload the same files with a prefix of `builds/$DEPLOY_BUCKET_PREFIX/pull-request/$PULL_REQUEST_NUMBER/`.

For example, the 36th push to the `master` branch will result in the following files being created in your `exampleco-ops` bucket:

```
builds/exampleco/deploy/master/36/exampleco-1.0-SNAPSHOT.war
builds/exampleco/deploy/master/36/exampleco-1.0-SNAPSHOT.zip
```

When the 15th pull request is created, the following files will be uploaded into your bucket:
```
builds/exampleco/pull-request/15/exampleco-1.0-SNAPSHOT.war
builds/exampleco/pull-request/15/exampleco-1.0-SNAPSHOT.zip
```

## build.rb

The included build script (inspired by
[travis-maven-deploy](https://github.com/perfectsense/travis-maven-deploy)'s
brightspot-deploy.rb) takes advantage of Travis's .m2 cache to skip building
artifacts that have not changed. It only works if your project follows the
multi-module conventions as established in Brightspot's express-archetype. Minor
deviations are possible via command line parameters.

To speed up pull request builds even further, use the parameter `--skip-tests-if-pr`.

## Usage

Your .travis.yml should look something like this:

```yaml
language: java

jdk:
  - openjdk8

install: true

branches:
  only:
    - develop
    - master
    - /^release-.*$/

# MAVEN PROJECTS ONLY:
cache:
  directories:
    - $HOME/.m2
    - node
    - node_modules

before_script:
  - git clone https://github.com/perfectsense/travis-gcp-deploy.git

script:
  - ./travis-gcp-deploy/build-gradle.sh
  - ./travis-gcp-deploy/deploy.sh
```

Generate a [GCP Service account](https://developers.google.com/identity/protocols/oauth2/service-account)
Encrypt with openssl des3 with a strong password and save to your project in /etc/travis/travis-gcp-deploy.json.des3
Ex : `openssl des3 -in credentials.json -out travis-gcp-deploy.json.des3`

In travis set DEPLOY_BUCKET and GCP_CREDENTIALS environmental variables
GCP_CREDENTIALS is the encryption password for the GCP Service Account credentials

