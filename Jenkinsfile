pipeline {
    agent none

    options {
        disableConcurrentBuilds()
    }

    environment {
        REGISTRY       = 'repo.fiberathome.cloud'
        HARBOR_PROJECT = 'devops-automation'
        IMAGE_NAME     = 'devops-demo-app'
    }

    stages {

        stage('CI') {
            agent {
                label 'built-in'
            }

            stages {

                stage('Checkout') {
                    steps {
                        checkout scm

                        script {
                            env.SHORT_COMMIT = sh(
                                script: 'git rev-parse --short HEAD',
                                returnStdout: true
                            ).trim()

                            env.IMAGE_TAG = "${env.BUILD_NUMBER}-${env.SHORT_COMMIT}"

                            env.IMAGE_REF = "${env.REGISTRY}/${env.HARBOR_PROJECT}/${env.IMAGE_NAME}:${env.IMAGE_TAG}"
                        }

                        echo "Building image: ${IMAGE_REF}"
                    }
                }

                stage('Unit Test') {
                    steps {
                        sh '''
                            docker build \
                              -f app/Dockerfile.test \
                              -t devops-demo-app-test:${BUILD_NUMBER} \
                              app

                            docker run --rm \
                              devops-demo-app-test:${BUILD_NUMBER}
                        '''
                    }
                }

                stage('Build Image') {
                    steps {
                        sh '''
                            docker build \
                              -t "${IMAGE_REF}" \
                              app
                        '''
                    }
                }

                stage('Trivy Report') {
                    steps {
                        sh '''
                            trivy image \
                              --severity HIGH,CRITICAL \
                              --exit-code 0 \
                              "${IMAGE_REF}"
                        '''
                    }
                }

                stage('Security Gate') {
                    steps {
                        sh '''
                            trivy image \
                              --severity CRITICAL \
                              --ignore-unfixed \
                              --exit-code 1 \
                              "${IMAGE_REF}"
                        '''
                    }
                }

                stage('Push to Harbor') {
                    steps {
                        withCredentials([
                            usernamePassword(
                                credentialsId: 'harbor-credentials',
                                usernameVariable: 'HARBOR_USER',
                                passwordVariable: 'HARBOR_PASS'
                            )
                        ]) {
                            sh '''
                                echo "$HARBOR_PASS" | \
                                  docker login "$REGISTRY" \
                                  --username "$HARBOR_USER" \
                                  --password-stdin

                                docker push "${IMAGE_REF}"

                                docker logout "$REGISTRY"
                            '''
                        }
                    }
                }

                stage('Prepare Deployment') {
                    steps {
                        stash(
                            name: 'kubernetes-manifests',
                            includes: 'kubernetes/**'
                        )
                    }
                }
            }
        }

        stage('Deploy to Kubernetes') {
            agent {
                label 'k8s-deployer'
            }

            steps {
                deleteDir()

                unstash 'kubernetes-manifests'

                sh '''
                    kubectl apply \
                      -f kubernetes/service.yaml

                    sed "s|image: .*|image: ${IMAGE_REF}|" \
                      kubernetes/deployment.yaml | \
                      kubectl apply -f -

                    kubectl -n devops-automation \
                      set env deployment/devops-demo-app \
                      APP_VERSION="${IMAGE_TAG}"

                    kubectl -n devops-automation \
                      rollout status deployment/devops-demo-app \
                      --timeout=180s
                '''
            }
        }
    }
}
