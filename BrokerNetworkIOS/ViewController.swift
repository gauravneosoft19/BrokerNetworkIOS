//
//  ViewController.swift
//  BrokerNetworkIOS
//
//  Created by Gaurav on 17/05/22.
//

import UIKit

class ViewController: UIViewController {

    //MARK: Outlets
    @IBOutlet var tableView: UITableView!
    
    //MARK: Properties
    var viewModel: CardViewModel = CardViewModel()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        self.activityIndicator = UIActivityIndicatorView(style: .medium)
        self.activityIndicator.center = self.view.center
        return self.activityIndicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialSetup()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func initialSetup() {
        
        // Register card nib with tableView
        let nib = UINib(nibName: CardTableViewCell.nibName, bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: Constants.CellIdentifiers.kTableCardCellIdentifier)
        
        self.tableView.dataSource = self
        self.tableView.delegate  = self
        
        // Activity Indicator
        addActivityIndicator()
        
        // Refresh Control
        addRefreshControl()
        
        viewModel.cardsFetched = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        viewModel.failedToFetchCards = { error in
            // An error occured
            Toast.show(message: error, controller: self)
        }
        
        viewModel.updateLoadingStatus = {
            DispatchQueue.main.async {
                if self.viewModel.isLoading {
                    self.activityIndicator.startAnimating()
                    self.tableView.alpha = 0.0
                } else {
                    self.activityIndicator.stopAnimating()
                    self.tableView.alpha = 1.0
                }
            }
        }
        viewModel.getAllCards()
        
        //Keyboard Observer to adjust scroll
        addKeyboardObserver()
    }

    private func addActivityIndicator() {
        self.view.addSubview(self.activityIndicator)
    }
    
    private func addRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: Constants.refresh)
        refreshControl.addTarget(self, action: #selector(self.refreshCalled(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refreshCalled(_ sender: UIRefreshControl) {
        viewModel.getAllCards()
        if sender.isRefreshing {
            sender.endRefreshing()
        }
    }
    
    private func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObserver()
    }
}

//MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRow()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.kTableCardCellIdentifier) as! CardTableViewCell
        cell.rowIndex = indexPath.row
        cell.viewModel = self.viewModel
        cell.setCell()
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension ViewController: UITableViewDelegate {}

//MARK: CardCellDelegate
extension ViewController: CardCellDelegate {
    
    func optionsTapped(tableRowIndex: Int) {
        Toast.show(message: "\(Constants.optionsTapped) \(tableRowIndex)", controller: self)
    }
    
    func callTapped(tableRowIndex: Int, collectionRowIndex: Int) {
        Toast.show(message: "\(Constants.callTapped)  \(tableRowIndex) \(collectionRowIndex)", controller: self)
    }
    
    func sendMessageTapped(tableRowIndex: Int, collectionRowIndex: Int) {
        Toast.show(message: "\(Constants.sendMessageTapped)  \(tableRowIndex) \(collectionRowIndex)", controller: self)
    }
    
    func closedTapped(tableRowIndex: Int, collectionRowIndex: Int) {
        Toast.show(message: "\(Constants.closeTapped)  \(tableRowIndex) \(collectionRowIndex) ", controller: self)
    }
}
