#equivalent to tail -f

$log_path = Get-ChildItem -Path 'C:\service\log' | Sort-Object LastWriteTime -Descending | Select-Object -First 1
Get-Content -Path $log_path.FullName -Wait