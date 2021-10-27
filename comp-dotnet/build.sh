# dotnet tool install --global dotnet-sonarscanner
allopts="" 
for opt in $*
do
    newopt=$(echo $opt|sed 's/^-D/-d:/')
    allopts="$allopts $newopt"
done

dotnet sonarscanner begin /k:"demo:github-mono-jenkins-dotnet" /n:"GitHub / Jenkins / monorepo .Net Core" \
    /d:"sonar.host.url=$SONAR_HOST_URL" /d:"sonar.login=$SONAR_TOKEN" $allopts
dotnet build dotnetcore-sample.sln
dotnet sonarscanner end /d:"sonar.login=${SONAR_TOKEN}"
