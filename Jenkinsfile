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
                // Install bundler and dependencies on Windows
                bat 'gem install bundler'
                bat 'bundle install'
            }
        }

        stage('Run Tests') {
            steps {
                // Run RSpec tests (adjust path if needed)
                bat 'bundle exec rspec'
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
