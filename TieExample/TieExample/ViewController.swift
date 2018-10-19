//
//  ViewController.swift
//  TieExample
//
//  Copyright © 2018 Artificial Solutions. All rights reserved.
//

import UIKit
import TieApiClient

class ViewController: UIViewController {

    @IBOutlet var message: UITextView!
    @IBOutlet var param1Key: UITextField!
    @IBOutlet var param1Value: UITextField!
    @IBOutlet var param2Key: UITextField!
    @IBOutlet var param2Value: UITextField!
    @IBOutlet var response: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NOTE: Replace with correct base url and endpoint
        try? TieApiService.sharedInstance.setup(BASE_URL, endpoint: ENDPOINT)
    }

    @IBAction func sendMessage(_ sender: UIButton) {
        guard let msg = message.text else { return }
        var params = [String: String]()
        if let key = param1Key.text, let value = param1Value.text {
            params[key] = value
        }
        if let key = param2Key.text, let value = param2Value.text {
            params[key] = value
        }

        TieApiService.sharedInstance.sendInput(msg, parameters: params, success: {
            guard let encoded = try? JSONEncoder().encode($0) else { return }
            let responseText = String(data: encoded, encoding: .utf8)

            DispatchQueue.main.async {
                self.response.text = responseText
            }
        }, failure: nil)
    }

    @IBAction func closeSession(_ sender: UIButton) {
        TieApiService.sharedInstance.closeSession({
            guard let encoded = try? JSONEncoder().encode($0) else { return }
            let responseText = String(data: encoded, encoding: .utf8)
            DispatchQueue.main.async {
                self.response.text = responseText
            }
        }, failure: nil)
    }
}
