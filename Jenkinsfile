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
    PROJECT_ID = 'mostafa-ashour-project'
                CLUSTER_NAME = 'primary'
                LOCATION = 'us-central1-a'
                CREDENTIALS_ID = 'kubernetes'	
  }
  stages {
    stage('Build with Buildah') {
      steps {
        container('buildah') {
          sh 'buildah build -t mostafaashour99/py-app:${env.BUILD_ID} .'
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
          sh 'buildah push mostafaashour99/py-app:${env.BUILD_ID}'
         
        }
      }
    }
    stage('Deploy to K8s') {
            steps{
                echo "Deployment started ..."
                sh "cd ./k8s/app"
                sh 'ls -ltr'
                sh 'pwd'
                sh "sed -i 's/pipeline:latest/py-app:${env.BUILD_ID}:${env.BUILD_ID}/g' python-deploy.yaml"
                step([$class: 'KubernetesEngineBuilder', \
                  projectId: env.PROJECT_ID, \
                  clusterName: env.CLUSTER_NAME, \
                  location: env.LOCATION, \
                  manifestPattern: 'python-deploy.yaml', \
                  credentialsId: env.CREDENTIALS_ID, \
                  verifyDeployments: true])
                }
            }
         
  }
  post {
    always {
      container('buildah') {
        sh 'buildah logout docker.io'
      }
    }
    success {
        		slackSend color: "#439FE0" , message:"Build deployed successfully - ${env.JOB_NAME} ${env.BUILD_NUMBER}"
        	}
        	failure {
     		   slackSend failOnError:true , message:"Build failed  - ${env.JOB_NAME} ${env.BUILD_NUMBER} "
    		}
  }
}
