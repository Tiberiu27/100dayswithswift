//
//  DetailWebViewController.swift
//  Project16
//
//  Created by Tiberiu on 02.01.2021.
//

import UIKit
import WebKit
class DetailWebViewController: UIViewController {
    var webView: WKWebView!
    var capitalUrl: String?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        guard let capitalUrl = capitalUrl else { return }
        let url = URL(string: capitalUrl)!
        webView.load(URLRequest(url: url))
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
