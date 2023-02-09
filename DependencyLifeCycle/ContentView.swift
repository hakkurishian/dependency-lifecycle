//
//  ContentView.swift
//  DependencyLifeCycle
//
//  Created by Chris on 31.01.23.
//

import SwiftUI

struct ContentView: View {

    let packageList: PackageList

    var body: some View {
        packageList.PackageList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(packageList: PackageList(dependencies: .init(network: NetworkMockProvider())))
    }
}

struct NetworkMockProvider: NetworkProviding {
    var network: Networkable { NetworkMock() }

}

struct NetworkMock: Networkable {
    func call(url: String, method: NetworkMethod) -> String {
        return "mock"
    }


}
