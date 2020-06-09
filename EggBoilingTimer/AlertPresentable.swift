//
//  AlertPresentable.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/04/10.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

protocol AlertPresentable {
    var presenter: UIViewController { get }
    func showDefaultAlert(title: String, message: String, actionTitle: String)
}

extension AlertPresentable {
    func showDefaultAlert(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alert.addAction(action)
        presenter.present(alert, animated: true, completion: nil)
    }
}
