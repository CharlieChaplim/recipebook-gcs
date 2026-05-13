@echo off
setlocal EnableExtensions EnableDelayedExpansion

set "ROOT=%~dp0"

echo ================================================
echo RecipeBook v1.0 - Setup e Inicializador Windows
echo ================================================
echo.

echo Pasta do projeto:
echo %ROOT%
echo.

REM ==================================================
REM Verificar winget
REM ==================================================
echo Verificando instalador do Windows...
where winget >nul 2>nul
if errorlevel 1 (
    echo [ERRO] winget nao encontrado.
    echo.
    echo O winget normalmente vem no Windows 10/11 moderno.
    echo Instale/atualize o "App Installer" pela Microsoft Store e rode este BAT de novo.
    echo.
    pause
    exit /b 1
)

echo winget encontrado.
echo.

REM ==================================================
REM Recarregar PATH do sistema + usuario para esta janela
REM ==================================================
call :refreshPath

REM ==================================================
REM Java
REM ==================================================
echo Verificando Java...
where java >nul 2>nul
if errorlevel 1 (
    echo Java nao encontrado no PATH.
    echo Instalando Java 17 LTS...
    winget install --id EclipseAdoptium.Temurin.17.JDK -e --accept-package-agreements --accept-source-agreements

    call :refreshPath
    call :tryFindAndAdd "java.exe"
)

where java >nul 2>nul
if errorlevel 1 (
    echo [ERRO] Java ainda nao foi encontrado.
    echo Tente fechar e abrir o terminal, ou reiniciar o PC.
    pause
    exit /b 1
)

echo Java OK.
java -version
echo.

REM ==================================================
REM Maven
REM ==================================================
echo Verificando Maven...
where mvn >nul 2>nul
if errorlevel 1 (
    echo Maven nao encontrado no PATH.
    echo Instalando Apache Maven...
    winget install --id Apache.Maven -e --accept-package-agreements --accept-source-agreements

    call :refreshPath
    call :tryFindAndAdd "mvn.cmd"
)

where mvn >nul 2>nul
if errorlevel 1 (
    echo [ERRO] Maven ainda nao foi encontrado.
    echo.
    echo O Maven pode ter sido instalado, mas o Windows ainda nao atualizou o PATH desta sessao.
    echo Tente fechar este terminal e executar o BAT novamente.
    echo.
    pause
    exit /b 1
)

echo Maven OK.
call mvn -version
echo.

REM ==================================================
REM Node / npm
REM ==================================================
echo Verificando Node.js / npm...
where npm >nul 2>nul
if errorlevel 1 (
    echo npm nao encontrado no PATH.
    echo Instalando Node.js LTS...
    winget install --id OpenJS.NodeJS.LTS -e --accept-package-agreements --accept-source-agreements

    call :refreshPath
    call :tryFindAndAdd "npm.cmd"
)

where npm >nul 2>nul
if errorlevel 1 (
    echo [ERRO] npm ainda nao foi encontrado.
    echo.
    echo O Node pode ter sido instalado, mas o Windows ainda nao atualizou o PATH desta sessao.
    echo Tente fechar este terminal e executar o BAT novamente.
    echo.
    pause
    exit /b 1
)

echo Node/npm OK.
node -v
call npm -v
echo.

REM ==================================================
REM Conferir pastas do projeto
REM ==================================================
if not exist "%ROOT%backend" (
    echo [ERRO] Pasta backend nao encontrada:
    echo %ROOT%backend
    pause
    exit /b 1
)

if not exist "%ROOT%frontend" (
    echo [ERRO] Pasta frontend nao encontrada:
    echo %ROOT%frontend
    pause
    exit /b 1
)

if not exist "%ROOT%backend\pom.xml" (
    echo [ERRO] pom.xml nao encontrado no backend:
    echo %ROOT%backend\pom.xml
    pause
    exit /b 1
)

if not exist "%ROOT%frontend\package.json" (
    echo [ERRO] package.json nao encontrado no frontend:
    echo %ROOT%frontend\package.json
    pause
    exit /b 1
)

REM ==================================================
REM Criar scripts temporarios de execucao
REM Isso evita bugs de aspas dentro do comando START
REM ==================================================

set "BACKEND_RUNNER=%TEMP%\recipebook_backend_runner.bat"
set "FRONTEND_RUNNER=%TEMP%\recipebook_frontend_runner.bat"

echo @echo off > "%BACKEND_RUNNER%"
echo title RecipeBook Backend >> "%BACKEND_RUNNER%"
echo echo ================================================ >> "%BACKEND_RUNNER%"
echo echo RecipeBook Backend - Spring Boot >> "%BACKEND_RUNNER%"
echo echo ================================================ >> "%BACKEND_RUNNER%"
echo echo. >> "%BACKEND_RUNNER%"
echo cd /d "%ROOT%backend" >> "%BACKEND_RUNNER%"
echo echo Pasta atual: %%CD%% >> "%BACKEND_RUNNER%"
echo echo. >> "%BACKEND_RUNNER%"
echo echo Iniciando backend na porta 8080... >> "%BACKEND_RUNNER%"
echo echo. >> "%BACKEND_RUNNER%"
echo call mvn spring-boot:run >> "%BACKEND_RUNNER%"
echo echo. >> "%BACKEND_RUNNER%"
echo echo Backend encerrado ou ocorreu um erro. >> "%BACKEND_RUNNER%"
echo pause >> "%BACKEND_RUNNER%"

