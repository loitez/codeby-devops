pipeline {
    agent { label 'maven' }
    stages {
        stage('Умная сборка') {
            parallel {
                stage('App World') {
                    when { changeset "app-hello-world/**" }
                    steps { dir('app-hello-world') { sh 'mvn clean package' } }
                }
                stage('App Jenkins') {
                    when { changeset "app-hello-jenkins/**" }
                    steps { dir('app-hello-jenkins') { sh 'mvn clean package' } }
                }
                stage('App Devops') {
                    when { changeset "app-hello-devops/**" }
                    steps { dir('app-hello-devops') { sh 'mvn clean package' } }
                }
            }
        }
    }
}
