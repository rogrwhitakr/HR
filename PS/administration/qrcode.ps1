# adjust this to match your own WiFi 
$wifi = "myAccessPoint"
$pwd = "topSecret12"
 
 
# QR Code will be saved here 
$path = "$home\Desktop\wifiaccess.png"
 
# install the module from the gallery (only required once) 
Install-Module QRCodeGenerator -Scope CurrentUser -Force
# create QR code 
New-QRCodeWifiAccess -SSID $wifi -Password $pwd -OutPath $path
 
# open QR code image with an associated program 
Invoke-Item -Path $path