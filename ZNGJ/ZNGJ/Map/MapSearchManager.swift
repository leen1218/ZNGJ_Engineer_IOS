//
//  MapSearchManager.swift
//  ZNGJ
//
//  Created by HuangBing on 1/23/17.
//  Copyright © 2017 en li. All rights reserved.
//

import Foundation

class MapSearchManager : NSObject, AMapSearchDelegate {
    
    class CustomSearchResponse {
        var response: AMapPOISearchResponse!
        var orderIds: [Int] = []
    }
    
    fileprivate static let maxRequestCount = 10
    fileprivate var search: AMapSearchAPI!
    fileprivate var requests: [AMapPOIKeywordsSearchRequest] = []
    
    var resultMap: [String : CustomSearchResponse] = [:]
    var searchLock: NSObject!
    var requestIndex: Int = 0
    var requestCount: Int = 0
    var responseCount: Int = 0
    
    weak var delegate: MapSearchManagerDelegate?
    
    init(orders: [Order]) {
        super.init()
        self.search = AMapSearchAPI()
        self.search.delegate = self
        self.searchLock = NSObject()
        initOrderDictionaryAndRequests(orders)
    }
    
    func initOrderDictionaryAndRequests(_ orders: [Order]) {
        // after this method, we could get exactly how many reuqests we need. we ill remove duplication here
        for item in orders {
            // this if can be used to check if key exists in dictionary according to http://stackoverflow.com/questions/29299727/check-if-key-exists-in-dictionary-of-type-typetype
            // While if the key exists, we don't need to send the request again
            if resultMap[item.orderAddress] == nil {
                resultMap[item.orderAddress] = CustomSearchResponse()
            }
            resultMap[item.orderAddress]?.orderIds.append(item.orderId)
        }
        
        for item in resultMap.keys {
            let request = AMapPOIKeywordsSearchRequest()
            request.keywords = item;
            self.requests.append(request)
        }
    }
    
    func beginSearch() {
        let loopSize = min(MapSearchManager.maxRequestCount, self.requests.count)
        for i in 0..<loopSize {
            executeRequest(self.requests[i])
            synchronizd(self.searchLock) {
                requestIndex += 1
                requestCount += 1
            }
            
        }
    }
    
    func cancelAllSearches() {
        self.search.cancelAllRequests()
    }
    
    func executeRequest(_ request: AMapPOIKeywordsSearchRequest) {
        self.search.aMapPOIKeywordsSearch(request)
    }
    
    // MARK: AMapSearchDelegate
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        if let newRequest = request as? AMapPOIKeywordsSearchRequest {
            Logger.logToConsole("Search FAILED. Address \(newRequest.keywords)")
        }
        self.onResponse()
        
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        if let newRequest = request as? AMapPOIKeywordsSearchRequest {
            Logger.logToConsole("Search SUCCESS. Address \(newRequest.keywords)")
            resultMap[newRequest.keywords]?.response = response
            self.onResponse()
        }
    }
    
    func onResponse() {
        if (self.isSearchFinish()) {
            delegate?.onSearchesFinish()
        } else {
            self.executeNewSearchIfNeeded()
        }
    }
    
    func isSearchFinish() -> Bool {
        synchronizd(searchLock) {
            self.responseCount += 1
        }
        if (self.responseCount == self.requests.count) {
            return true
        } else {
            return false
        }
    }
    
    func executeNewSearchIfNeeded() {
        synchronizd(searchLock) {
            requestCount -= 1
        }
        if (requestCount < MapSearchManager.maxRequestCount) && (requestIndex < self.requests.count) {
            self.executeRequest(self.requests[requestIndex])
            
            synchronizd(searchLock) {
                requestIndex += 1
                requestCount += 1
            }
        }
    }
}

public protocol MapSearchManagerDelegate : NSObjectProtocol {
    func onSearchesFinish()
}
