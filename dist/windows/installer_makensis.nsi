﻿;Popcorn Time
;Installer Source for NSIS 3.0 or higher

;Enable Unicode encoding
Unicode True

;Include Modern UI
!include "MUI2.nsh"
!include "FileFunc.nsh"

;Check file paths
!if /FILEEXISTS "..\..\package.json"
    ;File exists!
    !define WIN_PATHS
!else
    ;File does NOT exist!
!endif

; ------------------- ;
;  Parse Gruntfile.js ;
; ------------------- ;
!ifdef WIN_PATHS
    !searchparse /file "..\..\Gruntfile.js" "version: '" APP_NW "',"
!else
    !searchparse /file "../../Gruntfile.js" "version: '" APP_NW "',"
!endif

;Parse package.json
!ifdef WIN_PATHS
    !searchparse /file "..\..\package.json" '"name": "' APP_NAME '",'
!else
    !searchparse /file "../../package.json" '"name": "' APP_NAME '",'
!endif
!searchreplace APP_NAME "${APP_NAME}" "-" " "
!ifdef WIN_PATHS
    !searchparse /file "..\..\package.json" '"version": "' PT_VERSION '",'
!else
    !searchparse /file "../../package.json" '"version": "' PT_VERSION '",'
!endif
!searchreplace PT_VERSION_CLEAN "${PT_VERSION}" "-" ".0"
!ifdef WIN_PATHS
    !searchparse /file "..\..\package.json" '"homepage": "' APP_URL '",'
    !searchparse /file "..\..\package.json" '"name": "' DATA_FOLDER '",'
!else
    !searchparse /file "../../package.json" '"homepage": "' APP_URL '",'
    !searchparse /file "../../package.json" '"name": "' DATA_FOLDER '",'
!endif

; ------------------- ;
;      Settings       ;
; ------------------- ;
;General Settings
!define COMPANY_NAME "Popcorn Official"
!define UNINSTALL_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APP_NAME}"
Name "${APP_NAME}"
Caption "${APP_NAME} v${PT_VERSION}"
BrandingText "${APP_NAME} v${PT_VERSION}"
VIAddVersionKey "ProductName" "${APP_NAME}"
VIAddVersionKey "ProductVersion" "v${PT_VERSION}"
VIAddVersionKey "FileDescription" "${APP_NAME} v${PT_VERSION} Installer"
VIAddVersionKey "FileVersion" "v${PT_VERSION}"
VIAddVersionKey "CompanyName" "${COMPANY_NAME}"
VIAddVersionKey "LegalCopyright" "${APP_URL}"
VIProductVersion "${PT_VERSION_CLEAN}.0"
OutFile "${APP_NAME}-${PT_VERSION}-Win-Setup.exe"
CRCCheck on
SetCompressor /SOLID lzma

;Default installation folder
InstallDir "$LOCALAPPDATA\${APP_NAME}"

;Request application privileges
RequestExecutionLevel user

; ------------------- ;
;     UI Settings     ;
; ------------------- ;
;Define UI settings
!ifdef WIN_PATHS
    !define MUI_UI_HEADERIMAGE_RIGHT "..\..\src\app\images\icon.png"
    !define MUI_ICON "..\..\src\app\images\popcorntime.ico"
    !define MUI_UNICON "..\..\src\app\images\popcorntime.ico"
!else
    !define MUI_UI_HEADERIMAGE_RIGHT "../../src/app/images/icon.png"
    !define MUI_ICON "../../src/app/images\popcorntime.ico"
    !define MUI_UNICON "../../src/app/images\popcorntime.ico"
!endif
!define MUI_WELCOMEFINISHPAGE_BITMAP "installer-image.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "uninstaller-image.bmp"
!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_LINK "${APP_URL}"
!define MUI_FINISHPAGE_LINK_LOCATION "${APP_URL}"
!define MUI_FINISHPAGE_RUN "$INSTDIR\node-webkit\${APP_NAME}.exe"
!define MUI_FINISHPAGE_RUN_PARAMETERS "."

;Define the pages
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "LICENSE.txt"
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;Define uninstall pages
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

