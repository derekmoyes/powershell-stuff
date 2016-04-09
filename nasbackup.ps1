#+-------------------------------------------------------------------+
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |
#|{>/-------------------------------------------------------------\<}|
#|: | Author:  Aman Dhally & Derek Moyes                          | :|
#| :| Email:   amandhally@gmail.com & derek@softouchsytems.com
#|: | Purpose: Backup NAS to local drive, so that CrashPlan can
#|: |          store it off-site.
#| :| https://gallery.technet.microsoft.com/scriptcenter/Smart-Backup-using-d3447b19
#| :|
#|: |                 Date: 2016 Apr 8th
#|: |
#| :|     /^(o.o)^\    Version: 2.1 Better logging                |: |
#|{>\-------------------------------------------------------------/<}|
#| = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = : = |
#+-------------------------------------------------------------------+

#Backup variables
##############################################################################
 $date = Get-Date -Format yyyy.MMMM.d.HH.mm
 New-PSDrive -Name "Backup" -PSProvider Filesystem -Root "\\NAS-NAME\Share"
 $source = "backup:\"
 $destination = "C:\NASBackupDirectory\FullBackup"
 $path = test-Path $destination
 $backup_log = "$destination\backup_$date_log.txt"

#Email variables
##############################################################################
$From = "youremail@example.com"
$To = "youremail@example.com"
$Cc = "youremail@example.com"
$Subject = "Backup $date"
$Body = "Backup complete. Log file of backup $date is attached."
$Attachment = $backup_log
$SMTPServer = "smtp.gmail.com"
$SMTPPort = "587"
$credentials = new-object Management.Automation.PSCredential "youremail@example.com", ("YOURPASSWORD" | ConvertTo-SecureString -AsPlainText -Force)

# Start backup process
##############################################################################
 if ($path -eq $true) {
   cd backup:\
   Add-Content $backup_log "Backup starting $date `n"
   copy-Item  -verbose -Recurse $source -Destination $destination -force
   # I actually would prefer to use something like tee here... this seems cheesy... 
   Dir -Recurse $destination | out-File -Append $backup_log
   #Send an Email
   Send-MailMessage -From $From -to $To -Cc $cc -Subject $Subject `
   -Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
   -Credential $credentials -Attachments $Attachment
   $enddate = Get-Date -Format yyyy.MMMM.d.HH.mm
   Add-Content $backup_log "Backup complete $enddate `n"
   cd c:\
   Remove-PSDrive "Backup"
    } elseif ($path -eq $false) {
    write-Host "Backup directory doesn't exist."
    Remove-PSDrive "Backup"
 }
