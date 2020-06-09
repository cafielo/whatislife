//
//  HistoryViewController.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/04/10.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        HistoryManager.shared.retrieveHistory()
        tableView.reloadData()
        emptyView.isHidden = !HistoryManager.shared.histories.isEmpty
        print("--> \(HistoryManager.shared.histories)")
    }
}


extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HistoryManager.shared.histories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else { return UITableViewCell() }
        
        let history = HistoryManager.shared.histories[indexPath.row]
        cell.iconImageView.image = history.type.icon
        cell.typeTitleLabel.text = history.type.title
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yy/MM/dd HH:mm"
        let timestamp = formatter.string(from: Date(timeIntervalSince1970: history.timestamp))
        cell.timestampLabel.text = timestamp
        
        return cell
    }
}

extension HistoryViewController: UITableViewDelegate {
    
}


class HistoryCell: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
}
