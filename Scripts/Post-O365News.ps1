. "C:\Program Files\WindowsPowerShell\Modules\Invoke-MicrosoftTeamsPost\Invoke-MicrosoftTeamsPost.ps1"
$username = "matthias.gessenay@corporatesoftware.ch"
$pwdTxt = Get-Content "C:\temp\ExportedPassword.txt"
$securePwd = $pwdTxt | ConvertTo-SecureString 
$cred = New-Object System.Management.Automation.PSCredential -ArgumentList $username, $securePwd

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
$FormatedEvents | Where-Object {$_.LastUpdatedTime -gt (get-date).AddHours(-1)} | %{Invoke-MicrosoftTeamsPost -WebHook https://outlook.office.com/webhook/4bace570-8a26-47fd-8a69-dd204d24dcc7@2bbd7e41-02c9-4b4e-8168-339f900c4319/IncomingWebhook/38680f34981d4d9a9f2e1d1b65428d3f/7dfbd213-892d-4bd6-bf08-8d6c60d556ed -Title $_.Title -Body $_.Message -ButtonUri $_.AdditionalInfo -ButtonTitle "More Info"} 
#$FormatedEvents  | %{Invoke-MicrosoftTeamsPost -WebHook https://outlook.office.com/webhook/4bace570-8a26-47fd-8a69-dd204d24dcc7@2bbd7e41-02c9-4b4e-8168-339f900c4319/IncomingWebhook/38680f34981d4d9a9f2e1d1b65428d3f/7dfbd213-892d-4bd6-bf08-8d6c60d556ed -Title $_.Title -Body $_.Message -ButtonUri $_.AdditionalInfo -ButtonTitle "More Info"} 

$jsonPayload = (@{userName=$cred.username;password=$cred.GetNetworkCredential().password;} | convertto-json).tostring()
$cookie = (invoke-restmethod -contenttype "application/json" -method Post -uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/Register" -body $jsonPayload).RegistrationCookie
$jsonPayload = (@{lastCookie=$cookie;locale="en-US";preferredEventTypes=@(0)} | convertto-json).tostring()
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
#Incidents
$FormatedEvents | Where-Object {$_.LastUpdatedTime -gt (get-date).AddHours(-1)} | %{Invoke-MicrosoftTeamsPost -WebHook https://outlook.office.com/webhook/4bace570-8a26-47fd-8a69-dd204d24dcc7@2bbd7e41-02c9-4b4e-8168-339f900c4319/IncomingWebhook/6c1b36ced94a4e63b2b379f70fec76c0/7dfbd213-892d-4bd6-bf08-8d6c60d556ed  -Title $_.Title -Body $_.Message -ButtonUri ("https://portal.office.com/AdminPortal/home?switchtomodern=true#/MessageCenter?id=" + $_.MessageID) -ButtonTitle "View in Message Center"}
#$FormatedEvents | %{Invoke-MicrosoftTeamsPost -WebHook https://outlook.office.com/webhook/4bace570-8a26-47fd-8a69-dd204d24dcc7@2bbd7e41-02c9-4b4e-8168-339f900c4319/IncomingWebhook/6c1b36ced94a4e63b2b379f70fec76c0/7dfbd213-892d-4bd6-bf08-8d6c60d556ed  -Title $_.Title -Body $_.Message -ButtonUri ("https://portal.office.com/AdminPortal/home?switchtomodern=true#/MessageCenter?id=" + $_.MessageID) -ButtonTitle "View in Message Center"}
Remove-Variable events

$jsonPayload = (@{userName=$cred.username;password=$cred.GetNetworkCredential().password;} | convertto-json).tostring()
$cookie = (invoke-restmethod -contenttype "application/json" -method Post -uri "https://api.admin.microsoftonline.com/shdtenantcommunications.svc/Register" -body $jsonPayload).RegistrationCookie
$jsonPayload = (@{lastCookie=$cookie;locale="en-US";preferredEventTypes=@(1)} | convertto-json).tostring()
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
# Planned Maintenance
$FormatedEvents | Where-Object {$_.LastUpdatedTime -gt (get-date).AddHours(-1)} | %{Invoke-MicrosoftTeamsPost -WebHook https://outlook.office.com/webhook/4bace570-8a26-47fd-8a69-dd204d24dcc7@2bbd7e41-02c9-4b4e-8168-339f900c4319/IncomingWebhook/54df295a803f4f0792b1c101bbdf4040/7dfbd213-892d-4bd6-bf08-8d6c60d556ed  -Title $_.Title -Body $_.Message -ButtonUri ("https://portal.office.com/AdminPortal/home?switchtomodern=true#/MessageCenter?id=" + $_.MessageID) -ButtonTitle "View in MessageCenter"}
#$FormatedEvents |  %{Invoke-MicrosoftTeamsPost -WebHook https://outlook.office.com/webhook/4bace570-8a26-47fd-8a69-dd204d24dcc7@2bbd7e41-02c9-4b4e-8168-339f900c4319/IncomingWebhook/54df295a803f4f0792b1c101bbdf4040/7dfbd213-892d-4bd6-bf08-8d6c60d556ed  -Title $_.Title -Body $_.Message -ButtonUri ("https://portal.office.com/AdminPortal/home?switchtomodern=true#/MessageCenter?id=" + $_.MessageID) -ButtonTitle "View in Message Center"}
Remove-Variable events

#| export-csv -LiteralPath $outfileName -NoTypeInformation -Delimiter ";"