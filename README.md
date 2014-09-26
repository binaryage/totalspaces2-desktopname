totalspaces2-desktopname
========================

TotalSpaces2 plugin to display the name of the current space in the menu bar

This is the simplest possible implementation, and shows how to use the TotalSpaces2
API from Swift.

_Only the name of the main screen is displayed._ Secondary screens will not display
their correct name in this version.

_Technical note:_ v2.2.6 of TotalSpaces2 does not call the space changed callback when 
changing space via the overview grid and in certain other circumstances.
This will be fixed in later versions.

The watchdog function gets around this problem. The watchdog is also necessary as
it will trigger a re-connection to TotalSpaces2 if it has restarted or some
connection error occurred.
