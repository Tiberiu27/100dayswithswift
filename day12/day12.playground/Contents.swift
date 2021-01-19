import UIKit



var name: String? = nil
name = "coco"
if let unwrapped = name {
    print("\(unwrapped.count) letters")
} else {
    print("Missing name.")
}

func greet(_ name: String?) {
    guard let unwrapped = name else {
        print("You didn't provide a name!")
        return
    }
    print("Hello, \(unwrapped)")
}

greet("sarma")

//force unwrapping
let str = "5"
let num = Int(str)!
print(num + num)

//implicitly unwrapped optionals
var age: Int! = nil
age = 20
print(age * age)

//nil coalescing operator
func username(for id: Int) -> String? {
    if id == 1 {
        return "Taylor Swift"
    } else {
        return nil
    }
}

let user = username(for: 12) ?? "Anonymous"

//optional chaning
let names = [String]()
let beatle = names.first?.uppercased()
print(beatle)
if let beatle = beatle { //unwrapping
    print(beatle)
} else {
    print("None found")
}
//testing how optional works for common things I do
let litere = ["A", "B", "C"]
let caine = litere.first!
let alta = litere[1]
print(alta)
print(caine)
let myDict = ["first": 1, "second": 2, "third": 3]
let second = myDict["second"]! //force unwrapping
print(second)
let secondWithoutUnwrapping = myDict["second", default: 0]
print(secondWithoutUnwrapping)

//optional try
enum PasswordError: Error {
    case obvious
}

func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    return true
}

if let result = try? checkPassword("mypass") {
    print("result was \(result)")
} else {
    print("D'oh.")
}

//failable initializer
struct Person {
    var id: String
    
    init?(id: String) {
        if id.count == 9 {
            self.id = id
        } else {
            return nil
        }
    }
}
let sandu = Person(id: "2222522223")
if let sandu = sandu {
    print(sandu.id)
} else {
    print("invalid id")
}

//Typecasting
class Animal { }
class Fish: Animal { }

class Dog: Animal {
    func makeNoise() {
        print("Woof!")
    }
}
let pets = [Fish(), Dog(), Fish(), Dog()]

for pet in pets {
    if let dog = pet as? Dog {
        dog.makeNoise()
    }
}
