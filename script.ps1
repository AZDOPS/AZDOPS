$PAT = 'inxzexkq64o5aezjvesay4zlivdb4ij5mjj7w7c7m44xpqg6gw4q'
Import-Module .\Source\AZDevOPS.psd1 -Force
Connect-AZDevOPS -Username 'emanuel.palm.gg@gmail.com' -PersonalAccessToken $PAT -Organization pipehow -Default
Start-AZDevOPSPipeline -Name 'PipeHow' -Project 'PipeHow' -Organization 'pipehow' -Branch 'master'