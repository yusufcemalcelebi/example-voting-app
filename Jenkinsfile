pipeline {
  agent {
    kubernetes {
      yaml """\
apiVersion: v1
kind: Pod
spec:
  volumes:
  - name: docker-socket
    emptyDir: {}
  containers:
  - name: jenkins-builder
    image: yusufcemalcelebi/jenkins-builder:latest
    command:
    - sleep
    args:
    - 99d
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run
  - name: docker-daemon
    image: docker:20.10.6-dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run
        """.stripIndent()
    }
  }
  stages {
    stage('Build and Push Voting Service Image') {
      steps {
        container('jenkins-builder') {
          sh '''#!/bin/bash -xe
          
          [ ! -d "example-voting-app" ] && git clone https://github.com/yusufcemalcelebi/example-voting-app && cd "example-voting-app"
          bash ./ci/builder.sh "vote" "${BUILD_NUMBER}"
          
          '''
        }
      }
    }
    stage('Build and Push Worker Service Image') {
      steps {
        container('jenkins-builder') {
          sh '''#!/bin/bash -xe
          
          [ ! -d "example-voting-app" ] && git clone https://github.com/yusufcemalcelebi/example-voting-app && cd "example-voting-app"
          bash ./ci/builder.sh "worker" "${BUILD_NUMBER}"
          
          '''
        }
      }
    }
    stage('Build and Push Result Service Image') {
      steps {
        container('jenkins-builder') {
          sh '''#!/bin/bash -xe
          
          [ ! -d "example-voting-app" ] && git clone https://github.com/yusufcemalcelebi/example-voting-app && cd "example-voting-app"
          bash ./ci/builder.sh "result" "${BUILD_NUMBER}"
          
          '''
        }
      }
    }
  }
}