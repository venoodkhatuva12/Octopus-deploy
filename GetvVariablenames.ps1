##Config
$OctopusAPIkey = "API-ABC"   

$OctopusURL = "https://octopus.com"  

$header = @{ "X-Octopus-ApiKey" = $octopusAPIKey }

$bucket = Get-Content -Path C:\server.txt

$Result = ForEach ($variableSetName in $bucket) {

##Process
$VariableSet = (Invoke-WebRequest "$OctopusURL/api/libraryvariablesets?contentType=Variables" -Headers $header).content | ConvertFrom-Json | select -ExpandProperty Items | ?{$_.name -eq $variableSetName}  

$variableSetName

$variables = (Invoke-WebRequest "$OctopusURL/$($VariableSet.Links.Variables)" -Headers $header).content | ConvertFrom-Json | select -ExpandProperty Variables | select -ExpandProperty Name

$variables 

}
$Result | Out-File C:\outfile.txt

$input = Get-Content "C:\outfile.txt"
$data = $input[1..($input.Length - 1)]

$maxLength = 0

$objects = ForEach($record in $data) {
    $split = $record -split "\s{2,}|\t+"
    If($split.Length -gt $maxLength){
        $maxLength = $split.Length
    }
    $props = @{}
    For($i=0; $i -lt $split.Length; $i++) {
        $props.Add([String]($i+1),$split[$i])
    }
    New-Object -TypeName PSObject -Property $props
}

$headers = [String[]](1..$maxLength)

$objects | 
Select-Object $headers | 
Export-Csv -Path C:\test.csv -NoTypeInformation

