pipeline {
  agent {
    kubernetes {
      yaml """\
apiVersion: v1
kind: Pod
spec:
  serviceAccountName: jenkins-agent
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
    stage('Git clone') {
        steps {
            container('jenkins-builder') {
            sh '''#!/bin/bash -xe
            git clone https://github.com/yusufcemalcelebi/example-voting-app
            '''
            }
        }
    }
    stage('Build and Deploy apps') {
      parallel {
        stage('Voting') {
            steps {
                container('jenkins-builder') {
                sh '''#!/bin/bash -xe
            
                cd "example-voting-app"
                bash ./ci/builder.sh "vote" "${BUILD_NUMBER}"
                bash ./cd/deployer.sh "vote" "${BUILD_NUMBER}"
                '''
                }
            }
        }
        stage('Worker') {
            steps {
                container('jenkins-builder') {
                sh '''#!/bin/bash -xe
            
                cd "example-voting-app"
                bash ./ci/builder.sh "worker" "${BUILD_NUMBER}"
                bash ./cd/deployer.sh "worker" "${BUILD_NUMBER}" false false
                '''
                }
            }
        }
        stage('Result') {
            steps {
                container('jenkins-builder') {
                sh '''#!/bin/bash -xe
            
                cd "example-voting-app"
                bash ./ci/builder.sh "result" "${BUILD_NUMBER}"
                bash ./cd/deployer.sh "result" "${BUILD_NUMBER}"
                '''
                }
            }
        }
        stage('DB and Redis') {
            steps {
                container('jenkins-builder') {
                sh '''#!/bin/bash -xe
            
                cd "example-voting-app"
                kubectl apply -f ./cd/db-redis.yaml
                '''
                }
            }
        }
      }
    }
  }
}