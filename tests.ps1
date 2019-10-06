. .\functions.ps1

Describe 'ParseDate' {
  Context "Parsing valid dates" {
    It 'returns a DateTime object' -TestCases @(
      @{ dateString = '02/27/17' }
      @{ dateString = 'June 2, 2018' }
      @{ dateString = 'Jul-13-2016' }
    ) {
      param ($dateString)
      $date = ParseDate $dateString
      $date | Should BeOfType DateTime
    }
  }

  Context "Parsing invalid dates" {
    It 'returns null' -TestCases @(
      @{ dateString = 'April 31, 2018' }
      @{ dateString = '02/30/2015' }
    ) {
      param ($dateString)
      $date = ParseDate $dateString
      $date | Should BeNullOrEmpty
    }
  }
}

Describe 'FetchRoverImages' {
  It 'creates a directory matching all dates in the date file and uses WebClient to download file all images returned' {
    # Set-up
    Mock Get-Content { return '02/27/17' }
    Mock ParseDate { return [DateTime]'02/27/17' }
    Mock Invoke-RestMethod {
      [PSCustomObject[]]$photos = @()
      $photos += [PSCustomObject]@{ img_src = 'https://example.com/a.jpg' }
      $photos += [PSCustomObject]@{ img_src = 'https://example.com/b.jpg' }
      return [PSCustomObject]@{ 'photos' = $photos }
    }
    Class MockWebClient : System.Net.WebClient {
      DownloadFile ([string] $src, [string] $fileName) {
        Out-File -FilePath $fileName
      }
    }

    $mockWebClient = New-Object MockWebClient
    $mockApiConfig = [PSCustomObject]@{
      'apiBaseUrl' = 'http://api.example.com/';
      'apiKey' = 'demo_api'
    }
    FetchRoverImages 'fakefilename.txt' $mockWebClient $mockApiConfig
    '.\Pictures\2017-02-27\a.jpg' | Should Exist
    '.\Pictures\2017-02-27\b.jpg' | Should Exist

    # Teardown
    Remove-Item -Recurse .\Pictures
  }
}