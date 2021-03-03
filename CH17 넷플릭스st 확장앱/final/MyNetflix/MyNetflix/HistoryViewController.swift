//
//  HistoryViewController.swift
//  MyNetflix
//
//  Created by joonwon lee on 2020/04/16.
//  Copyright © 2020 com.joonwon. All rights reserved.
//

import UIKit
import Firebase

class HistoryViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var searchTerms: [SearchTerm] = []
    
    let db = Database.database().reference().child("searchHistory")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        db.observeSingleEvent(of: .value) { snapshot in
            guard let searchHistory = snapshot.value as? [String: Any] else { return }
            let data = try! JSONSerialization.data(withJSONObject: Array(searchHistory.values), options: [])
            let decoder = JSONDecoder()
            let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
            self.searchTerms = searchTerms.sorted { $0.timestamp > $1.timestamp }
            self.tableView.reloadData()
            print("--- \(searchTerms)")
        }
    }
}


extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as? HistoryCell else {
            return UITableViewCell()
        }
        cell.searchTerm.text = searchTerms[indexPath.row].term
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchTerms.count
    }
}

class HistoryCell: UITableViewCell {
    @IBOutlet weak var searchTerm: UILabel!
}

struct SearchTerm: Codable {
    let term: String
    let timestamp: TimeInterval
}
