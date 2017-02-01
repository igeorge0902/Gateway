//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

let username:String = "GG"

let post:NSString = "user=\(username)" as NSString

print(post)


typealias presentType = [Int:Any?]

func wrap(i:Int, gift:Any?) -> presentType? {
    if(i != 0) {
        let box : presentType = [i:wrap(i: i-1,gift:gift)]
        return box
    }
    else {
        let box = [i:gift]
        return box
    }
}

func getGift() -> String? {
    return "foobar"
}

let f00 = wrap(i: 10,gift:getGift())

//Now we have to unwrap f00, unwrap its entry, then force cast it into the type we hope it is, and then repeat this in nested fashion until we get to the final value.

var b4r = (((((((((((f00![10]! as! [Int:Any?])[9]! as! [Int:Any?])[8]! as! [Int:Any?])[7]! as! [Int:Any?])[6]! as! [Int:Any?])[5]! as! [Int:Any?])[4]! as! [Int:Any?])[3]! as! [Int:Any?])[2]! as! [Int:Any?])[1]! as! [Int:Any?])[0])

//Now we have to DOUBLE UNWRAP the final value (because, remember, getGift returns an optional) AND force cast it to the type we hope it is

let asdf : String = b4r!! as! String

print(asdf)