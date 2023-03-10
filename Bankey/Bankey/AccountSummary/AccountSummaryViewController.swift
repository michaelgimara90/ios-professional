//
//  AccountSummaryViewController.swift
//  Bankey
//
//  Created by Michael Gimara on 13/02/2023.
//

import UIKit

class AccountSummaryViewController: UIViewController {
    
    // View Models
    var headerViewModel = AccountSummaryHeaderView.ViewModel(welcomeMessage: "Welcome", name: "", date: Date())
    var accountCellViewModels: [AccountSummaryCell.ViewModel] = []
    
    // Components
    var tableView = UITableView()
    var headerView = AccountSummaryHeaderView(frame: .zero)
    let refreshControl = UIRefreshControl()
    lazy var errorAlert: UIAlertController = {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alert
    }()
    
    // Networking
    var webService: AccountSummaryWebServiceProtocol = AccountSummaryWebService.shared
    
    var isLoaded: Bool = false
    
    lazy var logoutBarButtonItem: UIBarButtonItem = {
        let barButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutBarButtonTapped))
        barButtonItem.tintColor = .label
        return barButtonItem
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}

extension AccountSummaryViewController {
    private func setup() {
        setupNavigationBar()
        setupTableView()
        setupTableHeaderView()
        setupRefreshControl()
        setupSkeletons()
        fetchData()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = logoutBarButtonItem
    }
    
    private func setupTableView() {
        tableView.backgroundColor = appColor
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(AccountSummaryCell.self, forCellReuseIdentifier: AccountSummaryCell.reuseId)
        tableView.register(SkeletonCell.self, forCellReuseIdentifier: SkeletonCell.reuseId)
        tableView.rowHeight = AccountSummaryCell.rowHeight
        tableView.tableFooterView = UIView()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func setupTableHeaderView() {
        var size = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        size.width = UIScreen.main.bounds.width
        headerView.frame.size = size
        tableView.tableHeaderView = headerView
        headerView.configure(with: headerViewModel)
    }
    
    private func setupRefreshControl() {
        refreshControl.tintColor = appColor
        refreshControl.addTarget(self, action: #selector(refreshContent), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSkeletons() {
        let account = Account.makeSkeleton()
        configureTableCellViewModels(with: Array(repeating: account, count: 10))
    }
}

extension AccountSummaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard !accountCellViewModels.isEmpty else { return UITableViewCell() }
        
        let accountCellViewModel = accountCellViewModels[indexPath.row]
        
        if isLoaded {
            let cell = tableView.dequeueReusableCell(withIdentifier: AccountSummaryCell.reuseId, for: indexPath) as! AccountSummaryCell
            cell.configure(with: accountCellViewModel)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: SkeletonCell.reuseId, for: indexPath) as! SkeletonCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accountCellViewModels.count
    }
}

extension AccountSummaryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: Networking
extension AccountSummaryViewController {
    private func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        // Testing - random number selection
        let userId = String(Int.random(in: 1..<4))
        
        fetchProfile(dispatchGroup: dispatchGroup, userId: userId)
        fetchAccounts(dispatchGroup: dispatchGroup, userId: userId)
        
        dispatchGroup.notify(queue: .main) {
            self.reloadView()
        }
    }
    
    private func fetchProfile(dispatchGroup: DispatchGroup, userId: String) {
        dispatchGroup.enter()
        webService.fetchProfile(forUserId: userId) { result in
            switch result {
            case .success(let profile):
                self.configureTableHeaderViewModel(with: profile)
            case .failure(let error):
                self.displayError(error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func fetchAccounts(dispatchGroup: DispatchGroup, userId: String) {
        dispatchGroup.enter()
        webService.fetchAccounts(forUserId: userId) { result in
            switch result {
            case .success(let accounts):
                self.configureTableCellViewModels(with: accounts)
            case .failure(let error):
                self.configureTableCellViewModels(with: [])
                self.displayError(error)
            }
            dispatchGroup.leave()
        }
    }
    
    private func configureTableHeaderViewModel(with profile: Profile) {
        headerViewModel = AccountSummaryHeaderView.ViewModel(
            welcomeMessage: "Good morning,",
            name: profile.firstName,
            date: Date()
        )
    }
    
    private func configureTableCellViewModels(with accounts: [Account]) {
        accountCellViewModels = accounts.map {
            AccountSummaryCell.ViewModel(
                accountType: $0.type,
                accountName: $0.name,
                balance: $0.amount
            )
        }
    }
    
    private func reloadView() {
        isLoaded = true
        headerView.configure(with: headerViewModel)
        tableView.reloadData()
        tableView.refreshControl?.endRefreshing()
    }
    
    private func displayError(_ error: NetworkError) {
        let titleAndMessage = titleAndMessageForError(error)
        showErrorAlert(title: titleAndMessage.0, message: titleAndMessage.1)
    }
    
    private func titleAndMessageForError(_ error: NetworkError) -> (String, String) {
        let title: String
        let message: String
        switch error {
        case .serverError:
            title = "Server Error"
            message = "Ensure you are connected to the internet. Please try again."
        case .decodingError:
            title = "Decoding Error"
            message = "We could not process your request. Please try again."
        }
        return (title, message)
    }
    
    private func showErrorAlert(title: String, message: String) {
        errorAlert.title = title
        errorAlert.message = message
        DispatchQueue.main.async {
            self.present(self.errorAlert, animated: true, completion: nil)
        }
    }
}

// MARK: Actions
extension AccountSummaryViewController {
    @objc func logoutBarButtonTapped(sender: UIBarButtonItem) {
        NotificationCenter.default.post(name: .logout, object: nil)
    }
    
    @objc func refreshContent(sender: UIRefreshControl) {
        isLoaded = false
        setupSkeletons()
        tableView.reloadData()
        fetchData()
    }
}

// MARK: - Unit Tests
extension AccountSummaryViewController {
    func testTitleAndMessageForError(_ error: NetworkError) -> (String, String) {
        return titleAndMessageForError(error)
    }
    
    func testFetchProfile() {
        fetchProfile(dispatchGroup: DispatchGroup(), userId: "1")
    }
    
    func testFetchAccounts() {
        fetchAccounts(dispatchGroup: DispatchGroup(), userId: "1")
    }
}
