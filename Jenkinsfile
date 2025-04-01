def COLOR_MAP = [
    'SUCCESS': 'good',
    'FAILURE': 'danger',
]

def gitCommit = ''
def branchName = ''
def unixTime = ''
def developmentTag = ''

pipeline {
    agent any
    environment {
        DOCKER_CREDENTIALS = credentials('docker-builder')  // Jenkins DockerHub credentials
        BUILD_USER         = 'Jenkins'
        VERSION            = 'latest'
        SERVICE            = 'platform-app'  // Định nghĩa SERVICE ở đây nếu không có trên Jenkins
    }
    stages {
        stage("Prepare Build Info") {
            steps {
                script {
                    gitCommit = env.GIT_COMMIT?.substring(0, 8) ?: 'unknown'
                    branchName = env.ENVIRONMENT 
                    unixTime = (new Date().time / 1000) as Integer
                    developmentTag = "${branchName}-${gitCommit}-${unixTime}"
                }
            }
        }
        stage("Docker Build") {
            steps {
                script {
                    sh """
                    docker build --file Dockerfile --network=host \
                        --tag docker.io/${DOCKER_CREDENTIALS_USR}/${SERVICE}:${developmentTag} .
                    """
                }
            }
        }
        stage("Docker Login") {
            steps {
                script {
                    sh "echo ${DOCKER_CREDENTIALS_PSW} | docker login -u ${DOCKER_CREDENTIALS_USR} --password-stdin"
                }
            }
        }
        stage("Docker Push") {
            steps {
                script {
                    sh """
                    docker push docker.io/${DOCKER_CREDENTIALS_USR}/${SERVICE}:${developmentTag} || exit 1
                    docker rmi docker.io/${DOCKER_CREDENTIALS_USR}/${SERVICE}:${developmentTag}
                    """
                }
            }
        }
    }
}