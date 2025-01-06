def registry = 'https://sharma13.jfrog.io'
def repoName = 'valaxy-docker'
def imageName = "${valaxy-docker}/ttrend"
def version = '2.1.4'

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

        stage('Jar Publish') {
            steps {
                script {
                    echo '<--------------- Jar Publish Started --------------->'

                    // Define registry and credentials
                    def server = Artifactory.newServer(
                        url: "${registry}/artifactory",
                        credentialsId: "Jforgjenkins-cred"
                    )

                    // Define properties and upload specifications
                    def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}"
                    def uploadSpec = """{
                        "files": [
                            {
                                "pattern": "jarstaging/(*)",
                                "target": "jsmaven-libs-release-local/{1}",
                                "flat": false,
                                "props": "${properties}",
                                "exclusions": [ "*.sha1", "*.md5" ]
                            }
                        ]
                    }"""

                    // Upload artifacts and publish build info
                    def buildInfo = server.upload(uploadSpec)
                    buildInfo.env.collect()
                    server.publishBuildInfo(buildInfo)

                    echo '<--------------- Jar Publish Ended --------------->'
                }
            }
        }

        stage('Docker Build') {
            steps {
                script {
                    echo '<--------------- Docker Build Started --------------->'
                    app = docker.build("${imageName}:${version}")
                    echo '<--------------- Docker Build Ended --------------->'
                }
            }
        }

        stage('Docker Publish') {
            steps {
                script {
                    echo '<--------------- Docker Publish Started --------------->'
                    docker.withRegistry("${registry}/artifactory", 'Jforgjenkins-cred') {
                        app.push("${version}")
                    }
                    echo '<--------------- Docker Publish Ended --------------->'
                }
            }
        }
    }
}


