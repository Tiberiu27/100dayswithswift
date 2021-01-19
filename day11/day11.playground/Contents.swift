import UIKit

protocol Identifiable {
    var id: String {get set}
}

class User: Identifiable {
    var id: String
    
    init(id: String) {
        self.id = id
    }
}
var ed = User(id: "aidi")

func displayID(thing: Identifiable) {
    print("My id is: \(thing.id)")
}
displayID(thing: ed)

// Protocol inheritance
protocol Payable {
    func calculateWages() -> Int
}

protocol NeedsTraining {
    func study()
}

protocol HasVacation {
    func takeVacation(days: Int)
}

protocol Employee: Payable, NeedsTraining, HasVacation { }

//extension example
extension Int {
    func squared() -> Int {
        return self * self
    }
    var isEven: Bool {
        return self % 2 == 0
    }
}
let number = 8
number.squared()
number.isEven

//protocol extension
let pythons = ["Eric", "Graham", "John", "Michel", "Terry", "Terry"]
let beatles = Set(["John", "Paul", "George", "Ringo"])

extension Collection {
    func summerize() {
        print("There are \(count) of us: ")
        
        for name in self {
            print(name)
        }
    }
}

pythons.summerize()
beatles.summerize()

//Protocol orientated programming
protocol Identifiable2 {
    var id: String {get set}
    func identify()
}

extension Identifiable2 {
    func identify() {
        print("My id is \(id).")
    }
}
struct User2: Identifiable2 {
    var id: String
}

let twostraws = User2(id: "twostraws")
twostraws.identify()
