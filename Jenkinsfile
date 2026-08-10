pipeline {
    agent any

    tools {
        maven 'my-maven'
    }

    stages {

        stage('0. 자동화 연결확인') {
            steps {
                echo '스테이지 출발'
            }
        }

        stage('1. 자바 빌드') {
            steps {
                echo 'Maven 빌드 시작'
                sh 'mvn clean package'
            }
        }
        stage('Docker 권한 확인') {
            steps {
                sh '''
            whoami
            id
            groups
            ls -l /var/run/docker.sock
            docker ps
        '''
            }
        }

        stage('2. Docker 이미지 빌드') {
            steps {
                echo 'Docker 이미지 빌드 시작'
                sh 'docker build -t order-service:latest .'
            }
        }

        stage('3. 기존 컨테이너 제거') {
            steps {
                sh '''
                    docker stop order-service || true
                    docker rm order-service || true
                '''
            }
        }

        stage('4. Docker 컨테이너 실행') {
            steps {
                echo 'Docker 컨테이너 실행'
                sh '''
                    docker run -d \
                    --name order-service \
                    -p 8080:8080 \
                    order-service:latest
                '''
            }
        }
    }
}