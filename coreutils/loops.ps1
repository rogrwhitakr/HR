

# for loop
for ($i = 1; $i -le 10; $i++) {
    'number is {0}{1}' -f $i, "."
}

# while loop
while (($inp = Read-Host -Prompt "select") -ne "Q") {
    switch ($inp) {
        L {"Datei wird gelöscht"}
        A {"Datei wird angezeigt"}
        R {"Datei erhält Schreibschutz"}
        Q {"Ende"}
        default {"Ungültige Eingabe"}
    }
}

# Nicht-abweisende Schleifen: do-while, do-until
# do-while -> solange die Bedingung wahr ist und bricht ab, wenn sie nicht mehr erfüllt wird.
# do-until -> endet, wenn die Schleifenbedingung den Wert TRUE annimmt

do {
    'Anweisungen des Schleifenkörpers'
}
while ($inp -ne "Q")

do {
    'Anweisungen des Schleifenkörpers'
}
until($inp -ne "Q")


# foreach
$file = Get-ChildItem -File -Path $env:USERPROFILE
foreach ($u in $file) {
    $u.lastwritetime
}