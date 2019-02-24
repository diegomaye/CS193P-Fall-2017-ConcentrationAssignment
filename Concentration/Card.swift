//
//  Card.swift
//  Concentration
//
//  Created by diegomaye on 2/10/19.
//  Copyright © 2019 Diego Maye. All rights reserved.
//

import Foundation

struct Card : Hashable
{
    var hashValue: Int{return identifier}
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.identifier == rhs.identifier
    }

    var isFaceUp = false
    var isMatched = false
    private let identifier : Int
    var hasBeenFlipped = false
    
    private static var identifierFactory = -1
    
    static func resetIdentifiersFactory() {
        identifierFactory = -1
    }
    
    private static func getUniqueIdentifier() -> Int {
        identifierFactory += 1
        return identifierFactory
    }
    
    init() {
        self.identifier = Card.getUniqueIdentifier();
    }
    
    mutating func flipCard() {
        isFaceUp = !isFaceUp
    }
    
    mutating func setFaceDown() {
        if isFaceUp {
            isFaceUp = false
        }
    }
}
