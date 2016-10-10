WWW component for the Gateway
----

Notes on request header transformation: 
- the WWW app is split into two parts due to the fact that I have implemented the requesr header transformation in 1.3.x version of angular, but I plan to upgrade it to newer version when I'll time for it

Features:
- login and registration is fully tested on WWW
- for mobile login and registration is fully tested, except for the unimplemented registration through mobile webView
- to check the validation workflow as to how the password, username will be hashed, and how the transformation happens you can use javascript alert or some analytics tool that you can embed into the web app.


Configuration:
- for registration, if activation is needed the status code is set to 300, so the http interceptors has to be listening to the same status code, therefore.
- for setting the vouchers you will need to use numbers when setting the voucher and the flags in the dB

Usefull links:
----
hmac auth implementation was based on the following github repo:
- https://github.com/Monofraps/angular-node-hmac-example

Appology for the "place-holder" files!
