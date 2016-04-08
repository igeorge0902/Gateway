//: Playground - noun: a place where people can play

import Cocoa
import XCPlayground
import Foundation


var str = "Hello, playground"

let deviceId = "FF247563-8AB1-4F0D-864A-B6BB15743BA2"
let newString:NSString =  "("+("\"\((deviceId))\"")+")"
print(newString)


("\"\(deviceId)\"")


//current date
let date = NSDate().timeIntervalSince1970;
print("Date 1 \(date)")

func getCurrentMillis()->Int64{
    return  Int64(NSDate().timeIntervalSince1970 * 1000)
}

var currentTime = getCurrentMillis()



class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}
let stepCounter = StepCounter()

stepCounter.totalSteps = 200
// About to set totalSteps to 200
// Added 200 steps

stepCounter.totalSteps = 360
// About to set totalSteps to 360
// Added 160 steps

stepCounter.totalSteps = 896
// About to set totalSteps to 896
// Added 536 steps

struct Size {
    var width = 0.0, height = 0.0
}

struct Point {
    var x = 0.0, y = 0.0
}



struct Rect {
    var origin = Point()
    var size = Size()
    
    init() {}
    
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let centerRect = Rect(center: Point(x: 8.0, y: 8.0), size: Size(width: 3.0, height: 3.0))



class Vehicle {
    var numberOfWheels = 0
    var description: String {
        return "\(numberOfWheels) wheel(s)"
    }
}



class Bicycle: Vehicle {
    override init() {
        super.init()
        numberOfWheels = 2
    }
}

let bicycle = Bicycle()
print("Bicycle: \(bicycle.description)")


class human {
    var name:String
    var height:Int
    var hairColor:String
    var health:Int
    
    init(name:String, height:Int, hairColor:String) {
        self.name = name
        self.height = height
        self.hairColor = hairColor
        self.health = 100
    }
    
    func applyDamage(amount:Int) -> Int{
        self.health = self.health - amount
        print(self.health)
        return self.health
    }
}

let human_ = human(name: "G", height: 2, hairColor: "k")
human_.applyDamage(5)

class Car {
    let make:String;
    let model:String;
    let price:Int;
    
    init(make: String, model: String, price:Int) {
        self.make = make;
        self.model = model;
        self.price = price;
    }
    
    func drive() {
        print("Driving");
    }
}

class SportsCar: Car {
    var isExotic:Bool;
    
    init(make: String, model: String, price:Int, isExotic: Bool) {
        self.isExotic = isExotic;
        super.init(make: make, model: model, price: price);
    }
    
    override func drive() {
        if isExotic == false {
            print("Driving fast");
        }
    }
}

var trabant = SportsCar(make: "Trabant", model: "sedan", price: 10000, isExotic: false)
trabant.drive()

var toyotaCamry = Car(make:"Toyota", model:"Camry", price:20000);
toyotaCamry.drive(); // prints "Driving"

//-----------

func calculate(arbitraryValue value:Int) -> Int {
    return value * 2;
}

var c = calculate(arbitraryValue: 5);

//-----------


class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}



class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]



var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        ++movieCount
    } else if item is Song {
        ++songCount
    }
}

print("Media library contains \(movieCount) movies and \(songCount) songs")

for item in library {
    if let movie = item as? Movie {
        print("Movie: '\(movie.name)', dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: '\(song.name)', by \(song.artist)")
    }
}


let someObjects: [AnyObject] = [
    Movie(name: "2001: A Space Odyssey", director: "Stanley Kubrick"),
    Movie(name: "Moon", director: "Duncan Jones"),
    Movie(name: "Alien", director: "Ridley Scott")
]

for object in someObjects {
    let movie = object as! Movie
    print("Movie: '\(movie.name)', dir. \(movie.director)")
}

for movie in someObjects as! [Movie] {
    print("Movie: '\(movie.name)', dir. \(movie.director)")
}

//-----------


var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })

for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called '\(movie.name)', dir. \(movie.director)")
    case let stringConverter as String -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}

//-----------


class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}



let namedMeat = Food(name: "Bacon")
// namedMeat's name is "Bacon"



class RecipeIngredient: Food {
    var quantity: Int
    
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}


//-----------


let oneMysteryItem = RecipeIngredient()
let oneBacon = RecipeIngredient(name: "Bacon")
let sixEggs = RecipeIngredient(name: "Eggs", quantity: 6)



