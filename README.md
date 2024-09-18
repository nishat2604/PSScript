This  page had been  created for various powershell scripts 
a) When you  have data from  DynamoDB  in  NJSON format and your requirement to filter particular column  than  usethe above scripts for your genration oif data  

Example # Your JSON string
$jsonString = '{
    "LoyaltyId": {"S": "706932006XXXXXX14"},
    "RequestId": {"S": "da45b732-f45c-4713-90dd-d1991ceca529"},
    "BusinessUnit": {"S": "ABCBBX"},
    "ProcessingID": {"S": "File.csv"},
    "AddToBalance": {"BOOL": true},
    "PointAmount": {"N": "1500"},
    "ReasonCode": {"S": "NEWSLETTER1"},
    "RequestType": {"S": "DISCRETIONARYADJUST"}
}'

# Convert JSON string to PowerShell object
$jsonObject = $jsonString | ConvertFrom-Json

# To extract the value of 'LoyaltyId'
$loyaltyId = $jsonObject.LoyaltyId.S
Write-Host "LoyaltyId: $loyaltyId"

# To extract the value of 'ProcessingID'
$processingId = $jsonObject.ProcessingID.S
Write-Host "ProcessingID: $processingId"

# Extract Boolean 'AddToBalance'
$addToBalance = $jsonObject.AddToBalance.BOOL
Write-Host "AddToBalance: $addToBalance"

# Extract Numeric 'PointAmount'
$pointAmount = [int]$jsonObject.PointAmount.N
Write-Host "PointAmount: $pointAmount"

# Extract 'ReasonCode'
$reasonCode = $jsonObject.ReasonCode.S
Write-Host "ReasonCode: $reasonCode"
