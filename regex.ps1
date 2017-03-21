$input_path = ‘c:\ps\ip_addresses.txt’
$output_file = ‘c:\ps\extracted_ip_addresses.txt’
$regex = ‘\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b’
select-string -Path $input_path -Pattern $regex -AllMatches | % { $_.Matches } | % { $_.Value } > $output_file