pipeline {
    agent any
    parameters {
         string(name: 'tomcat_dev', defaultValue: '35.166.210.154', description: 'Staging Server')
         string(name: 'tomcat_prod', defaultValue: '34.209.233.6', description: 'Production Server')
    }

    triggers {
         pollSCM('* * * * *')
    }

stages{
        stage('Build'){
            steps {
                sh 'mvn clean package'
            }
            post {
                success {
                    echo 'Now Archiving...'
                    archiveArtifacts artifacts: '**/target/*.war'
                }
            }
        }
		stage("Testing") {
			parallel {
				stage("Unit Tests") {
					agent { docker 'openjdk:7-jdk-alpine' }
					steps {
						sh 'java -version'
					}
				}
				stage("Functional Tests") {
					agent { docker 'openjdk:8-jdk-alpine' }
					steps {
						sh 'java -version'
					}
				}
				stage("Integration Tests") {
					steps {
						sh 'java -version'
					}
				}
			}
		}
        stage ('Deployments'){
            parallel{
                stage ('Deploy to Staging'){
                    steps {
                        //sh "scp -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat7/webapps"
                        sh "sudo cp **/target/*.war /var/lib/tomcat8/webapps"
                    }
                }

                stage ("Deploy to Production"){
                    steps {
                        //sh "scp -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_prod}:/var/lib/tomcat7/webapps"
                        sh "sudo cp **/target/*.war /var/lib/tomcat8/webapps"
                    }
                }
            }
        }
        stage ('Black Box Test'){
            stage ('Black Box Tests'){
                steps {
                    //sh "scp -i /home/jenkins/tomcat-demo.pem **/target/*.war ec2-user@${params.tomcat_dev}:/var/lib/tomcat7/webapps"
                    sh "echo Black Box Testing"
                }
            }
        }
    }
}
