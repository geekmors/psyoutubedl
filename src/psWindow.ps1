Add-Type -AssemblyName System.Windows.Forms

$font = 'Microsoft Sans Serif,13'
$ScriptPath = Split-Path $script:MyInvocation.MyCommand.Path
$videoSavePathroot = "$ENV:USERPROFILE\Videos"
$videoSaveFileName = "%(title)s.%(ext)s"
Write-output $ScriptPath

function changeSaveLocation {
    try {
        $selectedSaveLocation.ShowDialog()
        if (($selectedSaveLocation.SelectedPath).Length = 0   )
        {}
        else {
            $videoSavePathroot = $selectedSaveLocation.SelectedPath
       }
    }
    catch {
        
    }
    
}

function downloadVid{
    try{
        
        if($inputURL.text -eq ""){
            [System.windows.forms.messageBox]::show("Please enter a URL","warning")
        }
        elseif(($inputURL.text -as [System.URI]).AbsoluteURI){
            $videoURL = $inputURL.text
            $downldCmd = "$scriptPath\youtube-dl.exe"
            $downloadButton.Enabled=$false
            Start-Process $downldCmd -ArgumentList $videoURL,"-o -s","$videoSavePathroot\$videoSaveFileName" -Wait -NoNewWindow

            [System.windows.forms.messageBox]::show("Video has finished Downloading","Message")

            $inputURL.text = ""          
            $downloadButton.Enabled=$true
            
        }
        else{

            [System.windows.forms.messageBox]::show("Please enter a valid URL","warning")
        }
            
       
    }
    catch{

        [System.windows.forms.messageBox]::show("an error occurred","Error")
        
    }
    
}

$vidlabel = New-Object System.Windows.Forms.Label
$vidlabel.Text = "Enter youtube video url:"
$vidlabel.Font = $font
$vidlabel.Width= 300
$vidlabel.Height = 20
$vidlabel.AutoSize = $true
$vidlabel.Location = New-Object System.Drawing.Point(20,20)
$vidlabel.ForeColor = "#ffffff"

$inputURL = New-Object System.Windows.Forms.TextBox
$inputURL.Width = 400
$inputURL.Height = 10
$inputURL.Font = $font
$inputURL.Multiline = $false
$inputURL.Location = New-Object System.Drawing.Point(20,48)

$downloadButton = New-Object System.Windows.Forms.Button
$downloadButton.Text = "Start Download"
$downloadButton.Font = $font
$downloadButton.Width= 200
$downloadButton.Height = 35
$downloadButton.BackColor = "#CC5538"
$downloadButton.ForeColor = "#ffffff"
$downloadButton.Location = New-Object System.Drawing.Point(20,80)

##Folder dialog path
$filepathlabel = New-Object System.Windows.Forms.Label
$filepathlabel.Text  = "Video save location `n $videoSavePathroot"
$filepathlabel.Font = $font
$filepathlabel.Width= 300
$filepathlabel.Height = 40
$filepathlabel.AutoSize = $true
$filepathlabel.Location = New-Object System.Drawing.Point(20,120)
$filepathlabel.ForeColor = "#ffffff"

$filepathButton = New-Object System.Windows.Forms.Button
$filepathButton.Text = "change save location"
$filepathButton.Font = $font
$filepathButton.Width= 200
$filepathButton.Height = 35
$filepathButton.BackColor = "#CC5538"
$filepathButton.ForeColor = "#ffffff"
$filepathButton.Location = New-Object System.Drawing.Point(20,165)

$selectedSaveLocation = New-Object System.Windows.Forms.FolderBrowserDialog
$selectedSaveLocation.ShowNewFolderButton = $true

$MainWindow = New-Object System.Windows.Forms.Form
$MainWindow.ClientSize = '500,250'
$MainWindow.controls.AddRange(@($vidlabel,$inputURL,$downloadButton,$filepathlabel,$filepathButton))
$MainWindow.Text = "Lazy Stuff"
$MainWindow.BackColor = "#191919"
$MainWindow.MaximumSize = '500,250'
$MainWindow.MinimumSize = '500,250'
$MainWindow.StartPosition = 1
$MainWindow.TopMost = $true

$filepathButton.Add_Click({ changeSaveLocation
$filepathlabel.Text = $selectedSaveLocation.SelectedPath } )
$downloadButton.Add_Click({ downloadVid })

[void]$MainWindow.ShowDialog()