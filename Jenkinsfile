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
//    stage('SonarQube LTS analysis') {
//      steps {
//        withSonarQubeEnv('SQ LTS') {
//          script {
//            def scannerHome = tool 'SonarScanner';
//            sh "${scannerHome}/bin/sonar-scanner"
//          }
//        }
//      }
//    }
//    stage("SonarQube LTS Quality Gate") {
//      steps {
//        timeout(time: 5, unit: 'MINUTES') {
//          script {
//            def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
//            if (qg.status != 'OK') {
//              echo "Quality gate failed: ${qg.status}, proceeding anyway"
//            }
//          }
//        }
//      }
//    }
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
            sh 'cd comp-maven; mvn sonar:sonar -B clean org.jacoco:jacoco-maven-plugin:prepare-agent install org.jacoco:jacoco-maven-plugin:report sonar:sonar -Dsonar.projectKey="demo:github-comp-maven" -Dsonar.projectName="GitHub project - Maven"'
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
//    stage('SonarQube LATEST analysis - .Net') {
//      steps {
//        withSonarQubeEnv('SQ Latest', envOnly: true) {
//          script {
//            sh 'cd comp-dotnet; /usr/local/share/dotnet/dotnet sonarscanner begin /k:"demo:github-comp-dotnet" /n:"GitHub project - .Net Core" /d:"sonar.host.url=${env.SONAR_HOST_URL}" /d:"sonar.login=${env.SONAR_AUTH_TOKEN}"; /usr/local/share/dotnet/dotnet build; /usr/local/share/dotnet/dotnet sonarscanner end /d:"sonar.login=${env.SONAR_AUTH_TOKEN}"'
//          }
//        }
//      }
//    }
//    stage("SonarQube LATEST Quality Gate - .Net") {
//      steps {
//        timeout(time: 5, unit: 'MINUTES') {
//          script {
//            def qg = waitForQualityGate()
//            if (qg.status != 'OK') {
//              echo ".Net component quality gate failed: ${qg.status}, proceeding anyway"
//            }
//            sh 'rm -f comp-dotnet/build/sonar/report-task.txt'
//          }
//        }
//      }
//    }
  }
}