//
//  ChoiceController.swift
//  ShopConnect
//
//  Created by Aadit Trivedi on 7/9/20.
//  Copyright © 2020 Aadit Trivedi. All rights reserved.
//

import Foundation
import UIKit

class ChoiceController: UIViewController {
    
    
    @IBAction func orderPressed(_ sender: UIButton) {
    }
    
    @IBAction func deliverPressed(_ sender: UIButton) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "OrderToChoice") {
            let vc = segue.destination as! InfoViewController
            vc.orderType = "order"
        } else if (segue.identifier == "DeliverToChoice") {
            let vc = segue.destination as! InfoViewController
            vc.orderType = "deliver"
        }
    }

    
}
