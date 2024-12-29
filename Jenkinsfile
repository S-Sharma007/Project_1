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
            steps {
                withSonarQubeEnv('sharmatech-key') { 
                    sh 'mvn org.sonarsource.scanner.maven:sonar-maven-plugin:3.11.0.3922:sonar ' +
                       '-Dsonar.projectKey=sharmatech-key_ttrend ' +
                       '-Dsonar.organization=sharmatech-key ' +
                       '-Dsonar.host.url=<sonarqubeServerURL>'
                }
            }
        }
    }
}
