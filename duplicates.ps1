$set = @{}
Get-Content log.txt | %{
    if (!$set.Contains($_)) {
        $set.Add($_, $null)
        $_
    }
} | Set-Content filtered_log.txt