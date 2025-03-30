def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

def gitCommit = ''
def branchName = ''
def unixTime = ''
def developmentTag = ''

pipeline {
    agent {
        label 'mfeops-builder'
    }
    environment {
        DOCKER_CREDENTIALS = credentials('docker-builder')  // Jenkins DockerHub credentials
        BUILD_USER         = 'Jenkins'
        VERSION            = 'latest'
        // Setting on Jenkins App
        // SERVICE            = 'platform-app'
        // DOCKER_CREDENTIALS_USR
        // DOCKER_CREDENTIALS_PSW
    }
    stages {
        stage("Docker Build") {
            steps {
                script {
                    gitCommit = env.GIT_COMMIT.substring(0,8)
                    branchName = env.ENVIRONMENT
                    unixTime = (new Date().time / 1000) as Integer
                    developmentTag = "${branchName}-${gitCommit}-${unixTime}"
                }
                sh "docker build --file Dockerfile --network=host --tag docker.io/${DOCKER_USERNAME}/${SERVICE}:${developmentTag} ."
            }
        }
        stage("Docker Login") {
            steps {
               sh " echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin"
            }
        }
        stage("Docker Push") {
            steps {
               sh "docker push docker.io/${DOCKER_USERNAME}/${SERVICE}:${developmentTag}"
               sh "docker rmi docker.io/${DOCKER_USERNAME}/${SERVICE}:${developmentTag}"
            }
        }
    }
}