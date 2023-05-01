# HHiTunesRSSFeedChecker

**This code was written specifically as a favor to Apple's affiliate program engineers in order for them to monitor their music new release affiliate RSS feeds.  The reason I donated this code to them was because they actually customized heavy metal new release feeds for me for Heavy Headlines.**

## Usage:

1. Open the workspace in Xcode
2. Run in your iOS Simulator of choice
3. Press one of the buttons to begin checking the feeds

## Modes

Simultaneous Mode loops through all country codes for all three feed types at once.  This often results in a lot of timeouts due to what I guess is probably throttling based on IP address.


Batch mode waits for each feed type to run through all country codes before the next feed type check is run.  This usually produces better results.
