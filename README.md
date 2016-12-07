# General Authentication Service - GAS 

Check the listed components above, and their readme for specific notes, instructions.

# General instructions for debugging
You can create a fully functional debug environment in Eclipse using any of your chosen application server, where you can add any of your exisiting installations, too. Make sure you set your file permission rights permissively, otherwise you will not be able start up the application server properly, because Eclipse doesn't run the applicaton servers as the root user. The most important thing, however, is you need to copy the hibernate descriptor file for macOS under the Eclipse, somewhere like this (pls watch the corresponding error message in the log for Windows, or other systems):

- /Applications/Eclipse.app/Contents/Eclipse
