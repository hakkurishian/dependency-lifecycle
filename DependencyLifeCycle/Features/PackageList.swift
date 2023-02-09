//
//  PackageList.swift
//  DependencyLifeCycle
//
//  Created by Chris on 01.02.23.
//

import Foundation
import SwiftUI

// public part of  a framework module
struct PackageList {


    struct Dependencies {
        let network: NetworkProviding
    }

    let dependencies: Dependencies
    
    func PackageList() -> PackageListView {
        PackageListView(packageListViewModel: PackageListViewModel(networkProviding: dependencies.network))
    }

}


struct PackageListView: View {
    @StateObject var packageListViewModel: PackageListViewModel

    var body: some View {
        VStack {
            Button("make network request") {
                packageListViewModel.makeRequest()
            }.font(.title)
            Spacer()
            ForEach(packageListViewModel.responses.reversed() ) { response in
                Text(response)
                    .font(.title3)
            }
        }.padding(100)

    }
}


extension String: Identifiable {
    public var id: UUID { UUID() }
}

class PackageListViewModel: ObservableObject {


    let networkProviding: NetworkProviding

    @Published var responses = [String]()

    func makeRequest(){
        responses.append(networkProviding.network.call(url: "📦 package", method: .get))
    }

    init(networkProviding: NetworkProviding) {
        self.networkProviding = networkProviding
    }

}
