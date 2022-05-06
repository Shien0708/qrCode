//
//  ViewController.swift
//  qrCode
//
//  Created by 方仕賢 on 2022/5/6.
//

import UIKit
import Vision
import VisionKit
import MessageUI

class ViewController: UIViewController, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    @IBAction func showCamera(_ sender: Any) {
        let documentCamera = VNDocumentCameraViewController()
        documentCamera.delegate = self
        present(documentCamera, animated: true)
    }
}



extension ViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch result {
        case .cancelled:
            print("cancelled")
        case .sent:
            print("sent")
        case .failed:
            print("failed")
        default:
            print("unknown")
        }
        controller.dismiss(animated: true)
    }
    
    func showMessageViewController(body: String?, recipients: [String]) {
        let controller = MFMessageComposeViewController()
        if let body = body {
            controller.body = body
        }
        controller.messageComposeDelegate = self
        controller.recipients = recipients
        present(controller, animated: true)
    }
    
}

extension ViewController: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: scan.pageCount-1)
        processImage(image: image)
        dismiss(animated: true)
    }
    
    func processImage(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        let handler = VNImageRequestHandler(cgImage: cgImage)
        let request = VNDetectBarcodesRequest { request, error in
            if let observation = request.results?.first as? VNBarcodeObservation, observation.symbology == .qr {
                DispatchQueue.main.async {
                    self.showMessageViewController(body: observation.payloadStringValue, recipients: ["1922"])
                }
            }
        }
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
}

