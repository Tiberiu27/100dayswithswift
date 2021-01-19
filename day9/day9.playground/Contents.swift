import UIKit

struct User {
    var username: String
}

extension User {
    init() {
        self.username = "Anonymous"
        print("Creating a user!")
    }
}

let dodo = User()
dodo.username
let coco = User(username: "coco")
coco.username

struct FamilyTree {
    init() {
        print("Creating a family tree!")
    }
}

struct Person {
    var name: String
    lazy var familyTree = FamilyTree()
    
    init(name: String) {
        self.name = name
    }
}

var ed = Person(name: "Ed")
ed.familyTree

//Static propreties example
struct Student {
    static var classSize = 0
    var name: String
    
    init(name: String) {
        self.name = name
        Student.classSize += 1
    }
}
var nelu = Student(name: "Nelu")
var rica = Student(name: "Rica")
print(Student.classSize)


