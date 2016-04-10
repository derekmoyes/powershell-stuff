# Fill in these variables
##############################################################################
$From = "fromgmail@gmail.com"
$To = "youremail@example.com"
$Cc = "anotheremail@example.com"
# Remember if the attachment is too large, the email send will time out. 
$Attachment = "C:\important_log_file.log"
$Subject = "Test Subject"
$Body = "Test Success!"
$SMTPServer = "smtp.gmail.com" # works with Google Apps
$SMTPPort = "587"
$credentials = new-object Management.Automation.PSCredential "fromgmail@gmail.com", ("YOURPASSWORD" | ConvertTo-SecureString -AsPlainText -Force)

# Actually do the work
##############################################################################
Send-MailMessage -From $From -To $To -Cc $Cc -Subject $Subject `
-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
-Credential $credentials -Attachments $Attachment

# Pause at the end
##############################################################################
Write-Host "Press any key to quit ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
