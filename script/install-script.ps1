# require 5

try {
    if (!(Test-Path -Path $profile)) {
        $profile = New-Item -Path $profile -Force | Out-Null
        'new profile created'
    }
    else {
        $profile = Get-ChildItem -Path $profile | Out-Null
    }
}
catch {
    'an error occured while getting profile information: {0}' -f $_.exception
}