;Load Language Files
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_LANGUAGE "Afrikaans"
!insertmacro MUI_LANGUAGE "Albanian"
!insertmacro MUI_LANGUAGE "Arabic"
!insertmacro MUI_LANGUAGE "Asturian"
!insertmacro MUI_LANGUAGE "Basque"
!insertmacro MUI_LANGUAGE "Belarusian"
!insertmacro MUI_LANGUAGE "Bosnian"
!insertmacro MUI_LANGUAGE "Breton"
!insertmacro MUI_LANGUAGE "Bulgarian"
!insertmacro MUI_LANGUAGE "Catalan"
!insertmacro MUI_LANGUAGE "Croatian"
!insertmacro MUI_LANGUAGE "Czech"
!insertmacro MUI_LANGUAGE "Danish"
!insertmacro MUI_LANGUAGE "Dutch"
!insertmacro MUI_LANGUAGE "Esperanto"
!insertmacro MUI_LANGUAGE "Estonian"
!insertmacro MUI_LANGUAGE "Farsi"
!insertmacro MUI_LANGUAGE "Finnish"
!insertmacro MUI_LANGUAGE "French"
!insertmacro MUI_LANGUAGE "Galician"
!insertmacro MUI_LANGUAGE "German"
!insertmacro MUI_LANGUAGE "Greek"
!insertmacro MUI_LANGUAGE "Hebrew"
!insertmacro MUI_LANGUAGE "Hungarian"
!insertmacro MUI_LANGUAGE "Icelandic"
!insertmacro MUI_LANGUAGE "Indonesian"
!insertmacro MUI_LANGUAGE "Irish"
!insertmacro MUI_LANGUAGE "Italian"
!insertmacro MUI_LANGUAGE "Japanese"
!insertmacro MUI_LANGUAGE "Korean"
!insertmacro MUI_LANGUAGE "Kurdish"
!insertmacro MUI_LANGUAGE "Latvian"
!insertmacro MUI_LANGUAGE "Lithuanian"
!insertmacro MUI_LANGUAGE "Luxembourgish"
!insertmacro MUI_LANGUAGE "Macedonian"
!insertmacro MUI_LANGUAGE "Malay"
!insertmacro MUI_LANGUAGE "Mongolian"
!insertmacro MUI_LANGUAGE "Norwegian"
!insertmacro MUI_LANGUAGE "NorwegianNynorsk"
!insertmacro MUI_LANGUAGE "Pashto"
!insertmacro MUI_LANGUAGE "Polish"
!insertmacro MUI_LANGUAGE "Portuguese"
!insertmacro MUI_LANGUAGE "PortugueseBR"
!insertmacro MUI_LANGUAGE "Romanian"
!insertmacro MUI_LANGUAGE "Russian"
!insertmacro MUI_LANGUAGE "Serbian"
!insertmacro MUI_LANGUAGE "SerbianLatin"
!insertmacro MUI_LANGUAGE "SimpChinese"
!insertmacro MUI_LANGUAGE "Slovak"
!insertmacro MUI_LANGUAGE "Slovenian"
!insertmacro MUI_LANGUAGE "Spanish"
!insertmacro MUI_LANGUAGE "SpanishInternational"
!insertmacro MUI_LANGUAGE "Swedish"
!insertmacro MUI_LANGUAGE "Thai"
!insertmacro MUI_LANGUAGE "TradChinese"
!insertmacro MUI_LANGUAGE "Turkish"
!insertmacro MUI_LANGUAGE "Ukrainian"
!insertmacro MUI_LANGUAGE "Uzbek"
!insertmacro MUI_LANGUAGE "Vietnamese"
!insertmacro MUI_LANGUAGE "Welsh"

