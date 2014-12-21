# Import developer command prompt commands
pushd 'c:\Program Files (x86)\Microsoft Visual Studio 11.0\VC'
cmd /c "vcvarsall.bat&set" |
foreach {
  if ($_ -match "=") {
    $v = $_.split("="); set-item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
  }
}
popd

# Create paths if they are missing
New-Item -ItemType Directory -Force -Path temp
New-Item -ItemType Directory -Force -Path out

# Sign the assembly
ildasm PlayerIOClient.dll /out:temp/PlayerIOClient.il
ilasm temp/PlayerIOClient.il /dll /resource=temp/PlayerIOClient.res /key=KeyPair.snk /out:temp/PlayerIOClient.dll

# Create the NuGet package
$version = [System.Reflection.Assembly]::LoadFrom("PlayerIOClient.dll").GetName().Version.ToString();
.\NuGet.exe pack PlayerIOClient-Signed.nuspec -OutputDirectory out -Properties version=$version

# Remote temp
Remove-Item -Recurse -Force temp