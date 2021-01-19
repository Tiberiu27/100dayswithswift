import UIKit

class Dog {
    var name: String
    var breed: String
    
    func makeNoise() {
        print("Woof")
    }
    init(name: String, breed: String) {
        self.name = name
        self.breed = breed
    }
}

class Poodle: Dog {
    override func makeNoise() {
        print("Yip")
    }
    init(name: String){
        super.init(name: name, breed: "Poodle")
    }
}
let poppy = Dog(name: "Musty", breed: "Havanese")
poppy.makeNoise()
let coco = Poodle(name: "Coco")
coco.makeNoise()

class Singer {
    var name = "Taylor Swift"
}
var singer = Singer()
print(singer.name)

var singerCopy = singer
singerCopy.name = "Justin Beiber"
print(singer.name)

class Person {
    var name = "John Doe"
    
    init() {
        print("\(name) is alive!")
    }
    
    func printGreeting() {
        print("Hello, I am \(name)")
    }
    
    deinit {
        print("\(name) is no more!")
    }
}

for _ in 1...3 {
    let person = Person()
    person.printGreeting()
}
