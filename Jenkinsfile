pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                // Pull latest code from repo
                checkout scm
            }
        }

        stage('Setup Ruby Environment') {
            steps {
                // Install bundler and dependencies
                sh 'gem install bundler'
                sh 'bundle install'
            }
        }

        stage('Run Tests') {
            steps {
                // Run RSpec tests (change path if needed)
                sh 'rspec spec/'
            }
        }
    }

    post {
        always {
            echo 'Cleaning up...'
            // Optional cleanup steps here
        }
        success {
            echo 'Tests passed! 🎉'
        }
        failure {
            echo 'Tests failed! 💥'
        }
    }
}
