#define sAppName            'ONLYOFFICE DocumentServer'
#define APP_PATH            'ONLYOFFICE\DocumentServer'
#define APP_REG_PATH        'Software\ONLYOFFICE\DocumentServer'
#define sPackageName        'onlyoffice-documentserver'
#define iconsExe            'projicons.exe'

#define sAppVersion         '4.0.4'
#define sAppVerShort

#define NSSM                  '{app}\server\Winser\node_modules\winser\bin\nssm64.exe'
#define NODE_SRV_ENV          'NODE_ENV=production-windows NODE_CONFIG_DIR=""{app}\server\Common\config"" NODE_DISABLE_COLORS=1'

#define CONVERTER_SRV        'ds_converter'
#define CONVERTER_SRV_DESCR  'converter description'
#define CONVERTER_SRV_DIR    '{app}\server\FileConverter\sources'
#define CONVERTER_SRV_LOG_DIR    '{app}\Log\converter'

#define DOCSERVICE_SRV        'ds_docservice'
#define DOCSERVICE_SRV_DESCR  'docservice description'
#define DOCSERVICE_SRV_DIR    '{app}\server\docservice\sources'
#define DOCSERVICE_SRV_LOG_DIR    '{app}\Log\docservice'

#define GC_SRV        'ds_gc'
#define GC_SRV_DESCR  'gc description'
#define GC_SRV_DIR    '{app}\server\docservice\sources'
#define GC_SRV_LOG_DIR    '{app}\Log\gc'

#define SPELLCHECKER_SRV        'ds_spellchecker'
#define SPELLCHECKER_SRV_DESCR  'spelchecker description'
#define SPELLCHECKER_SRV_DIR    '{app}\server\SpellChecker\sources'
#define SPELLCHECKER_SRV_LOG_DIR    '{app}\Log\spellchecker'

#define PSQL '{pf64}\PostgreSQL\9.5\bin\psql.exe'
#define CREATEDB '{pf64}\PostgreSQL\9.5\bin\createdb.exe'                                 
#define REDISCLI '{pf64}\Redis\redis-cli.exe'
#define RABBITMQCTL '{pf64}\RabbitMQ Server\rabbitmq_server-3.6.5\sbin\rabbitmqctl.bat'

#define NPM 'npm'
#define JSON '{userappdata}\npm\json.cmd'

#define JSON_PARAMS '-I -q -f ""{app}\server\Common\config\default.json""'