echo @echo off > "%FRONTEND_RUNNER%"
echo title RecipeBook Frontend >> "%FRONTEND_RUNNER%"
echo echo ================================================ >> "%FRONTEND_RUNNER%"
echo echo RecipeBook Frontend - Angular >> "%FRONTEND_RUNNER%"
echo echo ================================================ >> "%FRONTEND_RUNNER%"
echo echo. >> "%FRONTEND_RUNNER%"
echo cd /d "%ROOT%frontend" >> "%FRONTEND_RUNNER%"
echo echo Pasta atual: %%CD%% >> "%FRONTEND_RUNNER%"
echo echo. >> "%FRONTEND_RUNNER%"
echo echo Verificando dependencias do frontend... >> "%FRONTEND_RUNNER%"
echo if not exist node_modules ^( >> "%FRONTEND_RUNNER%"
echo     echo node_modules nao encontrado. Rodando npm install... >> "%FRONTEND_RUNNER%"
echo     call npm install >> "%FRONTEND_RUNNER%"
echo     if errorlevel 1 ^( >> "%FRONTEND_RUNNER%"
echo         echo. >> "%FRONTEND_RUNNER%"
echo         echo [ERRO] npm install falhou. >> "%FRONTEND_RUNNER%"
echo         pause >> "%FRONTEND_RUNNER%"
echo         exit /b 1 >> "%FRONTEND_RUNNER%"
echo     ^) >> "%FRONTEND_RUNNER%"
echo ^) else ^( >> "%FRONTEND_RUNNER%"
echo     echo node_modules encontrado. Pulando npm install. >> "%FRONTEND_RUNNER%"
echo ^) >> "%FRONTEND_RUNNER%"
echo echo. >> "%FRONTEND_RUNNER%"
echo echo Iniciando frontend na porta 4200... >> "%FRONTEND_RUNNER%"
echo echo. >> "%FRONTEND_RUNNER%"
echo call npm start >> "%FRONTEND_RUNNER%"
echo echo. >> "%FRONTEND_RUNNER%"
echo echo Frontend encerrado ou ocorreu um erro. >> "%FRONTEND_RUNNER%"
echo pause >> "%FRONTEND_RUNNER%"

REM ==================================================
REM Iniciar backend
REM ==================================================
echo Abrindo backend Spring Boot na porta 8080...
start "RecipeBook Backend" cmd /k call "%BACKEND_RUNNER%"

echo Aguardando alguns segundos antes de iniciar o frontend...
timeout /t 6 /nobreak >nul

REM ==================================================
REM Iniciar frontend
REM ==================================================
echo Abrindo frontend Angular na porta 4200...
start "RecipeBook Frontend" cmd /k call "%FRONTEND_RUNNER%"

echo.
echo Quando o Angular terminar de compilar, acesse:
echo http://localhost:4200
echo.
echo Console H2:
echo http://localhost:8080/h2-console
echo JDBC URL: jdbc:h2:mem:recipebook
echo User: sa
echo Password: deixe vazio
echo.

timeout /t 8 /nobreak >nul
start "" "http://localhost:4200"

echo Inicializacao solicitada.
echo As duas janelas precisam continuar abertas.
echo Para desligar, feche as janelas do Backend e do Frontend ou pressione CTRL+C em cada uma.
echo.
pause
exit /b 0

REM ==================================================
REM Funcoes
REM ==================================================

:refreshPath
echo Atualizando PATH desta sessao...
for /f "usebackq delims=" %%P in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "[Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User')"`) do (
    set "PATH=%%P"
)
exit /b 0

:tryFindAndAdd
set "TARGET=%~1"
echo Tentando localizar %TARGET% no disco...

for /f "usebackq delims=" %%D in (`powershell -NoProfile -ExecutionPolicy Bypass -Command "$roots=@($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:LOCALAPPDATA, $env:USERPROFILE) | Where-Object { $_ -and (Test-Path $_) }; $found=Get-ChildItem -Path $roots -Filter '%TARGET%' -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1; if($found){ $found.DirectoryName }"`) do (
    call :addUserPath "%%D"
)

call :refreshPath
exit /b 0

:addUserPath
set "DIR_TO_ADD=%~1"

if "%DIR_TO_ADD%"=="" exit /b 0

echo Encontrado em:
echo %DIR_TO_ADD%
echo Adicionando ao PATH do usuario, se ainda nao existir...

powershell -NoProfile -ExecutionPolicy Bypass -Command "$new='%DIR_TO_ADD%'; $old=[Environment]::GetEnvironmentVariable('Path','User'); if(-not $old){$old=''}; $parts=$old -split ';' | Where-Object { $_ }; if($parts -notcontains $new){ [Environment]::SetEnvironmentVariable('Path', ($old.TrimEnd(';') + ';' + $new).TrimStart(';'), 'User') }"

set "PATH=%PATH%;%DIR_TO_ADD%"
exit /b 0