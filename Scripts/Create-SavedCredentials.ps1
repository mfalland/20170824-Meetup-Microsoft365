$username = #"<yourusername>@<yourtenant>.onmicrosoft.com"
$password = #"<YourPasswordHere>"
$secureStringPwd = $password | ConvertTo-SecureString -AsPlainText -Force 
$creds = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $secureStringPwd
$secureStringText = $secureStringPwd | ConvertFrom-SecureString 
Set-Content "C:\temp\ExportedPassword.txt" $secureStringText