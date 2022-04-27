
$octoProjectId="Regeneron.IVR"
$projectPath="C:\Users\cweinberg.BUDCO_NT\Documents\visual studio 2015\Projects\Regeneron.IVR\Regeneron.IVR\Regeneron.IVR.csproj"

# valid versions are [2.0, 3.5, 4.0, 12.0, 14.0]
#Resolve-Path HKLM:\SOFTWARE\Microsoft\MSBuild\ToolsVersions\* | Get-ItemProperty -Name MSBuildToolsPath
$dotNetVersion = "14.0"
$regKey = "HKLM:\software\Microsoft\MSBuild\ToolsVersions\$dotNetVersion"
$regProperty = "MSBuildToolsPath"

$octoServer="http://octopus01.dialog-direct.com/nuget/packages"
$octoApiKey="API-RSF8DESPGJWANFBY7UEOQYJ74"


$msbuildExe = join-path -path (Get-ItemProperty $regKey).$regProperty -childpath "msbuild.exe"

&$msbuildExe $projectPath /t:rebuild /p:Configuration=Release /p:Platform=AnyCPU /p:RunOctoPack=true /p:OctoPackProjectName=$octoProjectId /p:OctoPackPublishPackageToHttp=$octoServer /p:OctoPackPublishApiKey=$octoApiKey

