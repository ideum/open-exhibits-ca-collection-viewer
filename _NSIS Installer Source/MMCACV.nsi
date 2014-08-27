; Maxwell Museum Collection Viewer (with CA).nsi
;
; Due to requirements of XAMPP, MMCACV needs to be installed to C: (or the root of the OS drive)
; For convenience, the Collection Viewer is also installed to C:

; Author: Rob Herbertson 7/29/2014

;--------------------------------

;Include Modern UI
!include "MUI2.nsh"

; Installer attributes
AllowRootDirInstall true ; required to 'install' to root dir
ShowInstDetails show ; automatically show install details

; The name of the installer
Name "Maxwell Museum Collection Viewer (with CA)"

; The file to write
OutFile "MMCV (CA) Installer.exe"

; The default installation directory
InstallDir "C:\"						;#############################################################

; Registry key to check for directory (so if you install again, it will
; overwrite the old one automatically)
InstallDirRegKey HKLM "Software\MMCVCA" "Install_Dir"

; Request application privileges for Windows Vista+
RequestExecutionLevel admin

;--------------------------------

; Pages
;Page components
;Page directory ; disallow custom installation directory
;Page instfiles

;UninstPage uninstConfirm
;UninstPage instfiles

!insertmacro MUI_PAGE_WELCOME
;!insertmacro MUI_PAGE_LICENSE "path\to\License.txt"
!insertmacro MUI_PAGE_COMPONENTS

;!insertmacro MUI_PAGE_DIRECTORY ; always install to C: (xampp needs this to function correctly)
!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN
!define MUI_FINISHPAGE_RUN_TEXT "Start Collective Access"
!define MUI_FINISHPAGE_RUN_FUNCTION "StartCA"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

; Language
!insertmacro MUI_LANGUAGE "English"

;--------------------------------

; The stuff to install
Section "Install MM-CV(CA)"

	; Check to see if already installed, offer to uninstall before continuing, or to quit
	ReadRegStr $R0 HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MMCVCA" "UninstallString"
	IfFileExists $R0 +1 NotInstalled
	MessageBox MB_YESNO "MMCV (CA) is already installed. Do you want to uninstall?" /SD IDYES IDNO Quit
		; we just checked for the uninstaller path in the registry
		; so we execute it on the shell to run the uninstaller
		Pop $R1
		StrCmp $R1 2 Quit +1
		Exec $R0
	Quit:
		Quit
	NotInstalled:

  SectionIn RO

  ; Set output path to the installation directory.
  SetOutPath $INSTDIR

  ; Put files there
  File /r open-exhibits-ca-collection-viewer
  File /r xampp

  ; Write the installation path into the registry
  WriteRegStr HKLM SOFTWARE\MMCVCA "Install_Dir" "$INSTDIR"

  ; Write the uninstall keys for Windows
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MMCVCA" "DisplayName" "Maxwell Museum - Collection Viewer (with Collective Access)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MMCVCA" "UninstallString" "$INSTDIR\MMCV (CA) Uninstaller.exe"
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MMCVCA" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MMCVCA" "NoRepair" 1
  WriteUninstaller "$INSTDIR\MMCVCA Uninstaller.exe"

SectionEnd

; Optional section (can be disabled by the user)
SectionGroup "Desktop Shortcuts"
	Section "!Core"
		CreateShortcut "$DESKTOP\Start Collective Access.lnk" "$INSTDIR\xampp\START COLLECTIVEACCESS.exe"
		CreateShortcut "$DESKTOP\(Table) Collection Viewer.lnk" "$INSTDIR\open-exhibits-ca-collection-viewer\bin\Collective Access Collection Viewer.exe"
		CreateShortcut "$DESKTOP\(Wall) Collection Viewer.lnk" "$INSTDIR\open-exhibits-ca-collection-viewer\bin\CollectiveAccessCollectionViewerWall.exe"
	SectionEnd
	
  ;SectionGroup "CV Dial Updater"
	  Section "Dial Updater (Table)"
		CreateShortcut "$DESKTOP\CVCFU Table.lnk" "cmd.exe" "/c $INSTDIR\open-exhibits-ca-collection-viewer\_CVCFU\dist\CVCFU.exe $INSTDIR\open-exhibits-ca-collection-viewer\bin\library\cml\DockTemplate1080p.cml" "cmd.exe" 0
	  SectionEnd

	  Section "Dial Updater (Wall)"
		CreateShortcut "$DESKTOP\CVCFU Wall.lnk" "cmd.exe" "/c $INSTDIR\open-exhibits-ca-collection-viewer\_CVCFU\dist\CVCFU.exe $INSTDIR\open-exhibits-ca-collection-viewer\bin\library\cml\DockTemplate1080p_Wall.cml" "cmd.exe" 0
	  SectionEnd
  ;SectionGroupEnd
