
#####Define Variables#####
$EmailFrom = "xxxi@xxx"
$toaddress =  Read-Host -Prompt 'Input Your Email Address'
$Subject = Read-Host -Prompt 'Enter the users who Inventory this is For'
$attachment = "c:\temp\asset.txt"
##########Remove File if it exists###############
Remove-Item c:\temp\asset.txt
##########Asset Inventory Script###############
whoami |  Out-File -Append -FilePath c:\temp\asset.txt
hostname |  Out-File -Append -FilePath  c:\temp\asset.txt 
"Computer Model" | Out-File  -Append -FilePath c:\temp\asset.txt
wmic csproduct get name  | Out-File -Append -FilePath  c:\temp\asset.txt
"Computer Serial Number" | Out-File  -Append -FilePath c:\temp\asset.txt
get-ciminstance win32_bios | format-list serialnumber, Manufacture  | Out-File -Append -FilePath c:\temp\asset.txt
"Surface Dock Information" | Out-File  -Append -FilePath c:\temp\asset.txt
get-CimInstance -Namespace "root/Surface" -Class "SurfaceDockComponent" |  Where-Object ComponentName -like Microcontroller  | Format-List DeviceName,DockSerialNumber,Version |  Out-File -Append -FilePath c:\temp\asset.txt
"Monitor Information" | Out-File  -Append -FilePath c:\temp\asset.txt
function Decode {
    If ($args[0] -is [System.Array]) {
        [System.Text.Encoding]::ASCII.GetString($args[0])
    }
    Else {
        "Not Found"
    }
}

ForEach ($Monitor in Get-WmiObject WmiMonitorID -Namespace root\wmi) {  
    $Manufacturer = Decode $Monitor.ManufacturerName -notmatch 0
    $Name = Decode $Monitor.UserFriendlyName -notmatch 0
    $Serial = Decode $Monitor.SerialNumberID -notmatch 0

	
    echo "Manufacturer: $Manufacturer`nName: $Name`nSerial Number: $Serial `n" | Out-File -Append -FilePath c:\temp\asset.txt

}
  Out-File -Append -FilePath c:\temp\asset.txt
"WebCam Information" | Out-File  -Append -FilePath c:\temp\asset.txt
Get-CimInstance Win32_PnPEntity | where name -match 'Lenovo 500 RGB Camera' | Format-List Name | Out-File -Append -FilePath c:\temp\asset.txt
Get-CimInstance Win32_PnPEntity | where name -match 'Logitech' | Format-List Name | Out-File -Append -FilePath c:\temp\asset.txt
Get-CimInstance Win32_PnPEntity | where name -match 'Logi'| Format-List Name | Out-File -Append -FilePath c:\temp\asset.txt


#########Send Email Messager#########################


Send-MailMessage -From 'xx Asset Inventory <xxx@xx.com>' -To $toaddress -Subject $Subject -Body "Automated Powershell Script of asset Inventory Email"  -Attachments $attachment -SmtpServer 'xxx.xxx.com'

