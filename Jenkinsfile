pipeline {
    agent any

    tools{
        maven 'my-maven'
    }

    environment {
        APP_NAME = 'order-service03-app'
        DOCKER_TAG = 'latest'
        IMAGE_NAME = "lgdl23/${APP_NAME}:${DOCKER_TAG}"
        TARGET_HOST = '192.168.56.107'
        TARGET_USER = 'vagrant'
        PORT = '8081'
    }
    stages {
        stage('0. 자동화2 연결 확인') { steps { echo '스테이지 출발' } }

        stage('1. 자바빌드'){
            steps{
                echo '메이븐으로 빌드 시작'
                sh 'mvn clean package'
            }
        }
        stage('2. Check Docker') {
            steps {
                sh 'docker version'
            }
        }
        stage('3. Docker Build') {
            steps {
                sh 'docker build -t order-service03-app:latest .'
            }
        }
        stage('4. Docker Push') {
            steps {
                withCredentials([usernamePassword(
                        credentialsId: 'dockerhub-cred',
                        usernameVariable: 'DOCKERHUB_USERNAME',
                        passwordVariable: 'DOCKERHUB_PASSWORD'
                )]) {
                    sh '''
                    echo "$DOCKERHUB_PASSWORD" | docker login -u "$DOCKERHUB_USERNAME" --password-stdin
                    docker tag order-service03-app:latest $DOCKERHUB_USERNAME/order-service03-app:latest
                    docker push $DOCKERHUB_USERNAME/order-service03-app:latest
                    '''
                }
            }
        }
        stage('5. Deploy to vm7') {
            steps {
                sh '''
                    ssh -o StrictHostKeyChecking=no $TARGET_USER@$TARGET_HOST <<EOF
                        # 이미지 pull 실패 시 즉시 스크립트 종료
                        docker pull $IMAGE_NAME || exit 1
                        # 기존 컨테이너 제거, 없을 경우 에러 무시
                        docker rm -f $APP_NAME 2>/dev/null || true
                        docker run -d -p $PORT:$PORT --name $APP_NAME $IMAGE_NAME
EOF
                '''
            }
        }
    }
}