//
//  CardViewModel.swift
//  BrokerNetworkIOS
//
//  Created by Gaurav on 17/05/22.
//

import Foundation

typealias isCompleted = (Bool,String) -> ()

protocol PCardViewModel {
    func getAllCards()
}

class CardViewModel: PCardViewModel {
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var cardsArray: [Card] = []
    
    var cardsFetched: (() -> Void)?
    var failedToFetchCards: ((String) -> Void)?
    var updateLoadingStatus: (() -> Void)?

    
    func getAllCards() {
        
        if Reachability.isConnectedToNetwork() {
            
            self.isLoading = true
           
            APIService.callService(service: .getAllCards) { [self] (result:Swift.Result<CardModel, CustomError>) in
                
                self.isLoading = false
                
                switch result {
                    
                case .success(let cardData):
                    if let cards = cardData.cards, !cards.isEmpty {
                        // Data found
                        cardsArray = cards
                        cardsFetched?()
                    } else {
                        // Data not found
                        failedToFetchCards?(Constants.noDataFound)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                    failedToFetchCards?(error.localizedDescription)
                }
            }
        } else {
            failedToFetchCards?(Constants.noInternet)
        }
    }
    
    func getNumberOfRow() -> Int {
        return cardsArray.count
    }
    
    func getHorizontalCardCount(rowIndex: Int) -> Int {
        return cardsArray[rowIndex].data?.horizontalCards?.count ?? 0
    }
}
