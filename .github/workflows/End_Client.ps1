## End client task, we just need to set taskschlder for them to open powershell, remember only domain admin and the user himself can access his txt file ##
## For Task Scheduler ##
## C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass X:\End_Client.ps1 ##

$a=whoami /upn
$b="I:\testing\" + $a + ".txt"
if(dir $b){
$c=Get-Content -Path $b
## Set how long should the message exist ##
msg * /time:999999 $c
}
