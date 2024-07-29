//
//  StatisticsViewController.swift
//  KHR
//
//  Created by Reham Khalil on 22/07/2024.
//

import UIKit

class StatisticsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Statistics"
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hiddenNavigation(isHidden: false)
    }
    
    
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(StatisticsTableViewCell.self)
    }
    @IBAction func continueButtonAction(_ sender: Any) {
        let vc = CartViewController.loadFromNib()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension StatisticsViewController: UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StatisticsTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         10
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableViewHight.constant = self.tableView.contentSize.height
        }
    }
    
}
