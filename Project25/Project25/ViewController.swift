//
//  ViewController.swift
//  Project25
//
//  Created by Tiberiu on 11.01.2021.
//

import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {
    var images = [UIImage]()
    var caption: String!
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
        
        title = "Selfie Square"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        let ConnectionButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        let peersButton = UIBarButtonItem(title: "Peers", style: .plain, target: self, action: #selector(showPeers))
        navigationItem.leftBarButtonItems = [ConnectionButton, peersButton]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)

        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }

        return cell
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true)
    }
    
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }

    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    //challenge 3
    @objc func showPeers() {
        guard let mcSession = mcSession else { return }
        let connectedPeers = mcSession.connectedPeers
        var peers = ""
        if connectedPeers.count == 0 {
            peers = "None"
        } else {
            for peer in connectedPeers {
                peers += "\(peer.displayName) \n"
            }
            peers = peers.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
        let ac = UIAlertController(title: "Connected Peers", message: peers, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        dismiss(animated: true)

        images.insert(image, at: 0)
        collectionView.reloadData()
        
        //challenge 2
        let ac = UIAlertController(title: "Caption", message: "Write your caption", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Done", style: .default) { [weak self] _ in
            guard let caption = ac.textFields?[0].text else { return }
            guard let mcSession = self?.mcSession else { return }
            self?.caption = caption
            if mcSession.connectedPeers.count > 0 {
                let stringData = Data(caption.utf8)
                do {
                    try mcSession.send(stringData, toPeers: mcSession.connectedPeers, with: .reliable)
                    print(caption)
                } catch {
                    //Show an error message if there's a problem
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    ac.popoverPresentationController?.barButtonItem = self?.navigationItem.rightBarButtonItem
                    self?.present(ac, animated: true)
                }
            }
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.popoverPresentationController?.barButtonItem = navigationItem.leftBarButtonItem
        present(ac, animated: true)
        
        
        
        //Check if we have an active session we can use.
        guard let mcSession = mcSession else { return }
        //Check if there are any peers to send it to
        if mcSession.connectedPeers.count > 0 {
            //Convert the image to Data object
            if let imageData = image.pngData() {
                //Send it to all peers, ensuring it gets delivered
                do {
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    //Show an error message if there's a problem
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
                    present(ac, animated: true)
                    
                }
            }
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            if let image =  UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            } else {
                //challenge 2
                let caption = String(decoding: data, as: UTF8.self)
                let ac = UIAlertController(title: "\(peerID.displayName) caption this image: ", message: caption, preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self?.present(ac, animated: true)
            }
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
        case .connecting:
            print("Connecting: \(peerID.displayName)")
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            //Challenge 1 - it was running on a back thread so I had to pull it to main because is UI related
            DispatchQueue.main.async { [weak self] in
                self?.showDisconnectedAlert(message: "\(peerID.displayName)")
            }
            
        @unknown default:
            print("Unknown state recieved: \(peerID.displayName)")
        }
    }
    
    //challenge 1
    func showDisconnectedAlert(message: String) {
        let ac = UIAlertController(title: "Leaver:", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(ac, animated: true)
    }
    
    //useless required methods:
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true, completion: nil)
    }

}
