# Mars Rover Image Downloader
This is a simple Powershell script for downloading all of the pictures from NASA's Mars Rover project on a given date.

## Usage
1. Change the dates found in `dates.txt`.
2. Run `main.ps1`.

## Testing
Run `Invoke-Pester .\tests.ps1` when in the project directory.
*Note: The tests were written for Pester 3.4. To run in Pester 4 or later, the parameters for the `Should` statements should be prepended with a `-`.*