## We create TXT file for each user with less the 11 days left to change password, and only himself or domain admin can read the TXT! ##
## Also can have a nice excel with all users details. ##

## Setting ExpiredUsers and getting information from AD ##
Import-Module ActiveDirectory
$MaxPwdAge = (Get-ADDefaultDomainPasswordPolicy).MaxPasswordAge.Days
$expiredDate = (Get-Date).addDays(-$MaxPwdAge)

## You can can get also SAMP and not only UPN by adding samAccountName ##
$ExpiredUsers = Get-ADUser -Filter {(PasswordLastSet -gt $expiredDate) -and (PasswordNeverExpires -eq $false) -and (Enabled -eq $true)} -Properties PasswordNeverExpires, PasswordLastSet, Mail | select UserPrincipalName, @{name = "DaysUntilExpired"; Expression = {$_.PasswordLastSet - $ExpiredDate | select -ExpandProperty Days}} | Sort-Object PasswordLastSet

## Exporting information into CSV, you can watch the status of all your users remaining time to change password ##
$ExpiredUsers | Export-Csv Z:\daniboy.csv


## Making a loop that will show me only users with 10 days left to change passwords ##
for($i=0;$i -lt $ExpiredUsers.count;$i++){
## Only 10 days left will be shown ##
if($ExpiredUsers.DaysUntilExpired[$i] -lt 11){
Function GetFileName([ref]$fileName)
{
$invalidChars = [io.path]::GetInvalidFileNamechars()
 $date = $ExpiredUsers.UserPrincipalName[$i]
$fileName.value = ($date.ToString() -replace "[$invalidChars]","-") + ".txt"
} 
$fileName = $null
GetFileName([ref]$fileName)

## makes $filename=USER@DOMAIN.txt ##
new-item -path X:\testing\ -name $filename -itemtype file
## Write remaining days to change password and whatever we would like the user to know ##
Set-Content X:\testing\$fileName ("Days Left To Change Password:" + " " + $ExpiredUsers.DaysUntilExpired[$i] + " "+ "If you need any help please contact helpdesk@DOMAIN or " )

## NTFS- We create a folder with only ADMIN permission, for example X:\testing ##
## Now we set for each text file only the user himself a modify permission ##
$b=Get-Item X:\testing\"$filename"
$identity=$ExpiredUsers.UserPrincipalName[$i]
$rights      = 'Modify'
$type        = 'Allow'
# create the new AccessRule
$rule = [System.Security.AccessControl.FileSystemAccessRule]::new($identity, $rights, $type)
$Acl = Get-Acl -Path $b
$Acl.AddAccessRule($rule)
Set-Acl -Path $b -ACLObject $Acl
}
}

 
