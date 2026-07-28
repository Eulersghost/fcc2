#display a list of running processes
Get-Process

#test the connection of google.com
Test-Connection

#Display a list of all command types 
Get-Command -ParameterName "cmdlet" 
Get-Command -Type cmdlet

#Command to list all of the Aliases
Get-Alias

#Make a new alias that maps 'ntstat over to Netstat
Set-Alias -Name ntst -Value Netstat

#List processes that start with the letter p and include the wildcard flag, I used the gps alias but it would properly be
Get-Process -Name p*

#Use New-Item to create two new directories
New-Item -ItemType "Directory" -Name "MyFolder1"

#looks like I was incorrect I needed to make sure that these don't have any quotation marks 
New-Item -ItemType Directory -Name MyFolder1, MyFolder2