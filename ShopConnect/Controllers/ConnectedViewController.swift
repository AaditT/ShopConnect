//
//  ConnectedViewController.swift
//  ShopConnect
//
//  Created by Aadit Trivedi on 7/12/20.
//  Copyright © 2020 Aadit Trivedi. All rights reserved.
//

import Foundation
import UIKit

class ConnectedViewController: UIViewController {
    
    var availableMessage: String?
    var number: String?
    var typeLabelText: String?
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var unavailableMessage: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (availableMessage != "") {
            unavailableMessage.isHidden = false
            unavailableMessage.text = availableMessage
            typeLabel.isHidden = true
            numberLabel.isHidden = true
        } else if (availableMessage == "") {
            unavailableMessage.isHidden = true
            numberLabel.isHidden = false
            typeLabel.isHidden = false
            numberLabel.text = number
            typeLabel.text = typeLabelText
        }
        
    }
    
    
}
