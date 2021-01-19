import UIKit

let firstScore = 10
let secondScore = 12

let total = firstScore + secondScore
let difference = firstScore - secondScore
let product = firstScore * secondScore
let divided = firstScore / secondScore

var score = 95
score -= 5

var quote = "The rain falls on the "
quote += "Spaniards"

"Swifty" <= "Swift"

let firstCard = 21
let secondCard = 1

if firstCard + secondCard == 21 {
    print("Blackjack!")
} else if firstCard + secondCard == 2{
    print("Aces!")
} else {
    print("Just some cards!")
}

let age1 = 21
let age2 = 12

if age1 > 18 && age2 > 18 {
    print("Both are over 18")
}

if age1 > 18 || age2 > 18 {
    print("One of them is over 18")
}

print(firstCard == secondCard ? "Cards are the same" : "Cards are not the same")


let weather = "sunny"
switch weather {
case "rain":
    print("Bring an umbrella!")
case "snow":
    print("Wrap up warm")
case "sunny":
    print("Wear sunscreen")
    fallthrough
default:
    print("Enjoy your day!")
}

let num = 99

switch num {
case 0..<50:
    print("You failed badly.")
case 50..<85:
    print("You did ok")
default:
    print("Awsome!")
}