; ------------------- ;
;    Localization     ;
; ------------------- ;
LangString removeDataFolder ${LANG_ENGLISH} "Remove all databases and configuration files?"
LangString removeDataFolder ${LANG_Afrikaans} "Alle databasisse en opset lêers verwyder?" 
LangString removeDataFolder ${LANG_Albanian} "Hiq të gjitha bazat e të dhënave dhe fotografi konfigurimit?" 
LangString removeDataFolder ${LANG_Arabic} "إزالة كافة قواعد البيانات وملفات التكوين؟" 
LangString removeDataFolder ${LANG_Asturian} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Basque} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Belarusian} "Выдаліць усе базы дадзеных і файлы канфігурацыі?" 
LangString removeDataFolder ${LANG_Bosnian} "Uklonite sve baze podataka i konfiguracijske datoteke?" 
LangString removeDataFolder ${LANG_Breton} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Bulgarian} "Премахнете всички бази данни и конфигурационни файлове?" 
LangString removeDataFolder ${LANG_Catalan} "Eliminar totes les bases de dades i arxius de configuració?" 
LangString removeDataFolder ${LANG_Croatian} "Uklonite sve baze podataka i konfiguracijske datoteke?" 
LangString removeDataFolder ${LANG_Czech} "Odstraňte všechny databáze a konfiguračních souborů?" 
LangString removeDataFolder ${LANG_Danish} "Fjern alle databaser og konfigurationsfiler?" 
LangString removeDataFolder ${LANG_Dutch} "Verwijder alle databases en configuratiebestanden?" 
LangString removeDataFolder ${LANG_Esperanto} "Forigi la tuta datumbazojn kaj agordaj dosieroj?" 
LangString removeDataFolder ${LANG_Estonian} "Eemalda kõik andmebaasid ja konfiguratsioonifailid?" 
LangString removeDataFolder ${LANG_Farsi} "حذف تمام پایگاه داده ها و فایل های پیکربندی؟" 
LangString removeDataFolder ${LANG_Finnish} "Poista kaikki tietokannat ja asetustiedostot?" 
LangString removeDataFolder ${LANG_French} "Supprimer toutes les bases de données et les fichiers de configuration ?" 
LangString removeDataFolder ${LANG_Galician} "Eliminar todos os bancos de datos e arquivos de configuración?" 
LangString removeDataFolder ${LANG_German} "Alle Datenbanken und Konfigurationsdateien zu entfernen?" 
LangString removeDataFolder ${LANG_Greek} "Αφαιρέστε όλες τις βάσεις δεδομένων και τα αρχεία διαμόρφωσης;" 
LangString removeDataFolder ${LANG_Hebrew} "הסר את כל קבצי תצורת מסדי נתונים ו" 
LangString removeDataFolder ${LANG_Hungarian} "Vegye ki az összes adatbázisok és konfigurációs fájlok?" 
LangString removeDataFolder ${LANG_Icelandic} "Fjarlægja allar gagnagrunna og stillingar skrá?" 
LangString removeDataFolder ${LANG_Indonesian} "Hapus semua database dan file konfigurasi?" 
LangString removeDataFolder ${LANG_Irish} "Bain na bunachair shonraí agus comhaid cumraíochta?" 
LangString removeDataFolder ${LANG_Italian} "Rimuovere tutti i database ei file di configurazione?" 
LangString removeDataFolder ${LANG_Japanese} "すべてのデータベースと設定ファイルを削除しますか？" 
LangString removeDataFolder ${LANG_Korean} "모든 데이터베이스와 구성 파일을 삭제 하시겠습니까?" 
LangString removeDataFolder ${LANG_Kurdish} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Latvian} "Noņemt visas datu bāzes un konfigurācijas failus?" 
LangString removeDataFolder ${LANG_Lithuanian} "Pašalinti visas duombazes ir konfigūravimo failus?" 
LangString removeDataFolder ${LANG_Luxembourgish} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Macedonian} "Отстрани ги сите бази на податоци и конфигурациските датотеки?" 
LangString removeDataFolder ${LANG_Malay} "Buang semua pangkalan data dan fail-fail konfigurasi?" 
LangString removeDataFolder ${LANG_Mongolian} "Бүх өгөгдлийн сангууд болон тохиргооны файлуудыг устгана?" 
LangString removeDataFolder ${LANG_Norwegian} "Fjern alle databaser og konfigurasjonsfiler?" 
LangString removeDataFolder ${LANG_NorwegianNynorsk} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Pashto} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Polish} "Usuń wszystkie bazy danych i plików konfiguracyjnych?" 
LangString removeDataFolder ${LANG_Portuguese} "Remova todos os bancos de dados e arquivos de configuração?" 
LangString removeDataFolder ${LANG_PortugueseBR} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Romanian} "Elimina toate bazele de date și fișierele de configurare?" 
LangString removeDataFolder ${LANG_Russian} "Удалить все базы данных и файлы конфигурации?" 
LangString removeDataFolder ${LANG_Serbian} "Уклоните све базе података и конфигурационе фајлове?" 
LangString removeDataFolder ${LANG_SerbianLatin} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_SimpChinese} "删除所有数据库和配置文件？" 
LangString removeDataFolder ${LANG_Slovak} "Odstráňte všetky databázy a konfiguračných súborov?" 
LangString removeDataFolder ${LANG_Slovenian} "Odstranite vse podatkovne baze in konfiguracijske datoteke?" 
LangString removeDataFolder ${LANG_Spanish} "Eliminar todas las bases de datos y archivos de configuración?" 
LangString removeDataFolder ${LANG_SpanishInternational} "Eliminar todas las bases de datos y archivos de configuración?" 
LangString removeDataFolder ${LANG_Swedish} "Ta bort alla databaser och konfigurationsfiler?" 
LangString removeDataFolder ${LANG_Thai} "ลบฐานข้อมูลทั้งหมดและแฟ้มการกำหนดค่า?" 
LangString removeDataFolder ${LANG_TradChinese} "刪除所有數據庫和配置文件？" 
LangString removeDataFolder ${LANG_Turkish} "Tüm veritabanlarını ve yapılandırma dosyaları çıkarın?" 
LangString removeDataFolder ${LANG_Ukrainian} "Видалити всі бази даних і файли конфігурації?" 
LangString removeDataFolder ${LANG_Uzbek} "Remove all databases and configuration files?" 
LangString removeDataFolder ${LANG_Vietnamese} "Loại bỏ tất cả các cơ sở dữ liệu và các tập tin cấu hình?" 
LangString removeDataFolder ${LANG_Welsh} "Tynnwch yr holl gronfeydd data a ffeiliau cyfluniad?" 

