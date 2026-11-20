#ifndef AppVersion
  #define AppVersion "1.2.3"
#endif

#ifndef DistDir
  #define DistDir "..\build-win-dist"
#endif

[Setup]
AppId={{8D6B4F2C-1A7D-4C9B-B7E2-9F53A2B1D4E0}
AppName=BluePill
AppVersion={#AppVersion}
AppVerName=BluePill {#AppVersion}
AppPublisher=Nertwork
AppPublisherURL=https://github.com/nertwork/bluepill
AppSupportURL=https://github.com/nertwork/bluepill/issues
AppUpdatesURL=https://github.com/nertwork/bluepill/releases
DefaultDirName={autopf}\BluePill
DefaultGroupName=BluePill
AllowNoIcons=yes
LicenseFile=..\LICENSE
OutputDir=..\dist
OutputBaseFilename=BluePill-Setup-{#AppVersion}-win64
SetupIconFile=..\resources\bluepill.ico
UninstallDisplayIcon={app}\bluepill.exe
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
PrivilegesRequired=admin
ChangesEnvironment=no

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#DistDir}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "..\resources\imessage-notify.wav"; DestDir: "{app}\resources"; Flags: ignoreversion
Source: "..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\BluePill"; Filename: "{app}\bluepill.exe"
Name: "{group}\BluePill (Demo Mode)"; Filename: "{app}\bluepill.exe"; Parameters: "--demo"
Name: "{group}\{cm:UninstallProgram,BluePill}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\BluePill"; Filename: "{app}\bluepill.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\bluepill.exe"; Description: "{cm:LaunchProgram,BluePill}"; Flags: nowait postinstall skipifsilent
