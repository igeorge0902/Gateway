//: Playground - noun: a place where people can play

import Cocoa
import Foundation
import PlaygroundSupport
import XCPlayground

PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, playground"

let deviceId = "FF247563-8AB1-4F0D-864A-B6BB15743BA2"
// let newString:NSString =  "("+("\"\((deviceId))\"")+")"
// print(newString)

"\"\(deviceId)\""

var movieId = 1002
var myString = String(movieId)

print(myString)

// current date
let date = NSDate().timeIntervalSince1970
print("Date 1 \(date)")

func getCurrentMillis() -> Int64 {
    return Int64(NSDate().timeIntervalSince1970 * 1000)
}

var currentTime = getCurrentMillis()

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue {
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
    var name: String
    var height: Int
    var hairColor: String
    var health: Int

    init(name: String, height: Int, hairColor: String) {
        self.name = name
        self.height = height
        self.hairColor = hairColor
        health = 100
    }

    func applyDamage(amount: Int) -> Int {
        health = health - amount
        print(health)
        return health
    }
}

let human_ = human(name: "G", height: 2, hairColor: "k")
human_.applyDamage(amount: 5)

class Car {
    let make: String
    let model: String
    let price: Int

    init(make: String, model: String, price: Int) {
        self.make = make
        self.model = model
        self.price = price
    }

    func drive() {
        print("Driving")
    }
}

class SportsCar: Car {
    var isExotic: Bool

    init(make: String, model: String, price: Int, isExotic: Bool) {
        self.isExotic = isExotic
        super.init(make: make, model: model, price: price)
    }

    override func drive() {
        if isExotic == false {
            print("Driving fast")
        }
    }
}

var trabant = SportsCar(make: "Trabant", model: "sedan", price: 10000, isExotic: false)
trabant.drive()

var toyotaCamry = Car(make: "Toyota", model: "Camry", price: 20000)
toyotaCamry.drive() // prints "Driving"

// -----------

func calculate(arbitraryValue value: Int) -> Int {
    return value * 2
}

var c = calculate(arbitraryValue: 5)

// -----------

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
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley"),
]

var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
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
    Movie(name: "Alien", director: "Ridley Scott"),
]

for object in someObjects {
    let movie = object as! Movie
    print("Movie: '\(movie.name)', dir. \(movie.director)")
}

for movie in someObjects as! [Movie] {
    print("Movie: '\(movie.name)', dir. \(movie.director)")
}

// -----------

var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
//things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append { (name: String) -> String in "Hello, \(name)" }

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
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}

// -----------

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

    convenience override init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

// -----------

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

// -----------

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
    print(urlss)
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

/*------------------*/

protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139_968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = (lastRandom * a + c).truncatingRemainder(dividingBy: m)
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
print("Here's a random number: \(generator.random())")
// Prints "Here's a random number: 0.37464991998171"
print("And another one: \(generator.random())")
// Prints "And another one: 0.729023776863283"

