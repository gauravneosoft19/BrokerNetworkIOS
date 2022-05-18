//
//  CardTableViewCell.swift
//  BrokerNetworkIOS
//
//  Created by Gaurav on 17/05/22.
//

import UIKit

protocol CardCellDelegate {
    func optionsTapped(tableRowIndex: Int)
    func callTapped(tableRowIndex: Int, collectionRowIndex: Int)
    func sendMessageTapped(tableRowIndex: Int, collectionRowIndex: Int)
    func closedTapped(tableRowIndex: Int, collectionRowIndex: Int)
}

class CardTableViewCell: UITableViewCell {
    
    static let nibName = Constants.NibNames.cardTableViewCell
    
    //MARK: Outlets
    @IBOutlet weak var userImageBGView: UIView!
    @IBOutlet weak var propertyTypeLabel: UILabel!
    @IBOutlet weak var propertyShortDescLabel: UILabel!
    @IBOutlet weak var requirementDetailLabel: UILabel!
    @IBOutlet weak var containerCardView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var matchCountLabel: UILabel!
    
    //MARK: Properties
    var viewModel: CardViewModel!
    var rowIndex: Int!
    var delegate: CardCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initialSetup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initialSetup() {
        configCollectionCell()
        userImageBGView.cornerRadius(cornerRadius: userImageBGView.frame.height / 2)
        
        containerCardView.cornerRadius(cornerRadius: 20)
        matchCountLabel.cornerRadius(borderWidth: 2, cornerRadius: matchCountLabel.frame.height / 2)
        
    }
    
    private func configCollectionCell() {
        // Register card nib with collectionView
        let nib = UINib(nibName: CardCollectionViewCell.nibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Constants.CellIdentifiers.kCollectionCardCellIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.cornerRadius(cornerRadius: 20)
    }
    
    func setCell() {
        let card = viewModel.cardsArray[rowIndex]
        propertyTypeLabel.text = card.data?.mainPost?.title?.uppercased()
        if let type = card.data?.mainPost?.type?.name, let typeEnum = TypeClassEnum(rawValue: type) {
            propertyTypeLabel.textColor = typeEnum.getTypeColor()
            userImageBGView.backgroundColor = typeEnum.getTypeColor()
            self.pageControl.currentPageIndicatorTintColor = typeEnum.getTypeColor()
        }
        propertyShortDescLabel.text = card.data?.mainPost?.subInfo?.compactMap{$0.text}.joined(separator: "•")
        requirementDetailLabel.text = card.data?.mainPost?.info
        matchCountLabel.text = "\(card.data?.mainPost?.matchCount ?? 0)"
        self.pageControl.numberOfPages = card.data?.horizontalCards?.count ?? 0
    }
    
    
    //MARK: Actions
    @IBAction func optionButtonTapped(_ sender: Any) {
        delegate?.optionsTapped(tableRowIndex: self.rowIndex)
    }
}

//MARK: UICollectionViewDataSource
extension CardTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getHorizontalCardCount(rowIndex: rowIndex)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.CellIdentifiers.kCollectionCardCellIdentifier, for: indexPath) as! CardCollectionViewCell
        
        cell.cornerRadius(cornerRadius: 20)
        
        if let horizontalCard = viewModel.cardsArray[rowIndex].data?.horizontalCards?[indexPath.row] {
            cell.setCell(horizontalCard: horizontalCard)
        }
        
        cell.sendMessageCallBack = {
            self.delegate?.sendMessageTapped(tableRowIndex: self.rowIndex, collectionRowIndex: indexPath.row)
        }
        
        cell.callButtonCallBack = {
            self.delegate?.callTapped(tableRowIndex: self.rowIndex, collectionRowIndex: indexPath.row)
        }
        
        cell.closeButtonCallBack = {
            self.delegate?.closedTapped(tableRowIndex: self.rowIndex, collectionRowIndex: indexPath.row)
        }
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: self.collectionView.contentOffset, size: self.collectionView.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.collectionView.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    
}
//MARK: UICollectionViewDelegateFlowLayout
extension CardTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height: CGFloat = 290
        return CGSize(width: collectionView.frame.width - 20, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
                        collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}


