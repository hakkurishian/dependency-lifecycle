//
//  Network.swift
//  DependencyLifeCycle
//
//  Created by Chris on 01.02.23.
//

import Foundation
import UIKit

protocol NetworkProviding {
    var network: Networkable { get }
}

protocol Networkable {
    func call(url: String, method: NetworkMethod) -> String
    
}

enum NetworkMethod: String {
    case get = "GET"
    case post = "POST"
}

class Network: Networkable {


    let uniqueSeriveId = Int.random(in: 0...1000)

    private var cache = [BigMemoryOccupier]()

    func call(url: String, method: NetworkMethod) -> String {
        Task.detached(priority: .background) { [weak self] in
            self?.cache.append(BigMemoryOccupier())
        }

        return "called \(method.rawValue)/\(url) called on \(uniqueSeriveId)"
    }

    init(alamofire: Alamofire) {
        
    }

    deinit {
        print("deinit network")
    }
}


struct BigMemoryOccupier {
    let uuids = (0...1000_000).map { _ in UUID() }
}
