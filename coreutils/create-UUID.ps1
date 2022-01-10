# create a new uuid
[guid]::NewGuid()

# direct copy and paste
"{" + ([guid]::NewGuid()).guid + "}" | clip