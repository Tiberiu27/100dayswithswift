import UIKit

var str = "Hello, playground"


let password = "12345"
var newPassword = password.deletingPrefix("12")
newPassword = newPassword.deletingSuffix("5")
print(newPassword)

let weather = "is going to rain"
print(weather.capitalized)
print(weather.capitalizedFirst)

let input = "Swift is like Objective C without the C"
let languages = ["Python", "Ruby", "Swift"]

print(languages.contains(where: input.contains))

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: _NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: _NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
attributedString.addAttribute(.link, value: UIFont.systemFont(ofSize: 10), range: NSRange(location: 0, length: 4))

//challenge 1
print("pet".withPrefix("car"))

//challenge 2
print("The dog with 3 heads".isNumeric)

//challenge 3
print("The dog\nWalks\nin\nPark".lines)

extension String {
    //remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    //remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }

    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
    
    //challenge 1
    func withPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else {
            return prefix + self
            
        }
        return self
    }
    
    //challenge 2
    var isNumeric: Bool {
        guard  self.rangeOfCharacter(from: .decimalDigits) != nil else { return false }
        return true
    }
    
    //challenge 3
    var lines: [String] {
        guard !self.isEmpty else { return [""]}
        return self.components(separatedBy: "\n")
    }
    
    
}