LangString noRoot ${LANG_ENGLISH} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Afrikaans} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Albanian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Arabic} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Asturian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Basque} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Belarusian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Bosnian} "Installation directory cannot require admin privileges" 
LangString noRoot ${LANG_Breton} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Bulgarian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Catalan} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Croatian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Czech} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Danish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Dutch} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Esperanto} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Estonian} "Installation directory cannot require admin privileges" 
LangString noRoot ${LANG_Farsi} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Finnish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_French} "Le répertoire d'installation ne peut être un répertoire administrateur"
LangString noRoot ${LANG_Galician} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_German} "Installation directory cannot require admin privileges" 
LangString noRoot ${LANG_Greek} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Hebrew} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Hungarian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Icelandic} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Indonesian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Irish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Italian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Japanese} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Korean} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Kurdish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Latvian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Lithuanian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Luxembourgish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Macedonian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Malay} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Mongolian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Norwegian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_NorwegianNynorsk} "Installation directory cannot require admin privileges" 
LangString noRoot ${LANG_Pashto} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Polish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Portuguese} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_PortugueseBR} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Romanian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Russian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Serbian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_SerbianLatin} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_SimpChinese} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Slovak} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Slovenian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Spanish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_SpanishInternational} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Swedish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Thai} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_TradChinese} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Turkish} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Ukrainian} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Uzbek} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Vietnamese} "Installation directory cannot require admin privileges"
LangString noRoot ${LANG_Welsh} "Installation directory cannot require admin privileges"

