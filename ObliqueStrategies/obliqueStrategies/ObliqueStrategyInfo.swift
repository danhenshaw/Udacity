//
//  ObliqueStrategyInfo.swift
//  obliqueStrategies
//
//  Created by Dan Henshaw on 7/11/17.
//  Copyright © 2017 Dan Henshaw. All rights reserved.
//

struct ObliqueStrategy {
    
    var strategy: String?
    var edition: Int?
    var id: Int?
    var cardnumber: Int?
    
    init(dictionary: [String: AnyObject]) {
        strategy = dictionary[ObliqueStrategyData.strategy] as? String ?? ""
        edition = dictionary[ObliqueStrategyData.edition] as? Int ?? 0
        id = dictionary[ObliqueStrategyData.id] as? Int ?? 0
        cardnumber = dictionary[ObliqueStrategyData.cardnumber] as? Int ?? 0
        
    }
    
    init() {
        
    }
}

struct ObliqueStrategies {
    
    static var dataArray = [[String: AnyObject]]()
    
}

struct ObliqueStrategyData {
    
    static var strategy = "strategy"
    static var edition = "edition"
    static var id = "id"
    static var cardnumber = "cardnumber"
}

struct JSONResponseKeys {
    
    static var strategy = "strategy"
    static var edition = "edition"
    static var id = "id"
    static var cardnumber = "cardnumber"
}
