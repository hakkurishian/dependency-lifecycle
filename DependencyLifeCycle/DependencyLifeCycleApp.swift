//
//  DependencyLifeCycleApp.swift
//  DependencyLifeCycle
//
//  Created by Chris on 31.01.23.
//

import SwiftUI

@main
struct DependencyLifeCycleApp: App {

    private let dependencies = RootDependencyContainer()

    var body: some Scene {
        WindowGroup {
            ContentView(packageList: PackageList(dependencies: .init(network: dependencies)))
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification, object: nil)) { notification in
                handleMemoryWarning()
            }
        }
    }


    private func handleMemoryWarning() {
        dependencies.handleMemoryWarning()
    }
}
