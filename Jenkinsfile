buildDir = "build"
pylintReport = "${buildDir}/pylint-report.out"
banditReport = "${buildDir}/bandit-report.json"
flake8Report = "${buildDir}/flake8-report.out"
coverageReport = "${buildDir}/coverage.xml"

coverageTool = 'coverage'
pylintTool = 'pylint'
flake8Tool = 'flake8'
banditTool = 'bandit'

// rm -rf -- ${buildDir:?"."}/* .coverage */__pycache__ */*.pyc # mediatools/__pycache__  testpytest/__pycache__ testunittest/__pycache__

pipeline {
  agent any
  stages {
    stage('Code Checkout') {
      steps {
        checkout([$class: 'GitSCM', branches: [[name: '**']], extensions: [[$class: 'CloneOption', noTags: false, reference: '', shallow: false]], userRemoteConfigs: [[credentialsId: 'GitLabPAT2', url: 'https://gitlab.com/okorach/demo-mono-jenkins']]])
      }
    }
    stage('Run tests') {
      steps {
        script {
          echo "Run unit tests for coverage"
          sh "cd comp-cli; ${coverageTool} run -m pytest"
          echo "Generate XML report"
          sh "pwd; cd comp-cli; ${coverageTool} xml -o ${coverageReport}"
        }
      }
    }
    stage('Run 3rd party linters') {
     steps {
        script {
          // sh "cd comp-cli; ${pylintTool} *.py */*.py -r n --msg-template=\"{path}:{line}: [{msg_id}({symbol}), {obj}] {msg}\" > ${pylintReport}"
          // sh "cd comp-cli; ${flake8Tool} --ignore=W503,E128,C901,W504,E302,E265,E741,W291,W293,W391 --max-line-length=150 . > ${flake8Report}"
          // sh "cd comp-cli; ${banditTool} -f json --skip B311,B303 -r . -x .vscode,./testpytest,./testunittest > ${banditReport}"
          sh "cd comp-cli; ./run_linters.sh"
        }
      }
    }
    stage('SonarQube LATEST analysis - CLI') {
      steps {
        withSonarQubeEnv('SQ Latest') {
          script {
            def scannerHome = tool 'SonarScanner';
            sh "cd comp-cli; ${scannerHome}/bin/sonar-scanner"
          }
        }
      }
    }
    stage("SonarQube LATEST Quality Gate - CLI") {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              echo "CLI component quality gate failed: ${qg.status}, proceeding anyway"
            }
            sh 'rm -f comp-cli/.scannerwork/report-task.txt'
          }
        }
      }
    }
    stage('SonarQube LATEST analysis - Maven') {
      steps {
        withSonarQubeEnv('SQ Latest') {
          script {
            sh 'cd comp-maven; mvn -B clean org.jacoco:jacoco-maven-plugin:prepare-agent install org.jacoco:jacoco-maven-plugin:report sonar:sonar'
          }
        }
      }
    }
    stage("SonarQube LATEST Quality Gate - Maven") {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              echo "Maven component quality gate failed: ${qg.status}, proceeding anyway"
            }
            sh 'rm -f comp-maven/target/sonar/report-task.txt'
          }
        }
      }
    }
    stage('SonarQube LATEST analysis - Gradle') {
      steps {
        withSonarQubeEnv('SQ Latest') {
          script {
            sh 'cd comp-gradle; ./gradlew jacocoTestReport sonarqube'
          }
        }
      }
    }
    stage("SonarQube LATEST Quality Gate - Gradle") {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              echo "Gradle component quality gate failed: ${qg.status}, proceeding anyway"
            }
            sh 'rm -f comp-gradle/build/sonar/report-task.txt'
          }
        }
      }
    }
    stage('SonarQube LATEST analysis - .Net') {
      steps {
        script {
          def dotnetScannerHome = tool 'Scanner for .Net Core'
          withSonarQubeEnv('SQ Latest') {
            sh "cd comp-dotnet; /usr/local/share/dotnet/dotnet ${dotnetScannerHome}/SonarScanner.MSBuild.dll begin /k:\"demo:github-mono-jenkins-dotnet\" /n:\"GitHub / Jenkins / monorepo .Net Core\"" 
            sh "cd comp-dotnet; /usr/local/share/dotnet/dotnet build"
            updateGitlabCommitStatus name: 'jenkins', state: 'running'
            sh "cd comp-dotnet; /usr/local/share/dotnet/dotnet ${dotnetScannerHome}/SonarScanner.MSBuild.dll end"
            updateGitlabCommitStatus name: 'jenkins', state: 'running'
          }
        }
      }
    }
    stage("SonarQube LATEST Quality Gate - .Net") {
      steps {
        timeout(time: 5, unit: 'MINUTES') {
          script {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              updateGitlabCommitStatus name: 'jenkins', state: 'failed'
              echo ".Net component quality gate failed: ${qg.status}, proceeding anyway"
            }
            sh 'rm -f comp-dotnet/.sonarqube/out/.sonar/report-task.txt'
          }
        }
      }
    }
  }
}