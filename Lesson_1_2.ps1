#Asignment answers

Update-Help

Out-File
#there are 9 cmdlets
Set-PSBreakpoint

#create
New-Alias
#modify
Set-Alias
#export
Export-Alias
#import
Import-Alias

Import-Alias | Output-File key.Get-History


#for keyboard history use the alias 'h' or  use 'history', Get-Histroy and then pipe it to Out-File 
Get-History | Out-File keyboard2.txt

Get-PSHostProcessInfo | ProcessName *

Get-Process -Name #got by a specific list of process name   

Get-Process -Name -IncludeUserName #some name of the PRocessNAme#

Invoke-Command #runs on local and remote session

$PSDefaultParameterValues['Out-File:Width'] = 2000 # this has to be run before invoking Out-File normally the -Width 

-NoClobber # when using Out-File this prevents a current named file from being overwritten

Get-Alias #get's the list of aliases

#this is something that I'm writing right now in powershell 