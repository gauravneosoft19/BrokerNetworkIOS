//
//  CardCollectionViewCell.swift
//  BrokerNetworkIOS
//
//  Created by Neosoft on 17/05/22.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    static let nibName = Constants.NibNames.cardCollectionViewCell
    
    @IBOutlet weak var propertyTypeLabel: UILabel!
    
    @IBOutlet weak var propertyDescLabel: UILabel!
    @IBOutlet weak var propertyDetailsLabel: UILabel!
    @IBOutlet weak var postedByNameLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var userBGContainer: UIView!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var textFieldStackView: UIStackView!
    @IBOutlet weak var homeImageBG: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    
    //MARK: Properties
    var sendMessageCallBack: (() -> Void)?
    var callButtonCallBack: (() -> Void)?
    var closeButtonCallBack: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }

    
    private func initialSetup() {
        homeImageBG.cornerRadius(cornerRadius: homeImageBG.frame.height / 2)
        userImageView.cornerRadius(borderWidth: 1, cornerRadius: userImageView.frame.height / 2)
        callButton.cornerRadius(cornerRadius: userImageView.frame.height / 2)
        userBGContainer.cornerRadius(cornerRadius: 15)
        messageTF.attributedPlaceholder = NSAttributedString(
            string: Constants.writeMessage,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]
        )
        textFieldStackView.cornerRadius(cornerRadius: 20)
        messageTF.delegate = self
    }
    
    func setCell(horizontalCard: HorizontalCard) {
        propertyTypeLabel.text = horizontalCard.title?.uppercased()
        propertyDescLabel.text = horizontalCard.subInfo?.compactMap{$0.text}.joined(separator: "•")
        propertyDetailsLabel.text = horizontalCard.info
        postedByNameLabel.text = horizontalCard.assignedTo?.name
        sourceLabel.text = horizontalCard.assignedTo?.orgName
        userImageView.loadImageUsingCacheWithUrlString(urlString: horizontalCard.assignedTo?.profilePicURL ?? "")
    }
    
    //MARK: Actions
    @IBAction func sendMessageButtonTapped(_ sender: Any) {
        self.sendMessageCallBack?()
        messageTF.resignFirstResponder()
    }
    
    
    @IBAction func callButtonTapped(_ sender: Any) {
        self.callButtonCallBack?()
        messageTF.resignFirstResponder()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        self.closeButtonCallBack?()
        messageTF.resignFirstResponder()
    }
}

extension CardCollectionViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
