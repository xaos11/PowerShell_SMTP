# PowerShell_SMTP
PowerShell scripts to scrape SMTP logs for IP addresses to identify authorized senders. This is useful for locking down the Microsoft Exchange "receive" connector, if it is left wide open (which is vulnerable to spoofing). This process would produce a list of IP addresses that have sent through the receive connector (SMTP logging will need to be turned on in Exchange). The IP addresses in this list would be sorted through, and legitimate senders would be added to the list of IPs permitted to send through the Exchange receive connector.


Place all log files in C:\logs\ on a workstation
Convert file names to date modified for easy reading

Get-ChildItem c:\logs\*.log | Rename-Item -newname {$_.LastWriteTime.toString("yyyy.MM.dd.HH.mm") + ".log"} 
 
 
Parse the log files in powershell (extract IP addresses)


new-item -itemtype directory c:\logs\parsed
Get-ChildItem c:\logs\*.log |
Foreach {
$input_path = "$_"
$output_file = "c:\logs\parsed\$_"
new-item -ItemType file $output_file
$regex = ‘\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b’
select-string -Path $input_path -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } > $output_file
} 
 
 
Dedupe the IP addresses


new-item -itemtype directory c:\logs\dedupe
Get-ChildItem c:\logs\parsed\*.log |
Foreach {
$set = @{}
$name = $_.Name
$fullname = "c:\logs\dedupe\" + $name
Get-Content $_ | %{
    if (!$set.Contains($_)) {
        $set.Add($_, $null)
        $_
    }
} | Set-Content $fullname
 
} 
 
 
Copy deduped content into one log file for easy reading


$output_file = "loglog.txt"
Get-ChildItem c:\logs\dedupe\*.log |
Foreach { 
 
$_.name >> $output_file
get-content $_ >> $output_file
} 
