//
//  ViewController.swift
//  Challenge8
//
//  Created by Tiberiu on 10.01.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //challenge 1
        let circle = UIView(frame: CGRect(x: 60, y: 260, width: 256, height: 256))
        circle.layer.cornerRadius = 128
        circle.backgroundColor = .systemYellow
        circle.bounceOut(duration: 10)
        view.addSubview(circle)
        
        //challenge 2
        let someInt = 12
        someInt.times { print("hello") }
        
        let someNegativeInt = -3
        someNegativeInt.times { print("Goodbye") }
        
        //challenge 3
        var someArray = ["One", "Two", "Three", "One", "Three"]
        someArray.remove(item: "Three")
        print(someArray)
        
        var someIntArray = [1, 2, 3, 5, 2, 3, 6]
        someIntArray.remove(item: 3)
        print(someIntArray)
        
        var someOtherIntArray = [1, 2, 3, 4, 5]
        someOtherIntArray.remove(item: 6) //tricky
        print(someOtherIntArray)
    }

}
//challenge 1
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        })
    }
}

//challenge 2
extension Int {
    func times(_ iterration: () -> Void) {
        guard self > 0 else { return }
        for _ in 0...self {
            iterration()
        }
    }
}

//challenge 3
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        if let index = self.firstIndex(of: item) {
            self.remove(at: index)
        }
    }
}
