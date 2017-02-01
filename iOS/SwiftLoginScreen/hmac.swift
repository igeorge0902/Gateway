//
//  hmac.swift
//  SwiftLoginScreen
//
//  Created by Gaspar Gyorgy on 23/12/15.
//  Copyright © 2015 George Gaspar. All rights reserved.
//

import Foundation

enum HMACAlgorithm {
    case md5, sha1, sha224, sha256, sha384, sha512
    
    func toCCEnum() -> CCHmacAlgorithm {
        var result: Int = 0
        switch self {
        case .md5:
            result = kCCHmacAlgMD5
        case .sha1:
            result = kCCHmacAlgSHA1
        case .sha224:
            result = kCCHmacAlgSHA224
        case .sha256:
            result = kCCHmacAlgSHA256
        case .sha384:
            result = kCCHmacAlgSHA384
        case .sha512:
            result = kCCHmacAlgSHA512
        }
        return CCHmacAlgorithm(result)
    }
    
    func digestLength() -> Int {
        var result: CInt = 0
        switch self {
        case .md5:
            result = CC_MD5_DIGEST_LENGTH
        case .sha1:
            result = CC_SHA1_DIGEST_LENGTH
        case .sha224:
            result = CC_SHA224_DIGEST_LENGTH
        case .sha256:
            result = CC_SHA256_DIGEST_LENGTH
        case .sha384:
            result = CC_SHA384_DIGEST_LENGTH
        case .sha512:
            result = CC_SHA512_DIGEST_LENGTH
        }
        return Int(result)
    }
}

extension String {
    
    func digest(_ algorithm: HMACAlgorithm, key: String) -> String! {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = self.lengthOfBytes(using: String.Encoding.utf8)
        let digestLen = algorithm.digestLength()
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        let keyStr = key.cString(using: String.Encoding.utf8)
        let keyLen = key.lengthOfBytes(using: String.Encoding.utf8)
        
        CCHmac(algorithm.toCCEnum(), keyStr!, keyLen, str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0..<digestLen {
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return String(hash)
    }
    
}
