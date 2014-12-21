call "C:\Program Files (x86)\Microsoft Visual Studio 11.0\VC\vcvarsall.bat" x86_amd64

if not exist "temp" mkdir temp
if not exist "out" mkdir out

sn -k temp/KeyPair.snk
ildasm PlayerIOClient.dll /out:temp/PlayerIOClient.il
ilasm temp/PlayerIOClient.il /dll /resource=temp/PlayerIOClient.res /key=temp/KeyPair.snk /out:temp/PlayerIOClient.dll

nuget pack PlayerIOClient-Signed.nuspec -OutputDirectory out
