# Derek Moyes <derek@softouchsystems.com>
# Thanks to Aman Dhally <amandhally@gmail.com> this script is based on original.
# https://gallery.technet.microsoft.com/scriptcenter/Smart-Backup-using-d3447b19
#
# Robocopy
# https://social.technet.microsoft.com/Forums/windowsserver/en-US/7b5af033-7988-443d-aa00-aef7780c57cc/copy-only-new-and-modified-files?forum=winserverpowershell
#
# Purpose: Backup NAS to local drive, so that CrashPlan can
#          store it off-site.
#
# Date: 2016 Apr 10th
# Version 3.0 Switch to RoboCopy
# Version 2.1 Don't email logfile, it's too large
# Version 2.0 Lots of testing.

# Backup variables
##############################################################################
 $StartDate = Get-Date -Format "yyyyMMMddHHmm"
 New-PSDrive -Name "Backup" -PSProvider Filesystem -Root "\\NAS\Shared"
 $source = "backup:\"
 $destination = "C:\NASBackup\FullBackup\Shared"
 $path = test-Path $destination
 $backuplog = ".\BackupLogs\backup$StartDate.log"

# Email variables
##############################################################################
$From = "fromgmail@gmail.com"
$To = "youremail@example.com"
$Cc = "anotheremail@example.com"
$Attachment = $backuplog
$Subject = "Backup $StartDate"
# $Body = "Backup $StartDate complete. Log file is located at $backuplog."
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$credentials = new-object Management.Automation.PSCredential "fromgmail@gmail.com", ("YOURPASSWORD" | ConvertTo-SecureString -AsPlainText -Force)

# Start backup process
 if ($path -eq $true) {
   cd backup:\
   robocopy . $destination /ETA /LOG+:$backuplog /TEE /MT /MIR
   $FinDate = Get-Date -Format "yyyyMMMddHHmm"
# Moved body down here, so I could use FinDate.
   $Body = "Backup complete at $FinDate.`nLog file is located at $backuplog."
# Send an Email to User
   Send-MailMessage -From $From -To $To -Cc $Cc -Subject $Subject `
   -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
   -Credential $credentials
# Log file is too large, email timed out. :-(
   # -Attachments $Attachment
   cd c:\
   Remove-PSDrive "Backup"
   write-Host "Date: $StartDate, Complete: $FinDate"
   write-Host "Backup log: $backuplog"
   write-Host "Source: $source, Destination: $destination"
   write-Host "Email hopefully sent to $To (and $Cc)"
    } elseif ($path -eq $false) {
    write-Host "Backup directory $destination doesn't exist."
    Remove-PSDrive "Backup"
 }
 # Comment out the next two lines, once you automate this.
 Write-Host "Press any key to quit ..."
 $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