; ------------------- ;
;    Install code     ;
; ------------------- ;
Section ; Node Webkit Files

    ;Delete existing install
    RMDir /r "$INSTDIR"

    ;Set output path to InstallDir
    SetOutPath "$INSTDIR\node-webkit"

    ;Check to see if this nw uses datfiles
    !ifdef WIN_PATHS
        !define DATPATH "..\..\build\cache\win\${APP_NW}\"
    !else
        !define DATPATH "../../build/cache/win/${APP_NW}/"
    !endif

    !ifdef DATPATH
        !if /FILEEXISTS "${DATPATH}icudtl.dat"
            ;File exists!
            !define DATFILES
        !else
            ;File does NOT exist!
        !endif
    !endif
    
    ;Add the files
    !ifdef WIN_PATHS
        File "..\..\build\cache\win\${APP_NW}\*.dll"
        File "/oname=${APP_NAME}.exe" "..\..\build\cache\win\${APP_NW}\nw.exe"
        File "..\..\build\cache\win\${APP_NW}\nw.pak"
    !else
        File "../../build/cache/win/${APP_NW}/*.dll"
        File "/oname=${APP_NAME}.exe" "../../build/cache/win/${APP_NW}/nw.exe"
        File "../../build/cache/win/${APP_NW}/nw.pak"
    !endif

    !ifdef DATFILES
        File "${DATPATH}*.dat"
    !endif

SectionEnd

Section ; App Files

    ;Set output path to InstallDir
    SetOutPath "$INSTDIR\src\app"

    ;Add the files
    !ifdef WIN_PATHS
        File /r "..\..\src\app\css"
        File /r "..\..\src\app\fonts"
        File /r "..\..\src\app\images"
        File /r "..\..\src\app\language"
        File /r "..\..\src\app\lib"
        File /r "..\..\src\app\templates"
        File /r "..\..\src/app\themes"
        File /r /x ".*" /x "test*" /x "example*" "..\..\src\app\vendor"
        File "..\..\src\app\index.html"
        File "..\..\src\app\*.js"
        File /oname=License.txt "..\..\dist\windows\LICENSE.txt"
    !else
        File /r "../../src/app/css"
        File /r "../../src/app/fonts"
        File /r "../../src/app/images"
        File /r "../../src/app/language"
        File /r "../../src/app/lib"
        File /r "../../src/app/templates"
        File /r "../../src/app/themes"
        File /r /x ".*" /x "test*" /x "example*" "../../src/app/vendor"
        File "../../src/app/index.html"
        File "../../src/app/*.js"
        File /oname=License.txt "../../dist/windows/LICENSE.txt"
    !endif

    SetOutPath "$INSTDIR"
    !ifdef WIN_PATHS
        File "..\..\package.json"
        File "..\..\CHANGELOG.md"
        File /NONFATAL "..\..\.git.json"
    !else
        File "../../package.json"
        File "../../CHANGELOG.md"
        File /NONFATAL "../../.git.json"
    !endif

    SetOutPath "$INSTDIR\node_modules"
    !ifdef WIN_PATHS
        File /r /x "*grunt*" /x "stylus" /x "nw-gyp" /x "bower" /x ".bin" /x "bin" /x "test"  /x "test*" /x "example*" /x ".*" /x "*.md" /x "*.gz" /x "benchmark*" /x "*.markdown" "..\..\node_modules\*.*"
    !else
        File /r /x "*grunt*" /x "stylus" /x "nw-gyp" /x "bower" /x ".bin" /x "bin" /x "test"  /x "test*" /x "example*" /x ".*" /x "*.md" /x "*.gz" /x "benchmark*" /x "*.markdown" "../../node_modules/*.*"
    !endif

    ;Create uninstaller
    WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd

