import UIKit

func printHelp() {
    let message = """
    Welcome to MyApp!
    
    Run this app inside a directory of images and
    MyApp will resize them all into thumbnails!
"""
    print(message)
}

printHelp()

func square(number: Int) -> Int {
    return number * number
}
let result = square(number: 8)
print(result)

func isAdult(ages: [Int]) -> Bool {
    for age in ages {
        if age < 18 {
            return false
        }
    }
    return true
}
isAdult(ages: [55,20,12,25,33])

func sayHello(to name: String) {
    print("Hello, \(name)")
}
sayHello(to: "Coco")

func greet (_ person: String, nicely: Bool = true) {
    if nicely == true {
        print("Hello, \(person)")
    } else {
        print("Oh no, it's \(person) again")
    }
}

greet("Taylor", nicely: false)

//varadic
func squarey(_ numbers: Int...) {
    for number in numbers {
        print("\(number) squared is \(number * number)")
    }
}
squarey(1, 2, 44)


enum PasswordError: Error {
    case obvious
}

func checkPassword(_ password: String) throws -> Bool {
    if password == "password" {
        throw PasswordError.obvious
    }
    
    return true
}
do {
    try checkPassword("password")
        print("That password is good")
    } catch {
        print("You can't use that password")
    }

func doubleInPlace(number: inout Int) {
    number *= 2
}
var aNum = 10
doubleInPlace(number: &aNum)

aNum
