#parse partner_link rejects for reprocessing
# Takes inputDirectory - path to a directory containing decrypted reject feeds
# Takes outputDirectory - directory to store file intended for reprocessing

## NOTE: file needs to be encrypted prior to uploading to ESL SFTP location
## File must be placed in ESL SFTP inbound directory associated with partner type, for example
## rejects containting linkedCardType = RBC need to be placed in partner/RBC/
## rejects containing linkedCardType = HBC need to be placed in partyner/HBC/
param (
    [string]$inputDirectory = "C:\Learning\poweshell\a1",
    [string]$outputDirectory = "C:\Learning\poweshell\o1"
)


# Output file name
$outputFileName = "Discretionary_rejects-20240911_$(Get-Date -Format 'yyyyMMddHHmmssfff')_$([System.Guid]::NewGuid().ToString("N").Substring(0, 8))_V2.csv"
$outputFilePath = Join-Path -Path $outputDirectory -ChildPath $outputFileName
# Loop through each file in the input directory
Get-ChildItem -Path $inputDirectory -Filter Discretionary_*.csv | ForEach-Object {
    $inputFilePath = $_.FullName
    #$outputFilePath = Join-Path -Path $outputDirectory -ChildPath ("REPROCESS_" + $_.BaseName + ".csv")

    Write-Host "Begin processing file: $inputFilePath"

    # Read the content of the input file
    $jsonContent = Get-Content -Path $inputFilePath -Encoding UTF8 |Where {$_ -like '*Request*'} |  ConvertFrom-csv

    # Skip the first line
    $jsonContent = $jsonContent | Select-Object -Skip 1
	

  Write-Host $jsonContent
    # Convert each renamed record to csv and save to the output file
    foreach ($record in $jsonContent) {

     Write-Host $record 

     $Request = Get-Value -string $record  -key 'Request'

       Write-Host "`r`n"
  
   Write-Host   $Request
     Write-Host "`r`n"
        #Write-Host "Processing record:"
        #$record | Format-List | Out-Host
		
  
# Convert JSON string to PowerShell object
$jsonObject =  $Request | ConvertFrom-Json

# To extract the value of 'LoyaltyId'
$loyaltyId = $jsonObject.LoyaltyId.S
Write-Host "LoyaltyId: $loyaltyId"



        $renamedJson = [PSCustomObject]@{
            "LoyaltyId" =   $jsonObject.LoyaltyId.S
			"PointAmount" =$jsonObject.PointAmount.N
			
        }



           Write-Host  $renamedJson 
        #Write-Host "Output record:"
        #$renamedJson | Format-List | Out-Host

        $renamedJson | ConvertTo-Json -Compress | Add-Content -Path $outputFilePath -Encoding UTF8
    }
    Write-Host "Processing complete for file: $inputFilePath"
}

# Function to extract value by key
function Get-Value {
    param(
        [string]$string,
        [string]$key
    )

    # Regex to find key-value pair
    $pattern = "$key=([^;]+)"
    if ($string -match $pattern) {
        return $matches[1]
    } else {
        return $null
    }
}

Write-Host "Conversion complete."
