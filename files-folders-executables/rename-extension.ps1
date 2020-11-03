# one-liner

Get-ChildItem *.failed | Rename-Item -NewName { $_.name -Replace '\.failed$','' }



# DONE get list of extensions in dir

$extensions = @()

$directory = Get-ChildItem -Path 'D:\csv\archive'

foreach ( $file in $directory ) {
    if (!($extensions -contains $file.Extension)) {
        $extensions += $file.Extension
    }
}

$extensions

#####################################

$files = Get-ChildItem -Path 'D:\csv\archive'

$extension = 'csv'

if (!($extension.StartsWith('.'))) {
    $extension = '.' + $extension
}


foreach ( $file in $files ) {

    $old = $file.PSChildName

    foreach ($ext in $extensions) {
        $old = $file.Trim($ext)
        $old
        'within : {0}, ext : {1}' -f $old , $ext
    }

    '{0}' -f $old
}

Read-Host
{    
    #    $file.PSChildName.Replace($file.extension, $extension)
    $startindex = ($file.PSChildName.Replace($file.extension, $extension)).IndexOf('csv')
    $endindex = ($file.PSChildName.Replace($file.extension, $extension)).LastIndexOf('csv')

    'start {0}, end {1}' -f $startindex, $endindex
    [int]$diff = ($endindex - $startindex)
    'Diff {0}' -f $diff

    if ($diff -eq 0) {
        Rename-Item -Path $file.FullName -NewName $file.FullName.Replace($file.extension, $extension)
        'file has extension {0} already' -f $extension
        'renaming anyway' -f $file
    }
    else {
        'trim end by {0} chars' -f $diff
        #$ext_replace = 
        $file.PSChildName.Replace($file.extension, $extension).TrimEnd($extension)
        #$ext_trim = $ext_replace.TrimEnd($diff)
        #'furure file name: {0}' -f $ext_trim
    }

    #   Rename-Item -Path $file -NewName
    # Rename-ItemProperty -Name $file -NewName
}