class ShoppingListItem: RecipeIngredient {
    
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

var breakfastList = [
    ShoppingListItem(),
    ShoppingListItem(name: "Bacon"),
    ShoppingListItem(name: "Eggs", quantity: 6),
]

breakfastList[0].name = "Orange juice"
breakfastList[0].purchased = true

for item in breakfastList {
    print(item.description)
}


//-----------


struct Animal {
    let species: String
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}



let someCreature = Animal(species: "Giraffe")
// someCreature is of type Animal?, not Animal

if let giraffe = someCreature {
    print("An animal was initialized with a species of \(giraffe.species)")
}
// prints "An animal was initialized with a species of Giraffe"




protocol FullyNamed {
    var fullName: String { get }
}

struct Urls {
    let urls: String
    init?(urls: String) {
        if urls.isEmpty { return nil }
        self.urls = urls
    }
}
if let urlss = Urls(urls: "http://milo.crabdance.com") {
    print (urlss)
}
class Starship: FullyNamed {
    var prefix: String?
    var name: String
    init(name: String, prefix: String? = nil) {
        self.name = name
        self.prefix = prefix
    }
    
    var fullName: String {
        return (prefix != nil ? prefix! + " " : "") + name
    }
}

var ncc1701 = Starship(name: "Enterprise", prefix: "USS")
ncc1701.fullName


//--------------------

let baseURL = "https://milo.crabdance.com/login/admin"
/*
typealias CallbackBlock = (result: String, error: String?) -> ()

func httpGet(request: NSURLRequest!, callback: (String, String?) -> Void) {
let session = NSURLSession.sharedSession()
let task = session.dataTaskWithRequest(request){

(data, response, error) -> Void in

if error != nil {
callback("", error!.localizedDescription)

} else {

let result = NSString(data: data!, encoding:
NSASCIIStringEncoding)!
callback(result as String, nil)
}
}
task.resume()
}

var request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)

httpGet(request){

(data, error) -> Void in
if error != nil {
print(error)
} else {
print(data)
}
}*/



class LearnNSURLSession: NSObject, NSURLSessionDelegate, NSURLSessionTaskDelegate {
    
    typealias CallbackBlock = (result: String, error: String?) -> ()
    
    
    var callback: CallbackBlock = {
        (resultString, error) -> Void in
        if error == nil {
            print(resultString)
        } else {
            print(error)
        }
    }
    
    func httpGet(request: NSMutableURLRequest!, callback: (String, String?) -> Void) {
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        
        let session = NSURLSession(configuration: configuration, delegate: self, delegateQueue:NSOperationQueue.mainQueue())
        
        let task = session.dataTaskWithRequest(request){
            
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error != nil {
                callback("", error!.localizedDescription)
                
            } else {
                let result = NSString(data: data!, encoding: NSASCIIStringEncoding)!
                
                callback(result as String, nil)
            }
        }
        task.resume()
    }
    
    
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler:
        (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
            
            print("didReceiveAuthenticationChallenge")
            
            completionHandler(
                
                NSURLSessionAuthChallengeDisposition.UseCredential,
                NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!))
    }
    
    /*
    func URLSession(session: NSURLSession, didReceiveChallenge challenge: NSURLAuthenticationChallenge, completionHandler: (NSURLSessionAuthChallengeDisposition, NSURLCredential?) -> Void) {
    
    // For example, you may want to override this to accept some self-signed certs here.
    if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust &&
    Constants.selfSignedHosts.contains(challenge.protectionSpace.host) {
    
    // Allow the self-signed cert.
    let credential = NSURLCredential(forTrust: challenge.protectionSpace.serverTrust!)
    completionHandler(.UseCredential, credential)
    } else {
    // You *have* to call completionHandler either way, so call it to do the default action.
    completionHandler(.PerformDefaultHandling, nil)
    }
    }
    
    // MARK: - Constants
    
    struct Constants {
    
    // A list of hosts you allow self-signed certificates on.
    // You'd likely have your dev/test servers here.
    // Please don't put your production server here!
    static let selfSignedHosts: Set<String> = ["milo.crabdance.com"]
    }*/
    
    func URLSession(session: NSURLSession, task: NSURLSessionTask, willPerformHTTPRedirection response: NSHTTPURLResponse,
        newRequest request: NSURLRequest, completionHandler: (NSURLRequest?) -> Void) {
            
            let newRequest : NSURLRequest? = request
            
            print(newRequest?.description);
            completionHandler(newRequest)
    }
}


var learn = LearnNSURLSession()

var request = NSMutableURLRequest(URL: NSURL(string: baseURL)!)

learn.httpGet(request) {
    
    (resultString, error) -> Void in
    learn.callback(result: resultString, error: error)
    print(resultString)
    
}


XCPSetExecutionShouldContinueIndefinitely(true)

