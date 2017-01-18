# General Authentication Service - GAS 

Check the listed components above, and their readme for specific notes, instructions.

# General instructions for debugging
You can create a fully functional debug environment in Eclipse using any of your chosen application server, where you can add any of your exisiting installations, too. Make sure you set your file permission rights permissively, otherwise you will not be able start up the application server properly, because Eclipse doesn't run the applicaton servers as the root user. The most important thing, however, is you need to copy the hibernate descriptor file for macOS under the Eclipse, somewhere like this (pls watch the corresponding error message in the log for Windows, or other systems):

- /Applications/Eclipse.app/Contents/Eclipse

- Please be so kind and use sqlitebrowser to verify what the iOS will hold in cache. It is crucial when you are interested in, and want to understand, what really happens under the hood, especially for the login through the webView. (You can use sqlitebrowser because the app itself use sqlite for this, for example when you use the iOS simulator...)

- Make sure you have 'marked' your custom certificates "Always trusted", that you imported on the server (into Keychain Access on macOS, for example, and so on with different operating systems systems). If you have still SSL connection issues, install the CA on the device, too. For me it was not necessary, however.

# Swift
- updates will be coming soon to Swift 3.0!;)

# Contacts:
- email: igeorge1982@gmail.com, igeorge1982@hotmail.com, igeorge1982@yahoo.com
- mobile: +36304088520
