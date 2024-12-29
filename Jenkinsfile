pipeline {
    agent {
        node {
            label 'maven'
        }
    }

    environment {
        PATH = "/opt/apache-maven-3.9.9/bin:$PATH"
    }

    stages {
        stage('Build') {
            steps {
                sh 'mvn clean deploy'
            }
        }
        stage('SonarQube Analysis') {
          environment {
            scannerHome = tool 'sonar-scanner'
          }
            steps {
                withSonarQubeEnv('sonar-scanner') {
                    sh "${scannerHome}/bin/sonar-scanner"
                }
            }
        }
    }
}
