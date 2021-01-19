//
//  ViewController.swift
//  Project28
//
//  Created by Tiberiu on 17.01.2021.
//
import LocalAuthentication
import UIKit


class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    var password: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Nothing to see here"
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        //observer for the application being backgrounded
        notificationCenter.addObserver(self, selector: #selector(saveSecretMessage), name: UIApplication.willResignActiveNotification, object: nil)
        
        //Challenge 2 - load password
        if let pass = KeychainWrapper.standard.string(forKey: "password") {
            password = pass
        }
        
    }
    
    
    func unlockSecretMessage() {
        //challange 1
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSecretMessage))
        
        secret.isHidden = false
        title = "Secret stuff!"
        
        if let text = KeychainWrapper.standard.string(forKey: "SecretMessage") {
            secret.text = text
        }
    }
    
    @objc func saveSecretMessage() {
        guard secret.isHidden == false else { return }
        //challenge 1
        navigationItem.rightBarButtonItem = nil
        //save note to keychain
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] succes, authentificationError in
                
                DispatchQueue.main.async {
                    if succes {
                        self?.unlockSecretMessage()
                    } else {
                        let ac = UIAlertController(title: "Authentification Failed", message: "You could not be verified, please try again", preferredStyle: .alert)
                        ac.addAction(UIAlertAction(title: "OK", style: .default))
                        self?.present(ac, animated: true)
                    }
                }
                
            }
        //challenge 2
        } else if password == nil {
            //no biometry
            let ac = UIAlertController(title: "Biometry unavailable", message: "Would you like to use a password instead?", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "Set Password", style: .default) { [weak self, weak ac] _ in
                guard let password = ac?.textFields?[0].text else { return }
                self?.createPassword(pass: password)
            })
            ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            self.present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "STOP!", message: "You shall not pass!", preferredStyle: .alert)
            ac.addTextField()
            ac.addAction(UIAlertAction(title: "It's me!", style: .default) { [weak self, weak ac] _ in
                guard let password = ac?.textFields?[0].text else { return }
                self?.checkPassword(pass: password)
            })
            ac.addAction(UIAlertAction(title: "Damn", style: .cancel))
            present(ac, animated: true)
        }
    }
    //challenge 2
    func createPassword(pass: String) {
        password = pass

        KeychainWrapper.standard.set(password ?? pass, forKey: "password")
    }
    //challenge 2
    func checkPassword(pass: String) {
        if pass == password {
            unlockSecretMessage()
        }
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        secret.scrollIndicatorInsets = secret.contentInset

        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }

}

