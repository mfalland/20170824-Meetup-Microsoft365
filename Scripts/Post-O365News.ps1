# Install-Module Invoke-MicrosoftTeamsPost
. "C:\Program Files\WindowsPowerShell\Modules\Invoke-MicrosoftTeamsPost\Invoke-MicrosoftTeamsPost.ps1"
$username = "m.gessenay@celinehorst.onmicrosoft.com"
$pwdTxt = Get-Content "C:\temp\ExportedPassword.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd
$WebHookURL = "https://outlook.office.com/webhook/5b9f5a57-d88e-45ce-a741-95a9df07e5f1@b6fac97a-f6ff-472a-af3e-2222506907db/IncomingWebhook/7d21f12d35e140c28428180c9ce5619f/32e53a6f-cce1-4faa-85f7-f15705d9c397"

$jsonPayload = (@{userName=$cred.username;password=$cred.GetNetworkCredential().password;} | convertto-json).tostring()
$cookie = (invoke-restmethod -contenttype "application/json" -method Post -uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/Register" -body $jsonPayload).RegistrationCookie
$jsonPayload = (@{lastCookie=$cookie;locale="en-US";preferredEventTypes=@(2)} | convertto-json).tostring()
$events = (invoke-restmethod -contenttype "application/json" -method Post -uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/GetEvents" -body $jsonPayload)
$outfileName = "C:\temp\Message Center\" + $(get-date).ToString("yyyy-MM-dd") + "-Messages.csv"


$FormatedEvents = $events.Events | foreach {
                $row = new-object PSObject
                add-member -InputObject $row -MemberType NoteProperty -Name MessageID -Value $_.Id
                add-member -InputObject $row -MemberType NoteProperty -Name LastUpdatedTime -Value $_.LastUpdatedTime
                add-member -InputObject $row -MemberType NoteProperty -Name Urgency -Value $_.UrgencyLevel
                add-member -InputObject $row -MemberType NoteProperty -Name ActionType -Value $_.ActionType
                #add-member -InputObject $row -MemberType NoteProperty -Name Category -Value $_. Category
                add-member -InputObject $row -MemberType NoteProperty -Name Status -Value $_.Status  #is this always null?
                if ($_.ActionRequiredByDate -eq $null){
                    add-member -InputObject $row -MemberType NoteProperty -Name ActionRequiredBy -Value ""
                    } else {
                    add-member -InputObject $row -MemberType NoteProperty -Name ActionRequiredBy -Value $_.ActionRequiredByDate
                }

                add-member -InputObject $row -MemberType NoteProperty -Name Title -Value $_.Title
                add-member -InputObject $row -MemberType NoteProperty -Name Message -Value $_.Messages[0].MessageText
                add-member -InputObject $row -MemberType NoteProperty -Name AdditionalInfo -Value $_.ExternalLink
                add-member -InputObject $row -MemberType NoteProperty -Name GovernanceResponse -Value ""
                add-member -InputObject $row -MemberType NoteProperty -Name Notes -Value ""

                Write-Output $row
}
#Messages
#$FormatedEvents | Where-Object {$_.LastUpdatedTime -gt (get-date).AddHours(-1)} | %{Invoke-MicrosoftTeamsPost -WebHook $WebHookURL -Title $_.Title -Body $_.Message -ButtonUri $_.AdditionalInfo -ButtonTitle "More Info"} 
$FormatedEvents  | %{Invoke-MicrosoftTeamsPost -WebHook $WebHookUrl -Title $_.Title -Body $_.Message -ButtonUri $_.AdditionalInfo -ButtonTitle "More Info"} 

#| export-csv -LiteralPath $outfileName -NoTypeInformation -Delimiter ";"