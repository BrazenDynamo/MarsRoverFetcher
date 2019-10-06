function ParseDate {
  param([string]$dateString)
  
  try {
    return [DateTime]$dateString
  }
  catch {
    return
  }
}

function FetchRoverImages {
  param(
    [string]$dateListFileName,
    [System.Net.WebClient]$webClient,
    [PSCustomObject]$apiConfig
  ) 

  $apiBaseUrl = $apiConfig | Select-Object -ExpandProperty 'apiBaseUrl'
  $apiKey = $apiConfig | Select-Object -ExpandProperty 'apiKey'

  Get-Content $dateListFileName | ForEach-Object {
    $date = ParseDate $_
    if ($date) {
      $apiDate = $date.ToString('yyyy-MM-dd')
      Write-Output "Downloading pictures taken on $($date.ToString('MMM d, yyyy'))..."

      # Set up directory for pictures.
      $dirPath = ".\Pictures\$apiDate"
      if (!(Test-Path ".\Pictures\$apiDate")) {
        $dirPath = (New-Item -Path ".\Pictures\$apiDate" -ItemType Directory) 
      }

      # Get the picture list from NASA API and download each image.
      $url = "$($apiBaseUrl)?earth_date=$($apiDate)&api_key=$apiKey"
      Invoke-RestMethod -Uri "$url" |
      Select-Object -ExpandProperty 'photos' |
      ForEach-Object {
        $src = $_.'img_src'
        $fileName = $src -replace '.*/(.*)','$1'
        # Check if file has already been downloaded
        if (!(Test-Path "$dirPath\$fileName")) {
          $webClient.DownloadFile($src, "$($dirPath)\$($fileName)")
        }
      }
    } else {
      Write-Output "Skipping '$_': Invalid date."
    }
  }
  Write-Output 'Done.'
}