; ------------------- ;
;      Shortcuts      ;
; ------------------- ;
Section ; Shortcuts

    ;Working Directory
    SetOutPath "$INSTDIR"
    
    CreateShortCut "$INSTDIR\${APP_NAME}.lnk" "$INSTDIR\node-webkit\${APP_NAME}.exe" "." "$INSTDIR\src\app\images\popcorntime.ico" "" "" "" "${APP_NAME}"

    ;Start Menu Shortcut
    RMDir /r "$SMPROGRAMS\${APP_NAME}"
    CreateDirectory "$SMPROGRAMS\${APP_NAME}"
    CreateShortCut "$SMPROGRAMS\${APP_NAME}\${APP_NAME}.lnk" "$INSTDIR\node-webkit\${APP_NAME}.exe" "." "$INSTDIR\src\app\images\popcorntime.ico" "" "" "" "${APP_NAME} ${PT_VERSION}"
    CreateShortCut "$SMPROGRAMS\${APP_NAME}\Uninstall ${APP_NAME}.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\src\app\images\popcorntime.ico" "" "" "" "Uninstall ${APP_NAME}"

    ;Desktop Shortcut
    Delete "$DESKTOP\${APP_NAME}.lnk"
    CreateShortCut "$DESKTOP\${APP_NAME}.lnk" "$INSTDIR\node-webkit\${APP_NAME}.exe" "." "$INSTDIR\src\app\images\popcorntime.ico" "" "" "" "${APP_NAME} ${PT_VERSION}"

    ;Add/remove programs uninstall entry
    ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
    IntFmt $0 "0x%08X" $0
	WriteRegDWORD HKCU "${UNINSTALL_KEY}" "EstimatedSize" "$0"
	WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayName" "${APP_NAME}"
    WriteRegStr HKCU "${UNINSTALL_KEY}" "DisplayIcon" "$INSTDIR\src\app\images\popcorntime.ico"
    WriteRegStr HKCU "${UNINSTALL_KEY}" "Publisher" "${COMPANY_NAME}"
    WriteRegStr HKCU "${UNINSTALL_KEY}" "UninstallString" "$INSTDIR\Uninstall.exe"
    WriteRegStr HKCU "${UNINSTALL_KEY}" "URLInfoAbout" "${APP_URL}"
    WriteRegStr HKCU "${UNINSTALL_KEY}" "HelpLink" "https://discuss.popcorntime.io"

SectionEnd

; ------------------- ;
;     Uninstaller     ;
; ------------------- ;
Section "uninstall" 

    RMDir /r "$INSTDIR"
    RMDir /r "$SMPROGRAMS\${APP_NAME}"
    Delete "$DESKTOP\${APP_NAME}.lnk"
    
    MessageBox MB_YESNO|MB_ICONQUESTION "$(removeDataFolder)" IDNO NoUninstallData
    RMDir /r "$LOCALAPPDATA\${DATA_FOLDER}"
    NoUninstallData:
    DeleteRegKey HKCU "${UNINSTALL_KEY}"
	DeleteRegKey HKCU "Software\Chromium" ;workaround for NW leftovers
    
SectionEnd

; ------------------- ;
;  Check if writable  ;
; ------------------- ;
Function IsWritable

  !define IsWritable `!insertmacro IsWritableCall`
 
  !macro IsWritableCall _PATH _RESULT
    Push `${_PATH}`
    Call IsWritable
    Pop ${_RESULT}
  !macroend
 
  Exch $R0
  Push $R1
 
start:
  StrLen $R1 $R0
  StrCmp $R1 0 exit
  ${GetFileAttributes} $R0 "DIRECTORY" $R1
  StrCmp $R1 1 direxists
  ${GetParent} $R0 $R0
  Goto start
 
direxists:
  ${GetFileAttributes} $R0 "DIRECTORY" $R1
  StrCmp $R1 0 ok

  StrCmp $R0 $PROGRAMFILES64 notok
  StrCmp $R0 $WINDIR notok

  ${GetFileAttributes} $R0 "READONLY" $R1

  Goto exit

notok:
  StrCpy $R1 1
  Goto exit

ok:
  StrCpy $R1 0
 
exit:
  Exch
  Pop $R0
  Exch $R1
 
FunctionEnd

; ------------------- ;
;  Check install dir  ;
; ------------------- ;
Function .onVerifyInstDir

  Push $R1
  ${IsWritable} $INSTDIR $R1
  IntCmp $R1 0 pathgood
  Pop $R1
  MessageBox MB_OK|MB_USERICON "$(noRoot)" IDOK true
  Abort
true:
  ;TODO: close browser
  Abort

pathgood:
  Pop $R1

FunctionEnd