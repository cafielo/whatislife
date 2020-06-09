//
//  HistoryManager.swift
//  EggBoilingTimer
//
//  Created by joonwon lee on 2020/05/20.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import Foundation

class HistoryManager {
    static let shared = HistoryManager()
    
    private (set) var histories: [BoilingHistory] = []
    
    func addHistory(_ history: BoilingHistory) {
        self.histories.insert(history, at: 0)
        Storage.saveTodo(self.histories, fileName: "history.json")
    }
    
    func retrieveHistory() {
        histories = Storage.retrive("history.json", from: .documents, as: [BoilingHistory].self) ?? []
    }
}