[Setup]
AppName                   ={#sAppName}
AppVerName                ={#sAppName} {#sAppVerShort}
AppVersion                ={#sAppVersion}
VersionInfoVersion        ={#sAppVersion}
OutputBaseFilename        ={#sPackageName}

AppPublisher            =Ascensio System SIA.
AppPublisherURL         =http://www.onlyoffice.com/
AppSupportURL           =http://www.onlyoffice.com/support.aspx
AppCopyright            =Copyright (C) 2016 Ascensio System SIA.

ArchitecturesAllowed              =x64
ArchitecturesInstallIn64BitMode   =x64

DefaultGroupName        =ONLYOFFICE
;WizardImageFile         = data\dialogpicture.bmp
;WizardSmallImageFile    = data\dialogicon.bmp


UsePreviousAppDir         =no
DirExistsWarning          =no
DefaultDirName            ={pf}\{#APP_PATH}
DisableProgramGroupPage   = yes
DisableWelcomePage        = no
DEPCompatible             = no
ASLRCompatible            = no
DisableDirPage            = auto
AllowNoIcons              = yes
AlwaysShowDirOnReadyPage  = yes
UninstallDisplayIcon      = {app}\{#sPackageName}
OutputDir                 =.\
Compression               =zip
PrivilegesRequired        =admin
ChangesEnvironment        =yes
SetupMutex                =ASC

[Languages]
Name: "en"; MessagesFile: "compiler:Default.isl"
;Name: "de"; MessagesFile: "compiler:Languages\German.isl"
;Name: "fr"; MessagesFile: "compiler:Languages\French.isl"
;Name: "it"; MessagesFile: "compiler:Languages\Italian.isl"
;Name: "nl"; MessagesFile: "compiler:Languages\Dutch.isl"
;Name: "pl"; MessagesFile: "compiler:Languages\Polish.isl"

[Files]
Source: ..\common\documentserver\home\*;           DestDir: {app}; Flags: ignoreversion recursesubdirs
Source: ..\common\documentserver\bin\*.bat;           DestDir: {app}\bin; Flags: ignoreversion recursesubdirs

[Dirs]
Name: "{app}\server\App_Data";               Permissions: users-full
Name: "{#CONVERTER_SRV_LOG_DIR}";     Permissions: users-full
Name: "{#DOCSERVICE_SRV_LOG_DIR}";    Permissions: users-full
Name: "{#GC_SRV_LOG_DIR}";            Permissions: users-full
Name: "{#SPELLCHECKER_SRV_LOG_DIR}";  Permissions: users-full

[Run]
Filename: "{app}\bin\documentserver-generate-allfonts.bat"; Flags: runhidden

Filename: "{#NPM}"; Parameters: "install -g json"; Flags: runhidden shellexec waituntilterminated
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbHost = '{code:GetDbHost}'"""; Flags: runhidden
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbUser = '{code:GetDbUser}'"""; Flags: runhidden
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbPass = '{code:GetDbPwd}'"""; Flags: runhidden
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.sql.dbName = '{code:GetDbName}'"""; Flags: runhidden

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.rabbitmq.url = 'amqp://{code:GetRabbitMqHost}'"""; Flags: runhidden
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.rabbitmq.login = '{code:GetRabbitMqUser}'"""; Flags: runhidden
Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.rabbitmq.password = '{code:GetRabbitMqPwd}'"""; Flags: runhidden

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.redis.host = '{code:GetRedisHost}'"""; Flags: runhidden

Filename: "{#JSON}"; Parameters: "{#JSON_PARAMS} -e ""this.services.CoAuthoring.server.port = '{code:GetDefaultPort}'"""; Flags: runhidden

Filename: "{#CREATEDB}";  Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} {code:GetDbName}"; Check: IsNotDbExist(); Flags: runhidden
Filename: "{#PSQL}";      Parameters: "-h {code:GetDbHost} -U {code:GetDbUser} -d {code:GetDbName} -f ""{app}\server\schema\postgresql\createdb.sql"""; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#CONVERTER_SRV} node convertermaster.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} Description {#CONVERTER_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppDirectory {#CONVERTER_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStdout {#CONVERTER_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#CONVERTER_SRV} AppStderr {#CONVERTER_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#CONVERTER_SRV}"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#DOCSERVICE_SRV} node server.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} Description {#DOCSERVICE_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppDirectory {#DOCSERVICE_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStdout {#DOCSERVICE_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#DOCSERVICE_SRV} AppStderr {#DOCSERVICE_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#DOCSERVICE_SRV}"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#GC_SRV} node gc.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} Description {#GC_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppDirectory {#GC_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppStdout {#GC_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#GC_SRV} AppStderr {#GC_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#GC_SRV}"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "install {#SPELLCHECKER_SRV} node server.js"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} Description {#SPELLCHECKER_SRV_DESCR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppDirectory {#SPELLCHECKER_SRV_DIR}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppEnvironmentExtra {#NODE_SRV_ENV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppStdout {#SPELLCHECKER_SRV_LOG_DIR}\out.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "set {#SPELLCHECKER_SRV} AppStderr {#SPELLCHECKER_SRV_LOG_DIR}\error.log"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "start {#SPELLCHECKER_SRV}"; Flags: runhidden

[UninstallRun]
Filename: "{#NSSM}"; Parameters: "stop {#CONVERTER_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#CONVERTER_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#DOCSERVICE_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#DOCSERVICE_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#GC_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#GC_SRV} confirm"; Flags: runhidden

Filename: "{#NSSM}"; Parameters: "stop {#SPELLCHECKER_SRV}"; Flags: runhidden
Filename: "{#NSSM}"; Parameters: "remove {#SPELLCHECKER_SRV} confirm"; Flags: runhidden

[UninstallDelete]
Type: filesandordirs; Name: "{app}\*"

; shared code for installing the products
#include "scripts\products.iss"
; helper functions
#include "scripts\products\stringversion.iss"
#include "scripts\products\winversion.iss"
#include "scripts\products\fileversion.iss"

#include "scripts\products\nodejs4x.iss"
#include "scripts\products\postgresql.iss"
#include "scripts\products\rabbitmq.iss"
#include "scripts\products\redis.iss"

[Code]
function InitializeSetup(): Boolean;
begin
	// initialize windows version
	initwinversion();

  nodejs4x('4.0.0.0');
  postgresql('9.5.4.0');
  rabbitmq('3.6.5');
  redis('3.2.100');

	Result := true;
end;

var
  DbPage: TInputQueryWizardPage;
  RabbitMqPage: TInputQueryWizardPage;
  RedisPage: TInputQueryWizardPage;

function GetDbHost(Param: String): String;
begin
  Result := DbPage.Values[0];
end;

function GetDbPort(Param: String): String;
begin
  Result := IntToStr(5432);
end;

function GetDbUser(Param: String): String;
begin
  Result := DbPage.Values[1];
end;

function GetDbPwd(Param: String): String;
begin
  Result := DbPage.Values[2];
end;

function GetDbName(Param: String): String;
begin
  Result := DbPage.Values[3];
end;

function GetRabbitMqHost(Param: String): String;
begin
  Result := RabbitMqPage.Values[0];
end;

function GetRabbitMqUser(Param: String): String;
begin
  Result := RabbitMqPage.Values[1];
end;

function GetRabbitMqPwd(Param: String): String;
begin
  Result := RabbitMqPage.Values[2];
end;

function GetRedisHost(Param: String): String;
begin
  Result := RedisPage.Values[0];
end;

function GetDefaultPort(Param: String): String;
begin
  Result := ExpandConstant('{param:DOCSERVICE_PORT|80}');
end;

procedure InitializeWizard;
begin
  DbPage := CreateInputQueryPage(wpPreparing,
    'PostgreSQL Database', 'Configure PostgreSQL Connection...',
    'Please specify your PostgreSQL connection, then click Next.');
  DbPage.Add('Host:', False);
  DbPage.Add('User:', False);
  DbPage.Add('Password:', True);
  DbPage.Add('Database:', False);

  DbPage.Values[0] := ExpandConstant('{param:DB_HOST|localhost}');
  DbPage.Values[1] := ExpandConstant('{param:DB_USER|onlyoffice}');
  DbPage.Values[2] := ExpandConstant('{param:DB_PWD|onlyoffice}');
  DbPage.Values[3] := ExpandConstant('{param:DB_NAME|onlyoffice}');

  RabbitMqPage := CreateInputQueryPage(DbPage.ID,
    'RabbitMQ Messaging Broker', 'Configure RabbitMQ Connection...',
    'Please specify your RabbitMQ connection, then click Next.');
  RabbitMqPage.Add('Host:', False);
  RabbitMqPage.Add('User:', False);
  RabbitMqPage.Add('Password:', True);

  RabbitMqPage.Values[0] := ExpandConstant('{param:RABBITMQ_HOST|localhost}');
  RabbitMqPage.Values[1] := ExpandConstant('{param:RABBITMQ_USER|guest}');
  RabbitMqPage.Values[2] := ExpandConstant('{param:RABBITMQ_PWD|guest}');

  RedisPage := CreateInputQueryPage(RabbitMqPage.ID,
    'Redis In-Memory Database', 'Configure Redis Connection...',
    'Please specify your Reids connection, then click Next.');
  RedisPage.Add('Host:', False);

  RedisPage.Values[0] := ExpandConstant('{param:REDIS_HOST|localhost}');

end;

function IsNotDbExist(): Boolean;
begin
  Result := False;
end;

function CheckDbConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;
  SaveStringToFile(
    ExpandConstant('{userappdata}\postgresql\pgpass.conf'),
    GetDbHost('')+ ':' + GetDbPort('')+ ':' + GetDbUser('') + ':' + GetDbName('') + ':' + GetDbPwd(''),
    False);

  Exec(
    ExpandConstant('{#PSQL}'),
    '-h ' + GetDbHost('') + ' -U ' + GetDbUser('') + ' -d ' + GetDbName('') + ' -w -c ";"',
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox('Connection to ' + GetDbHost('') + ' failed!' + #13#10 + 'PSQL return ' + IntToStr(ResultCode)+ ' code.' +  #13#10 + 'Check the connection settings and try again.', mbError, MB_OK);
    Result := false;
  end;
end;

function CheckRabbitMqConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;
    Exec(
    ExpandConstant('{#RABBITMQCTL}'),
    '-q list_queues',
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox('Connection to ' + GetRedisHost('') + ' failed!' + #13#10 + 'redis-cli return ' + IntToStr(ResultCode)+ ' code.' +  #13#10 + 'Check the connection settings and try again.', mbError, MB_OK);
    Result := false;
  end;
end;

function CheckRedisConnection(): Boolean;
var
  ResultCode: Integer;
begin
  Result := true;
    Exec(
    ExpandConstant('{#REDISCLI}'),
    '-h ' + GetRedisHost('') + ' --version',
    '', 
    SW_HIDE,
    ewWaitUntilTerminated,
    ResultCode);

  if ResultCode <> 0 then
  begin
    MsgBox('Connection to ' + GetRedisHost('') + ' failed!' + #13#10 + 'redis-cli return ' + IntToStr(ResultCode)+ ' code.' +  #13#10 + 'Check the connection settings and try again.', mbError, MB_OK);
    Result := false;
  end;
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  Result := true;
  case CurPageID of
    DbPage.ID: Result := CheckDbConnection();
    RabbitMqPage.ID: Result := CheckRabbitMqConnection();
    RedisPage.ID: Result := CheckRedisConnection();
    wpReady: Result := DownloadDependency();
  end;
end;                                                     
