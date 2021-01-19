//
//  ViewController.swift
//  Project27
//
//  Created by Tiberiu on 13.01.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var currentDrawType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        drawRectangle()
    }
    
    @IBAction func redrawTapped(_ sender: Any) {
        currentDrawType += 1
        
        if currentDrawType > 7 {
            currentDrawType = 0
        }
        
        switch currentDrawType {
        case 0:
            drawRectangle()
        case 1:
            drawCircle()
        case 2:
            drawCheckerBoard()
        case 3:
            drawRotatedSquares()
        case 4:
            drawLines()
        case 5:
            drawImagesAndText()
        case 6:
            drawEmoji()
        case 7:
            drawTWIN()
        default:
            break
        }
    }
    
    func drawRectangle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // awsome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = img
    }
    
    func drawCircle() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            // awsome drawing code
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            
            ctx.cgContext.setFillColor(UIColor.red.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.setLineWidth(10)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        
        imageView.image = img
    }
    
    func drawCheckerBoard() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            
            for row in 0 ..< 8 {
                for col in 0 ..< 8 {
                    if (row + col) % 2 == 0 {
                        ctx.cgContext.fill(CGRect(x: col * 64, y: row * 64, width: 64, height: 64))
                    }
                }
            }
        }
        imageView.image = img
    }
    
    func drawRotatedSquares() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            let rotations = 16
            let amount = Double.pi / Double(rotations)
            
            for _ in 0 ..< rotations {
                ctx.cgContext.rotate(by: CGFloat(amount))
                ctx.cgContext.addRect(CGRect(x: -128, y: -128, width: 256, height: 256))
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawLines() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            ctx.cgContext.translateBy(x: 256, y: 256)
            
            var first = true
            var length: CGFloat = 256
            
            for _ in 0 ..< 256 {
                ctx.cgContext.rotate(by: .pi / 2)
                
                if first {
                    ctx.cgContext.move(to: CGPoint(x: length, y: 50))
                    first = false
                } else {
                    ctx.cgContext.addLine(to: CGPoint(x: length, y: 50))
                }
                length *= 0.99
            }
            
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            ctx.cgContext.strokePath()
        }
        
        imageView.image = img
    }
    
    func drawImagesAndText() {
        //Create a renderer
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            //Define a paragraph style that aligns text to the center.
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            //Create an attributes dictionary containing that paragraph style, and also a font.
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 36),
                .paragraphStyle: paragraphStyle
            ]
            
            //Wrap that attributes dictionary and a string into an instance of NSAttributedString.
            let string = "The best laid schemes o'\nmice an' men gang aft agley"
            let attributedString = NSAttributedString(string: string, attributes: attrs)
            
            attributedString.draw(with: CGRect(x: 32, y: 32, width: 448, height: 448), options: .usesLineFragmentOrigin, context: nil)
            //Load an image from the project and draw it to the context.
            let mouse = UIImage(named: "mouse")
            mouse?.draw(at: CGPoint(x: 300, y: 150))
        }
        //Update the image view with the finished result.
        imageView.image = img
    }
    
    //challenge 1
    func drawEmoji() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512).insetBy(dx: 5, dy: 5)
            let leftEye = CGRect(x: 140, y: 120, width: 40, height: 40)
            let rightEye = CGRect(x: 330, y: 120, width: 40, height: 40)
            
            ctx.cgContext.setFillColor(UIColor.yellow.cgColor)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
            //mouth
            ctx.cgContext.move(to: CGPoint(x: 100, y: 380))
            ctx.cgContext.addCurve(to: CGPoint(x: 415, y: 380), control1: CGPoint(x: 190, y: 450), control2: CGPoint(x: 350, y: 450))
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.drawPath(using: .fill)
            
            //eyes
            ctx.cgContext.addEllipse(in: leftEye)
            ctx.cgContext.addEllipse(in: rightEye)
            ctx.cgContext.setFillColor(UIColor.black.cgColor)
            ctx.cgContext.drawPath(using: .fill)
            

            
            
        }
        
        imageView.image = img
    }
    
    func drawTWIN() {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 512, height: 512))
        
        let img = renderer.image { ctx in
            let rectangle = CGRect(x: 0, y: 0, width: 512, height: 512)
            ctx.cgContext.setStrokeColor(UIColor.black.cgColor)
            
            let startX = 50
            let startY = 50
            let constant = 15
            
            //T
            ctx.cgContext.move(to: CGPoint(x: startX, y: startY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + constant * 2, y: startY))
            ctx.cgContext.move(to: CGPoint(x: startX + constant, y: startY))
            ctx.cgContext.addLine(to: CGPoint(x: startX + constant, y: startY + constant * 4))
            
            //W
            ctx.cgContext.move(to: CGPoint(x: startX * 2, y: startY))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 2 + constant, y: startY + constant * 4))
            ctx.cgContext.move(to: CGPoint(x: startX * 2 + constant, y: startY + constant * 4))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 2 + constant * 2, y: startY))
            ctx.cgContext.move(to: CGPoint(x: startX * 2 + constant * 2, y: startY))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 2 + constant * 3, y: startY + constant * 4))
            ctx.cgContext.move(to: CGPoint(x: startX * 2 + constant * 3, y: startY + constant * 4))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 2 + constant * 4, y: startY))
            
            //I
            ctx.cgContext.move(to: CGPoint(x: startX * 4 - constant, y: startY))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 4 - constant, y: startY + constant * 4))
            
            
            //N
            ctx.cgContext.move(to: CGPoint(x: startX * 4 + constant, y: startY + constant * 4))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 4 + constant, y: startY))
            ctx.cgContext.move(to: CGPoint(x: startX * 4 + constant, y: startY))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 4 + constant * 3, y: startY + constant * 4))
            ctx.cgContext.move(to: CGPoint(x: startX * 4 + constant * 3, y: startY + constant * 4))
            ctx.cgContext.addLine(to: CGPoint(x: startX * 4 + constant * 3, y: startY))
            
            
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.setFillColor(UIColor.white.cgColor)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
        
        imageView.image = img
    }
}

