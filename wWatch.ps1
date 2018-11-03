<#

wWatch by NGW
version 20170904.0

Process a URI and matching and non-matching search terms within the served object to determine torrent magnet link.

With the magnet link determined, generate a Pushover notification.

Schedule this to save yourself the trouble of refreshing browser search results as you await a new torrent.

Reference:

https://stackoverflow.com/questions/40599027/in-powershell-how-to-compare-invoke-webrequest-content-to-a-string

https://4sysops.com/archives/powershell-invoke-webrequest-parse-and-scrape-a-web-page/

https://stackoverflow.com/questions/29217557/find-specific-sentence-in-a-web-page-using-powershell

https://kencenerelli.wordpress.com/2014/12/18/powershell-invoke-webrequest-and-url-links/

https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-5.1

https://blogs.technet.microsoft.com/heyscriptingguy/2014/07/18/trim-your-strings-with-powershell/

https://pushover.net/faq

#>

# the URI to be parsed
$TgtUri = 'https://the.site/page.uri'

# text to look for
$TgtString = TargetString

# text or pattern to exclude
$TgtPatternNot = 'UnTargetString'

# Pushover URI
$POuri = "https://api.pushover.net/1/messages.json"

# get the page
$Page = Invoke-WebRequest -Uri $TgtUri

# get line with the magnet link that matches and un-matches the terms
$RawResult = $Page.Links | Select href | Select-String $TgtString | Select-String magnet | Select-String -Pattern $TgtPatternNot -NotMatch

# clean the leading @{href= characters from the result, customize as needed
$TrimResult = $RawResult.Line.Replace("@{href=","")

# clean the trailing } character from the result, customize as needed
$FinResult = $TrimResult.Trim("}")

# JSON parameters
$POargs = @{
  token = "abc123"
  user = "yourNameHere"
  message = "Hit for $TgtString"
  url = $FinResult
}

# Post the Pushover message
$POargs | Invoke-RestMethod -uri $POuri -Method Post
