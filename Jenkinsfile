pipeline {
    agent any


    tools{
        maven 'my-maven'
    }
    stages{
        stage('0. 자동화 연결확인'){
            steps {
                echo '스테이지 출발'
                }
        }
        stage('1. 자바 빌드'){
            steps {
                echo '스테이지 출발'
                sh 'mvn clean package'
            }
        }
    }
}
