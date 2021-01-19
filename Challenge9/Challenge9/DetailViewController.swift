//
//  DetailViewController.swift
//  Challenge9
//
//  Created by Tiberiu on 17.01.2021.
//

import UIKit

enum Position {
    case top, bottom
}

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var imageToDisplay: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imageView.image = imageToDisplay
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        
        let topEdit = UIBarButtonItem(title: "Edit top", style: .plain, target: self, action: #selector(editTop))
        let bottomEdit = UIBarButtonItem(title: "Edit Bottom", style: .plain, target: self, action: #selector(editBottom))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [topEdit, spacer, bottomEdit]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func editTop() {
        let ac = UIAlertController(title: "Add caption for the top part", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {[weak self] _ in
            guard let text  = ac.textFields?[0].text else { return }
            self?.addText(text: text, position: .top)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    @objc func editBottom() {
        let ac = UIAlertController(title: "Add caption for the bottom part", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Submit", style: .default) {[weak self] _ in
            guard let text  = ac.textFields?[0].text else { return }
            self?.addText(text: text, position: .bottom)
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    func addText(text: String, position: Position) {
        let width = imageToDisplay?.size.width ?? 400
        let height = imageToDisplay?.size.width ?? 400
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        
        let img = renderer.image { ctx in
            imageView.image?.draw(at: CGPoint(x: 0, y: 0))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let attrs: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 50),
                .paragraphStyle: paragraphStyle
            ]
            
            let attributedText = NSAttributedString(string: text, attributes: attrs)
            
            if position == .top {
                attributedText.draw(with: CGRect(x: 0, y: 0, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            } else if position == .bottom {
                attributedText.draw(with: CGRect(x: 0, y: height - 100, width: width, height: height), options: .usesLineFragmentOrigin, context: nil)
            }
        }
        
        imageView.image = img
    }
    
    @objc func shareTapped() {
        guard imageView.image != nil else { return }
        let vc = UIActivityViewController(activityItems: [imageView.image!], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
