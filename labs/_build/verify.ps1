$ErrorActionPreference = 'Continue'
$build  = $PSScriptRoot
$labs   = Split-Path -Parent $build
$root   = Split-Path -Parent $labs
$shots  = Join-Path $root 'screenshots'
$notes  = Join-Path $root 'notes-app\my-first-vue-app'
$srcnm  = Join-Path $notes 'node_modules'
$edge   = 'C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe'
$me     = "$env:USERDOMAIN\$env:USERNAME"

function Step($m) { Write-Output ""; Write-Output "=== $m ===" }

# ---------------------------------------------------------------- 1) permissions
Step "grant inheritable FullControl + Low integrity label"
foreach ($d in @($labs, $shots)) {
  & icacls $d /grant "${me}:(OI)(CI)F" /T /C /Q 2>&1 | Out-Null
  & icacls $d /setintegritylevel '(OI)(CI)Low' /T /C /Q 2>&1 | Select-Object -Last 1
  Write-Output "  done: $d"
}

Step "write test"
foreach ($n in @('ch02-fundamentals','ch03-components')) {
  $t = Join-Path $labs "$n\_wtest.txt"
  try { Set-Content $t 'x' -ErrorAction Stop; Write-Output "  OK   $n"; Remove-Item $t -Force }
  catch { Write-Output "  DENY $n  $($_.Exception.Message)" }
}
try { $t = Join-Path $shots '_wtest.txt'; Set-Content $t 'x' -ErrorAction Stop; Write-Output "  OK   screenshots"; Remove-Item $t -Force }
catch { Write-Output "  DENY screenshots  $($_.Exception.Message)" }

# ---------------------------------------------------------------- 2) self-contained projects
Step "make projects offline-runnable"
foreach ($n in @('ch02-fundamentals','ch03-components')) {
  $dst = Join-Path $labs $n
  robocopy $srcnm (Join-Path $dst 'node_modules') /E /NFL /NDL /NJH /NJS /NP /R:1 /W:1 | Out-Null
  Copy-Item (Join-Path $notes 'package-lock.json') (Join-Path $dst 'package-lock.json') -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force (Join-Path $dst 'public') | Out-Null
  Copy-Item (Join-Path $notes 'public\*.svg') (Join-Path $dst 'public\') -Force -ErrorAction SilentlyContinue
  New-Item -ItemType Directory -Force (Join-Path $dst '.vscode') | Out-Null
  Copy-Item (Join-Path $notes '.vscode\extensions.json') (Join-Path $dst '.vscode\') -Force -ErrorAction SilentlyContinue
  Write-Output "  $n files=$((Get-ChildItem $dst -Recurse -Force -File | Measure-Object).Count)"
}

# ---------------------------------------------------------------- 3) build
foreach ($n in @('ch02-fundamentals','ch03-components')) {
  Step "vite build  $n"
  Push-Location (Join-Path $labs $n)
  & node 'node_modules\vite\bin\vite.js' build 2>&1 | Select-Object -Last 10
  Write-Output "  exit=$LASTEXITCODE"
  Pop-Location
}

# ---------------------------------------------------------------- 4) dev servers + screenshots
Step "start dev servers"
$procs = @()
$ports = @{ 'ch02-fundamentals' = 5191; 'ch03-components' = 5192 }
foreach ($n in @('ch02-fundamentals','ch03-components')) {
  $p = Start-Process -FilePath 'node' `
       -ArgumentList @('node_modules\vite\bin\vite.js', '--port', "$($ports[$n])", '--strictPort', '--host', '127.0.0.1') `
       -WorkingDirectory (Join-Path $labs $n) -PassThru -WindowStyle Hidden
  $procs += $p
  Write-Output "  $n pid=$($p.Id) port=$($ports[$n])"
}

Step "wait for readiness"
foreach ($n in @('ch02-fundamentals','ch03-components')) {
  $u = "http://127.0.0.1:$($ports[$n])/"
  $ok = $false
  for ($i = 0; $i -lt 80; $i++) {
    try { $r = Invoke-WebRequest -Uri $u -UseBasicParsing -TimeoutSec 3; if ($r.StatusCode -eq 200) { $ok = $true; break } }
    catch { Start-Sleep -Milliseconds 500 }
  }
  Write-Output "  $u ready=$ok"
}

Step "screenshots + DOM dump"
New-Item -ItemType Directory -Force $shots | Out-Null
$jobs = @(
  @{ url = 'http://127.0.0.1:5191/'; png = 'ch02-01-lab-overview.png'; dom = 'ch02-dom.html'; h = 2700 },
  @{ url = 'http://127.0.0.1:5192/'; png = 'ch03-01-lab-overview.png'; dom = 'ch03-dom.html'; h = 3400 }
)
foreach ($j in $jobs) {
  $png = Join-Path $shots $j.png
  & $edge --headless=new --disable-gpu --no-first-run --no-default-browser-check --hide-scrollbars `
     "--user-data-dir=$build\edge" --virtual-time-budget=5000 --force-device-scale-factor=1.5 `
     "--window-size=1000,$($j.h)" "--screenshot=$png" $j.url 2>&1 | Select-Object -Last 2
  if (Test-Path $png) { Write-Output "  PNG $($j.png) $((Get-Item $png).Length) bytes" } else { Write-Output "  PNG FAILED $($j.png)" }

  $dom = & $edge --headless=new --disable-gpu --no-first-run --no-default-browser-check `
     "--user-data-dir=$build\edge" --virtual-time-budget=5000 --dump-dom $j.url 2>$null
  Set-Content -Path (Join-Path $build $j.dom) -Value ($dom -join "`n") -Encoding UTF8
  Write-Output "  DOM $($j.dom) $((Get-Item (Join-Path $build $j.dom)).Length) bytes"
}

Step "stop dev servers"
foreach ($p in $procs) { try { Stop-Process -Id $p.Id -Force -ErrorAction Stop; Write-Output "  killed $($p.Id)" } catch { Write-Output "  already gone $($p.Id)" } }
Get-CimInstance Win32_Process -Filter "Name='node.exe'" |
  Where-Object { $_.CommandLine -like '*vite*bin*vite.js*' } |
  ForEach-Object { Write-Output "  leftover node pid=$($_.ProcessId)"; Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue }

Step "done"
