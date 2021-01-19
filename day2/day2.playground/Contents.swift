import UIKit

let john = "John Lennon"
let paul = "Paul McCartney"
let george = "George Harrison"
let ringo = "Ringo Starr"

let beatles: [Any] = [john, paul, george, ringo, 32]

beatles[1]
beatles[4]

let colors = Set(["red", "green", "blue", "red"])

var name = (first: "Taylor", second: "Swift")

name.1
name.first = "Coco"
name

let heights = [
    "Taylor Swift": 1.53,
    "Ed Sheeran": 1.78
]

heights["Ed Sheeran"]

let favIceCream = [
    "Paul": "Chocolate",
    "Sophie": "Vanilla"
]
favIceCream["Paul"]
favIceCream["Coco", default: "Unkown"]

var teams = [String: String]()
teams["Paul"] = "Red"
teams

var words = Set<String>()
var numbers = Set<Int>()

enum Activity {
    case bored
    case running(destination: String)
    case talking(topic: String)
    case singing(volume: Int)
}
let result = Activity.talking(topic: "Soccer")
result

let result2 = Activity.bored
