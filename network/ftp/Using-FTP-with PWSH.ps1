This is how you can upload a file using FTP with PowerShell.

# Config
$Username = "FTPUSER"
$Password = "P@assw0rd"
$LocalFile = "C:\Temp\file.zip"
$RemoteFile = "ftp://thomasmaurer.ch/downloads/files/file.zip"
 
# Create FTP Rquest Object
$FTPRequest = [System.Net.FtpWebRequest]::Create("$RemoteFile")
$FTPRequest = [System.Net.FtpWebRequest]$FTPRequest
$FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
$FTPRequest.Credentials = new-object System.Net.NetworkCredential($Username, $Password)
$FTPRequest.UseBinary = $true
$FTPRequest.UsePassive = $true
# Read the File for Upload
$FileContent = gc -en byte $LocalFile
$FTPRequest.ContentLength = $FileContent.Length
# Get Stream Request by bytes
$Run = $FTPRequest.GetRequestStream()
$Run.Write($FileContent, 0, $FileContent.Length)
# Cleanup
$Run.Close()
$Run.Dispose()
FTP download file using PowerShell
And this is how you can download files from an FTP server using PowerShell.

# Config
$Username = "FTPUSER"
$Password = "P@assw0rd"
$LocalFile = "C:\Temp\file.zip"
$RemoteFile = "ftp://thomasmaurer.ch/downloads/files/file.zip"
 
# Create a FTPWebRequest
$FTPRequest = [System.Net.FtpWebRequest]::Create($RemoteFile)
$FTPRequest.Credentials = New-Object System.Net.NetworkCredential($Username,$Password)
$FTPRequest.Method = [System.Net.WebRequestMethods+Ftp]::DownloadFile
$FTPRequest.UseBinary = $true
$FTPRequest.KeepAlive = $false
# Send the ftp request
$FTPResponse = $FTPRequest.GetResponse()
# Get a download stream from the server response
$ResponseStream = $FTPResponse.GetResponseStream()
# Create the target file on the local system and the download buffer
$LocalFileFile = New-Object IO.FileStream ($LocalFile,[IO.FileMode]::Create)
[byte[]]$ReadBuffer = New-Object byte[] 1024
# Loop through the download
do {
$ReadLength = $ResponseStream.Read($ReadBuffer,0,1024)
$LocalFileFile.Write($ReadBuffer,0,$ReadLength)
}
while ($ReadLength -ne 0)