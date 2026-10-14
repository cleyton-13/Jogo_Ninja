# ============================================================
#  Instalador do ambiente de desenvolvimento - Jogo Ninja
#  Instala: Godot 4 (versão estável mais recente) + Git
#  Opcional: -ComAndroid  -> instala JDK 17 e Android Studio
#            (necessários só quando formos exportar para o celular)
#
#  Como executar (clique duas vezes em instalar.bat, ou no PowerShell):
#    powershell -ExecutionPolicy Bypass -File .\ferramentas\instalar-godot.ps1
#    powershell -ExecutionPolicy Bypass -File .\ferramentas\instalar-godot.ps1 -ComAndroid
# ============================================================

param(
    [switch]$ComAndroid
)

$ErrorActionPreference = 'Stop'
$PastaGodot = Join-Path $env:LOCALAPPDATA 'Programs\Godot'

function Escrever-Titulo($texto) {
    Write-Host ''
    Write-Host "=== $texto ===" -ForegroundColor Cyan
}

function Tem-Comando($nome) {
    return [bool](Get-Command $nome -ErrorAction SilentlyContinue)
}

function Instalar-ComWinget($id, $nome) {
    Write-Host "Instalando $nome via winget..."
    winget install --id $id --exact --silent --accept-package-agreements --accept-source-agreements
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  winget retornou código $LASTEXITCODE para $nome (pode já estar instalado)." -ForegroundColor Yellow
    }
}

# ------------------------------------------------------------
Escrever-Titulo 'Verificando winget'
$temWinget = Tem-Comando 'winget'
if ($temWinget) { Write-Host 'winget encontrado.' -ForegroundColor Green }
else { Write-Host 'winget não encontrado - usarei download direto quando possível.' -ForegroundColor Yellow }

# ------------------------------------------------------------
Escrever-Titulo 'Git'
if (Tem-Comando 'git') {
    Write-Host "Git já instalado: $(git --version)" -ForegroundColor Green
} elseif ($temWinget) {
    Instalar-ComWinget 'Git.Git' 'Git'
} else {
    Write-Host 'Instale o Git manualmente em https://git-scm.com/download/win' -ForegroundColor Yellow
}

# ------------------------------------------------------------
Escrever-Titulo 'Godot 4 (estável, versão padrão com GDScript)'

# Baixamos direto do GitHub oficial da Godot para ter sempre a versão estável mais nova
# e manter o executável numa pasta conhecida (facilita usar pela linha de comando).
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$release = Invoke-RestMethod -Uri 'https://api.github.com/repos/godotengine/godot/releases/latest' -Headers @{ 'User-Agent' = 'instalador-jogo-ninja' }
$asset = $release.assets | Where-Object { $_.name -match 'win64\.exe\.zip$' -and $_.name -notmatch 'mono' } | Select-Object -First 1

if (-not $asset) {
    throw 'Não encontrei o arquivo win64 da Godot na última release. Baixe manualmente em https://godotengine.org/download/windows/'
}

Write-Host "Versão encontrada: $($release.tag_name)"
$exeExistente = Get-ChildItem -Path $PastaGodot -Filter 'Godot_v*_win64.exe' -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -notmatch 'console' } | Select-Object -First 1

if ($exeExistente -and $exeExistente.Name -like "*$($release.tag_name)*") {
    Write-Host "Godot $($release.tag_name) já está instalada em $PastaGodot" -ForegroundColor Green
} else {
    New-Item -ItemType Directory -Force -Path $PastaGodot | Out-Null
    $zip = Join-Path $env:TEMP $asset.name
    Write-Host "Baixando $($asset.name) ($([math]::Round($asset.size / 1MB)) MB)..."
    Invoke-WebRequest -Uri $asset.browser_download_url -OutFile $zip -UseBasicParsing
    Write-Host 'Extraindo...'
    Expand-Archive -Path $zip -DestinationPath $PastaGodot -Force
    Remove-Item $zip -Force
    Write-Host "Godot instalada em $PastaGodot" -ForegroundColor Green
}

$exe = Get-ChildItem -Path $PastaGodot -Filter 'Godot_v*_win64.exe' |
    Where-Object { $_.Name -notmatch 'console' } | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$exeConsole = Get-ChildItem -Path $PastaGodot -Filter 'Godot_v*_win64_console.exe' |
    Sort-Object LastWriteTime -Descending | Select-Object -First 1

# Atalho na área de trabalho
$atalho = Join-Path ([Environment]::GetFolderPath('Desktop')) 'Godot.lnk'
$wsh = New-Object -ComObject WScript.Shell
$lnk = $wsh.CreateShortcut($atalho)
$lnk.TargetPath = $exe.FullName
$lnk.WorkingDirectory = $PastaGodot
$lnk.Save()
Write-Host "Atalho criado: $atalho" -ForegroundColor Green

# Atalho "godot.cmd" + PATH do usuário, para rodar "godot" no terminal
# (o Claude Code usa isso para validar scripts e rodar testes sem abrir o editor).
# Obs.: o executável _console precisa manter o nome original, por isso um .cmd e não uma cópia.
Remove-Item (Join-Path $PastaGodot 'godot.exe') -Force -ErrorAction SilentlyContinue
Set-Content -Path (Join-Path $PastaGodot 'godot.cmd') -Encoding ASCII -Value "@`"$($exeConsole.FullName)`" %*"
$pathUsuario = [Environment]::GetEnvironmentVariable('Path', 'User')
if ($pathUsuario -notlike "*$PastaGodot*") {
    [Environment]::SetEnvironmentVariable('Path', "$pathUsuario;$PastaGodot", 'User')
    Write-Host 'Godot adicionada ao PATH do usuário (abra um terminal novo para valer).' -ForegroundColor Green
}

# ------------------------------------------------------------
if ($ComAndroid) {
    Escrever-Titulo 'Ferramentas Android (exportar para o celular)'
    if ($temWinget) {
        Instalar-ComWinget 'Microsoft.OpenJDK.17' 'OpenJDK 17'
        Instalar-ComWinget 'Google.AndroidStudio' 'Android Studio'
        Write-Host ''
        Write-Host 'Próximo passo manual: abra o Android Studio uma vez e deixe ele baixar o Android SDK.' -ForegroundColor Yellow
        Write-Host 'Depois, na Godot: Editor > Configurações do Editor > Exportar > Android, aponte o caminho do SDK.' -ForegroundColor Yellow
    } else {
        Write-Host 'Sem winget: instale manualmente o OpenJDK 17 e o Android Studio.' -ForegroundColor Yellow
    }
}

# ------------------------------------------------------------
Escrever-Titulo 'Pronto!'
& $exeConsole.FullName --version
Write-Host ''
Write-Host 'Abra a Godot pelo atalho "Godot" na área de trabalho.' -ForegroundColor Green
Write-Host 'Quando o Claude criar o projeto, use "Importar" e escolha a pasta do jogo.'
