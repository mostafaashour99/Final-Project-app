pipeline {
  agent {
    kubernetes {
      yaml '''
apiVersion: v1
kind: Pod
metadata:
  name: buildah
spec:
  containers:
  - name: buildah
    image: quay.io/buildah/stable:v1.23.1
    command:
    - cat
    tty: true
    securityContext:
      privileged: true
    volumeMounts:
      - name: varlibcontainers
        mountPath: /var/lib/containers
  volumes:
    - name: varlibcontainers
'''   
    }
  }
  options {
    buildDiscarder(logRotator(numToKeepStr: '10'))
    durabilityHint('PERFORMANCE_OPTIMIZED')
    disableConcurrentBuilds()
  }
  environment {
    DH_CREDS=credentials('dockerhub_auth')
  }
  stages {
    stage('Build with Buildah') {
      steps {
        container('buildah') {
          sh 'buildah build -t mostafaashour99/py-app:latest .'
        }
      }
    }
    stage('Login to Docker Hub') {
      steps {
        container('buildah') {
          sh 'echo $DH_CREDS_PSW | buildah login -u $DH_CREDS_USR --password-stdin docker.io'
        }
      }
    }
    stage('push image') {
      steps {
        container('buildah') {
          sh 'buildah push mostafaashour99/py-app:latest'
         
        }
      }
    }
  }
  post {
    always {
      container('buildah') {
        sh 'buildah logout docker.io'
      }
    }
  }
}
