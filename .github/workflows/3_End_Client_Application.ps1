## Saving this file as ps1 and setting default app for ps1 as powershell ##

$a=whoami /upn
$b="X:\testing\" + $a + ".txt"
if(dir $b){
$c=Get-Content -Path $b
msg * /time:999999 $c
}
Else{msg * /time:999999 "You don't have to change the password in the upcoming 10 days"}