class Dice {
    let sides: Int
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }

    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate {
    func gameDidStart(game: DiceGame)
    func game(game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = [Int](repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }

    var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(game: self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(game: self, didStartNewTurnWithDiceRoll: diceRoll)
            print("diceroll: \(diceRoll)")
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(game: self)
    }
}

var S = SnakesAndLadders()

S.play()
// --------------------

/*

 if request.URL!.relativePath == "/example/jsR/app.js" {

 let urldata:NSData = self.mutableData
 let convertedString = NSString(data: urldata, encoding: NSUTF8StringEncoding)

 //let deviceId = UIDevice.currentDevice().identifierForVendor!.UUIDString
 print(deviceId)
 let newString:NSString = convertedString!.stringByReplacingOccurrencesOfString("(uuid)", withString: "("+("\"\((deviceId))\"")+")")
 let newurldata:NSData = newString.dataUsingEncoding(NSASCIIStringEncoding)!
 self.mutableData.appendData(newurldata)
 cachedResponse.setValue(self.mutableData, forKey: "data")

 }

 */

let baseURL = "https://www.google.com/accounts/Logout"

typealias CallbackBlock = (_ result: String, _ error: String?) -> Void

func httpGet(request: NSURLRequest!, callback: @escaping (String, String?) -> Void) {
    let session = URLSession.shared
    let task = session.dataTask(with: request as URLRequest) {
        (data, _, error) -> Void in

        if error != nil {
            callback("", error!.localizedDescription)

        } else {
            let result = NSString(data: data!, encoding:
                String.Encoding.ascii.rawValue)!

            callback(result as String, nil)
        }
    }
    task.resume()
}

var request = URLRequest(url: URL(string: baseURL)!)

httpGet(request: request as NSURLRequest!) {
    (_, error) -> Void in

    if error != nil {
        print(error as Any)

    } else {
        // print(data)
    }
}

var airports = ["YYZ": "Toronto Pearson", "DUB": "Dublin"]

for (airportCode, airportName) in airports {
    if airportCode.contains("YYZ") {
        print("\(airportCode): \(airportName)")
    }
}

var list = ["A1", "A2"]
print(list)

let airportCodes = [String](airports.keys)
var size = airportCodes.count

// for i in 0 ..< airportCodes.count {
var string = ""
for airportCode in airports.keys {
    string += airportCode + "-"
}

print(string)
// }
print(airportCodes)

func jediTrainer() -> ((String, Int) -> String) {
    func train(name: String, times: Int) -> (String) {
        return "\(name) has been trained in the Force \(times) times"
    }
    return train
}

let train = jediTrainer()
train("Obi Wan", 3)

func jediGreet(name: String, ability: String) -> (farewell: String, mayTheForceBeWithYou: String) {
    return ("Good bye, \(name).", " May the \(ability) be with you.")
}

let retValue = jediGreet(name: "old friend", ability: "Force")
print(retValue)
print(retValue.farewell)
print(retValue.mayTheForceBeWithYou)

struct Person {
    var age: Int?
    init(age: Int) {
        self.age = age
    }
}

var eventAttendees = [Person(age: 22), Person(age: 41), Person(age: 23), Person(age: 30)]
var filteredAttendees = eventAttendees.filter {
    $0.age! < 30
}

for person in filteredAttendees {
    print(person.age!)
}

var visitors = [["age": 22], ["age": 41], ["age": 23], ["age": 30]]

var filteredVisitors = visitors.filter {
    $0["age"]! < 30
}

print(filteredVisitors[1]["age"]!)

class Node {
    var value: String
    var children: [Node] = []
    weak var parent: Node?

    init(value: String) {
        self.value = value
    }

    func addChild(node: Node) {
        children.append(node)
        node.parent = self
    }
}

let beverages = Node(value: "beverages")

let hotBeverage = Node(value: "hot")
let coldBeverage = Node(value: "cold")

let tea = Node(value: "tea")
let coffee = Node(value: "coffee")
let cocoa = Node(value: "cocoa")

let blackTea = Node(value: "black")
let greenTea = Node(value: "green")
let chaiTea = Node(value: "chai")

let soda = Node(value: "soda")
let milk = Node(value: "milk")

let gingerAle = Node(value: "ginger ale")
let bitterLemon = Node(value: "bitter lemon")

beverages.addChild(node: hotBeverage)
beverages.addChild(node: coldBeverage)

hotBeverage.addChild(node: tea)
hotBeverage.addChild(node: coffee)
hotBeverage.addChild(node: cocoa)

coldBeverage.addChild(node: soda)
coldBeverage.addChild(node: milk)

tea.addChild(node: blackTea)
tea.addChild(node: greenTea)
tea.addChild(node: chaiTea)

soda.addChild(node: gingerAle)
soda.addChild(node: bitterLemon)

// 1
extension Node: CustomStringConvertible {
    // 2
    var description: String {
        // 3
        var text = "\(value)"

        // 4
        if !children.isEmpty {
            text += " {" + children.map { $0.description }.joined(separator: ", ") + "} "
        }
        return text
    }
}

extension Node {
    // 1
    func search(value: String) -> Node? {
        // 2
        if value == self.value {
            return self
        }
        // 3
        for child in children {
            if let found = child.search(value: value) {
                return found
            }
        }
        // 4
        return nil
    }
}

var node = beverages.search(value: "cocoa") // returns the "cocoa" node
print(node as Any)
beverages.search(value: "chai") // returns the "chai" node
beverages.search(value: "bubbly") // returns nil

print(soda.children.map { $0.description }.joined(separator: ", "))

print(beverages) // <- try to print it!
