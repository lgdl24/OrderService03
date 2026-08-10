pipeline {
    agent any

    tools {
        maven 'my-maven'
    }

    stages {

        stage('0. 자동화 연결 확인') {
            steps {
                echo 'Jenkins 자동화 연결 성공'
            }
        }

        stage('1. Java 빌드') {
            steps {
                echo 'Maven 빌드 시작'

                sh 'mvn clean package'

                echo 'Maven 빌드 완료'
            }
        }

        stage('2. 빌드 결과 확인') {
            steps {
                sh 'ls -lh target/'
            }
        }

        stage('3. Docker 권한 확인') {
            steps {
                sh '''
                    whoami
                    id
                    docker --version
                    docker ps
                '''
            }
        }

        stage('4. Docker 이미지 빌드') {
            steps {
                echo 'Docker 이미지 빌드 시작'

                sh '''
            docker build \
            -t lgdl23/order-service:latest \
            .
        '''

                echo 'Docker 이미지 빌드 완료'
            }
        }

        stage('5. Docker Hub 로그인 및 Push') {
            steps {
                withCredentials([
                        usernamePassword(
                                credentialsId: 'dockerhub',
                                usernameVariable: 'DOCKER_USERNAME',
                                passwordVariable: 'DOCKER_PASSWORD'
                        )
                ]) {
                    sh '''
                echo "$DOCKER_PASSWORD" | docker login \
                    -u "$DOCKER_USERNAME" \
                    --password-stdin

                docker push lgdl23/order-service:latest

                docker logout
            '''
                }
            }
        }

        stage('6. 기존 컨테이너 제거') {
            steps {
                sh '''
                    docker stop order-service || true
                    docker rm order-service || true
                '''
            }
        }

        stage('7. Docker 컨테이너 실행') {
            steps {
                echo 'Docker 컨테이너 실행'

                sh '''
            docker run -d \
            --name order-service \
            -p 8082:8080 \
            lgdl23/order-service:latest
        '''
            }
        }

        stage('8. 배포 확인') {
            steps {
                sh '''
                    docker ps
                    docker images | grep order-service
                '''
            }
        }
    }

    post {
        success {
            echo '======================================'
            echo '배포 성공!'
            echo 'Docker Hub Push 및 컨테이너 실행 완료'
            echo '======================================'
        }

        failure {
            echo '======================================'
            echo '배포 실패'
            echo 'Jenkins Console Output을 확인하세요.'
            echo '======================================'
        }
    }
}