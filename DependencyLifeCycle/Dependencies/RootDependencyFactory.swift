//
//  RootDependencyFactory.swift
//  DependencyLifeCycle
//
//  Created by Chris on 01.02.23.
//

import Foundation


struct RootDependencyFactory {

    private func makeAlamofire() -> Alamofire {
        Alamofire()
    }

    func makeNetwork() -> Network {
        Network(alamofire: makeAlamofire())
    }
}
