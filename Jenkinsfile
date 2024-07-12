pipeline {
    agent {
        label 'master'
    }

    options { 
        skipDefaultCheckout() 
    }

    environment {
        DOCKER_TAG_IMAGE = 'serhiiartiukh5465/docker_ssh'
        USER_NAME = 'ubuntu'
        USER_ID = 1000
        USER_PASS = 'pass'
        SSH_PORT = 32450
    }

    stages{
        stage('Checkout'){
            steps{
                git branch: 'main', 
                credentialsId: 'github_repo_cred', 
                poll: false, 
                url: 'git@github.com:Serhii5465/docker_ssh.git'
            }
        }

        stage('Build image'){
            steps{
                script{
                    sh returnStatus: true, 
                    script: "docker build . -t ${env.DOCKER_TAG_IMAGE} --build-arg USER_PASS=${env.USER_PASS} \
                                    --build-arg SSH_PORT=${env.SSH_PORT}  --build-arg USER_NAME=${env.USER_NAME} \
                                    --build-arg USER_ID=${env.USER_ID}"
                    
                }
            }
        }

        stage('Push to DockerHub'){
            steps{
                script{
                    withDockerRegistry(credentialsId: 'dockerhub-token') {
                        sh returnStatus: true,
                        script: "docker push ${env.DOCKER_TAG_IMAGE}"
                    }
                }
            }
        }

        // stage('Deploy on Kubernetes'){
        //     steps{
        //         script {

        //         }
        //     }
        // }
    }
}