SectionGroupEnd

; Optional section (can be disabled by the user)
SectionGroup "Start Menu Shortcuts"
	Section "!Core"
		CreateDirectory "$SMPROGRAMS\MMCVCA"
		CreateShortcut "$SMPROGRAMS\MMCVCA\Start Collective Access.lnk" "$INSTDIR\xampp\START COLLECTIVEACCESS.exe"
		CreateShortcut "$SMPROGRAMS\MMCVCA\(Table) Collection Viewer.lnk" "$INSTDIR\open-exhibits-ca-collection-viewer\bin\Collective Access Collection Viewer.exe"
		CreateShortcut "$SMPROGRAMS\MMCVCA\(Wall) Collection Viewer.lnk" "$INSTDIR\open-exhibits-ca-collection-viewer\bin\CollectiveAccessCollectionViewerWall.exe"
	SectionEnd
	
  ;SectionGroup "CV Dial Updater"
	  Section "Dial Updater (Table)" ;"Table Version"
		CreateDirectory "$SMPROGRAMS\MMCVCA"
		CreateShortcut "$SMPROGRAMS\MMCVCA\CVCFU Table.lnk" "cmd.exe" "/c $INSTDIR\open-exhibits-ca-collection-viewer\_CVCFU\dist\CVCFU.exe $INSTDIR\open-exhibits-ca-collection-viewer\bin\library\cml\DockTemplate1080p.cml" "cmd.exe" 0
	  SectionEnd

	  Section "Dial Updater (Wall)" ;"Wall Version"
		CreateDirectory "$SMPROGRAMS\MMCVCA"
		CreateShortcut "$SMPROGRAMS\MMCVCA\CVCFU Wall.lnk" "cmd.exe" "/c $INSTDIR\open-exhibits-ca-collection-viewer\_CVCFU\dist\CVCFU.exe $INSTDIR\open-exhibits-ca-collection-viewer\bin\library\cml\DockTemplate1080p_Wall.cml" "cmd.exe" 0
	SectionEnd
  ;SectionGroupEnd

  Section "!Uninstaller"
	CreateDirectory "$SMPROGRAMS\MMCVCA"
	CreateShortcut "$SMPROGRAMS\MMCVCA\Uninstall.lnk" "$INSTDIR\MMCVCA Uninstaller.exe" "" "$INSTDIR\MMCVCA Uninstaller.exe" 0
  SectionEnd

SectionGroupEnd

;--------------------------------

; Uninstaller

Section "Uninstall"

  ; Remove registry keys
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\MMCVCA"
  DeleteRegKey HKLM SOFTWARE\MMCVCA

  ; Remove shortcuts and uninstaller
  Delete "$SMPROGRAMS\MMCVCA\*.*"
  Delete "$DESKTOP\Start Collective Access.lnk"
  Delete "$DESKTOP\(Table) Collection Viewer.lnk"
  Delete "$DESKTOP\(Wall) Collection Viewer.lnk"
  Delete "$DESKTOP\CVCFU Table.lnk"
  Delete "$DESKTOP\CVCFU Wall.lnk"
  Delete "$INSTDIR\MMCVCA Uninstaller.exe"
  
  ; Remove directories used
  RMDir "$SMPROGRAMS\MMCVCA"

  ; wipe out xampp and CA installation directories (recursively)
  RMDir /r "$INSTDIR\open-exhibits-ca-collection-viewer"
  RMDir /r "$INSTDIR\xampp"

SectionEnd

Function StartCA
  ExecShell "" "$INSTDIR\xampp\START COLLECTIVEACCESS.exe"
FunctionEnd