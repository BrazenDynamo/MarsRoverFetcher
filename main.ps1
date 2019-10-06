. .\functions.ps1

# Download Mars rover images through NASA API.
FetchRoverImages `
  'dates.txt' `
  (New-Object System.Net.WebClient) `
  (Get-Content -Raw -Path .\env.json | ConvertFrom-Json)