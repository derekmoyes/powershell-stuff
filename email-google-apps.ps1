# Fill in these variables
##############################################################################
$From = "youremail@example.com"
$To = "youremail@example.com"
$Cc = "youremail@example.com"
$Attachment = "C:\important_log_file.log"
$Subject = "Test Subject"
$Body = "Test Success!"
$SMTPServer = "smtp.gmail.com" # works with Google Apps
$SMTPPort = "587"
$credentials = new-object Management.Automation.PSCredential "youremail@example.com", ("YOURPASSWORD" | ConvertTo-SecureString -AsPlainText -Force)

# Actually do the work
##############################################################################
Send-MailMessage -From $From -to $To -Subject $Subject `
-Body $Body -SmtpServer $SMTPServer -port $SMTPPort -UseSsl `
-Credential $credentials -Attachments $Attachment

# Pause at the end
##############################################################################
Write-Host "Press any key to quit ..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
