import UIKit

let driving = {
    print("I'm driving a car to")
}


let drivingWithReturn = { (place: String) -> String in
    return "I'm drinving to \(place)"
}

let message = drivingWithReturn("cluj")
print(message)

func travel(action: (String, Int) -> String) {
    print("I'm ready to go")
    let description = action("London", 60)
    print(description)
    print("I arrived!")
}

travel { place, speed in
     "I'm going to \(place) in my car at \(speed) per hour"
}
travel {
    "I'm going to \($0) in my car at \($1) per hour"
}

func reduce (_ values: [Int], using closure: (Int, Int) -> Int) -> Int {
    // start with a total equal to the first value of the array
    var current = values[0]
    
    //loop over all the values in the array, counting from 1 upwards.
    for value in values[1...] {
        //call our closure with the current value and the array in the element, assining the result
        current = closure(current, value)
    }
    return current
}
let numbers = [10, 20, 30]

let sum = reduce(numbers) { (runningTotal: Int, next: Int) in
    runningTotal + next
}

print(sum)

func increaseBankBalance(start: Double, interestCalculator: () -> Double) {
    print("Your current balance is \(start).")
    let interestRate = interestCalculator()
    let withInterest = start * interestRate
    print("You now have \(withInterest).")
}
increaseBankBalance(start: 200.0) {
    return 1.01
}

func closureTravel () -> (String) -> String {
    var counter = 1
    return {
        counter += 1
        return "I'm going to \($0)"
    }
}

let result = closureTravel()
result("London")
result("London")
result("London")
