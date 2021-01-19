import UIKit

let count = 1...10

for number in count {
    print("Number is \(number)")
}

for _ in 1...5 {
    print("player gonna play")
}

var number = 1

while number <= 20 {
    print(number)
    number += 1
}

print("Ready or not?")

var countdown = 10

while countdown >= 0 {
    print(countdown)
    
    if countdown == 4 {
        print("I'm bored. Let's go now!")
        break
    }
    countdown -= 1
}

outerLoop: for i in 1...10 {
    for j in 1...10 {
        let product = i * j
        print("\(i) * \(j) is \(product)")
        
        if product == 50 {
            print("It's a bullseye!")
            break outerLoop
        }
    }
}

for i in 1...10 {
    if i % 2 == 1 {
        continue
    }
    print(i)
}
