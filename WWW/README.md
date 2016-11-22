WWW component for the Gateway

Notes on request header transformation: 
- the WWW app is split into two parts due to the fact that I have implemented the requesr header transformation in 1.3.x version of angular, but I plan to upgrade it to newer version when I'll time for it
- the js/AesUtil.js works with at least Angular Js 1.4.x

# Usage of the Aesutil
- with the same identical setup it is interoperable with the Java and Swift implementation:

@Swift:
- Gateway/iOS/SwiftLoginScreen/ciphertext.swift

@Java:
- Gateway/API/src/main/java/com/jeet/utils/AesUtil.java
and
- Gateway/dalogin/src/main/java/com/dalogin/utils/AesUtil.java


```javascript
function userApi($http) {
    return {
        getUser: function () {
            var url = '/login/admin';
            
            var iterationCount = 1000;
var keySize = 128;
var plaintext = "G";
var passphrase = "SecretPassphrase";
var iv = "F27D5C9927726BCEFE7510B1BDD3D137";
var salt = "3FF2EC019C627B945225DEBAD71A01B6985FE84C95A70EB132882F88C0A59A55";

            var aesUtil = new AesUtil(keySize, iterationCount);
            var ciphertext = aesUtil.encrypt(salt, iv, passphrase, plaintext);
            
            var config = {headers: {
                    'Ciphertext': ciphertext
                }
                    };
            return $http.get(url, config);
        }
    };
}
```

Features:
- login and registration is tested on WWW
- for mobile only login is tested

Configuration:
- for registration, if activation is needed the status code is set to 300, so the http interceptors has to be listening to the same status code, therefore.
- for setting the vouchers you will need to use numbers when setting the voucher and the flags in the dB

Appology for the "place-holder" files!
