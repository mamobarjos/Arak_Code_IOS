//
//  RankViewController.swift
//  Arak
//
//  Created by Abed Al-Rhman Qasim on 05/07/2021.
//

import UIKit

class RankViewController: UIViewController {
    
    @IBOutlet weak var rankTableView: UITableView!
    private var rankViewModel = RankViewModel()
    private var page = 1
    private var refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        rankTableView.register(RankCell.self)
        title = "Arak Ranking".localiz()
        setupRefershControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchTopRanking()
    }
    
    private func setupRefershControl() {
        if #available(iOS 10.0, *) {
            rankTableView.refreshControl = refreshControl
        } else {
            rankTableView.addSubview(refreshControl)
        }
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        refreshControl.endRefreshing()
        page = 1
        fetchTopRanking()
    }
    
    private func fetchTopRanking() {
        showLoading()
        rankViewModel.getTopRanking(page: page) { [weak self] (error) in
            defer {
              self?.stopLoading()
            }

            if error != nil {
              self?.showToast(message: error)
              return
            }
            self?.rankTableView.reloadData()
        }
    }
}
extension RankViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        rankViewModel.itemCount == 0 ?  self.rankTableView.setEmptyView(onClickButton: {
            self.fetchTopRanking()
        }) : self.rankTableView.restore()
        return rankViewModel.itemCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RankCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setup(with: rankViewModel.item(at: indexPath.row), rank: indexPath.row + 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 155
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == rankViewModel.itemCount - 1 && rankViewModel.hasMore {
            page += 1
            fetchTopRanking()
        }
    }
}
