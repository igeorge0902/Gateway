WWW component for the Gateway
----

Notes on request header transformation: 
- the WWW app is split into two parts due to the fact that I have implemented the requesr header transformation in 1.3.x version of angular, but I plan to upgrade it to newer version when I'll time for it

Features:
- login and registration is fully tested on WWW
- for mobile login and registration is fully tested, except for the unimplemented registration through mobile webView

Configuration:
- for registration, if activation is needed the status code is set to 300, so the http interceptors has to be listening to the same status code, therefore.
- for setting the vouchers you will need to use numbers when setting the voucher and the flags in the dB

Appology for the "place-holder" files!
