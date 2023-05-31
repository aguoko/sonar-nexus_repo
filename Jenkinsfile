pipeline {
    agent any

    stages {   
        stage('Build with maven') {
            steps {
                sh 'cd SampleWebApp && mvn clean install'
            }
        }
        
        stage('Test') {
            steps {
                sh 'cd SampleWebApp && mvn test'
            }
        
            }
        stage('Code Qualty Scan') {
           steps {
                  withSonarQubeEnv('sonar_server') {
             sh "mvn -f SampleWebApp/pom.xml sonar:sonar"      
               }
            }
       }

       stage('Quality Gate Scan') {
            steps {
               waitForQualityGate abortPipeline: true
            }
      }


        stage('push to nexus') {
            steps {
                nexusArtifactUploader artifacts: [[artifactId: 'SampleWebApp', classifier: '', file: 'SampleWebApp/target/SampleWebApp.war', type: '.war']], credentialsId: 'nexus_credentials', groupId: 'SampleWebApp', nexusUrl: '3.8.211.102:8081', nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-shots', version: '1.0 SNAPSHOT'
            }   
            
        }
        
        stage('deploy to tomcat') {
          steps {
            deploy adapters: [tomcat9(credentialsId: 'tomcat_credentials', path: '', url: 'http://35.178.235.39:8080')], contextPath: 'webapp', war: '**/*.war'
             
            }
            
        }
            
    }
} 
