//
//  RootDependencyContainer.swift
//  DependencyLifeCycle
//
//  Created by Chris on 01.02.23.
//

import Foundation


class RootDependencyContainer {

    /// internal store for the dependencies
    private class Store {
        var network: Networkable?

        enum LifeCycle {
            case singleton
            case recreateOnMemoryWarning
        }

        /// defines the lifecycle behavior of each individual dependency
        func lifecycle<T>(for keyPath: KeyPath<Store, T?>) -> LifeCycle {
            switch keyPath {
                case \.network:
                    return .recreateOnMemoryWarning
                default:
                    assertionFailure("every key path should be mapped")
                    return .singleton
            }
        }
    }

    private var store = Store()

    func handleMemoryWarning() {
        clearRecreatableInstances()

    }

    private var cleanupTasks = [() -> ()]()

    private func clearRecreatableInstances() {
        for task in cleanupTasks {
            task()
        }
    }

    /// resolves a dependency for a keypath and sets it if its not existing
    private func resolve<T>(keyPath: ReferenceWritableKeyPath<Store, T?>, factory: () -> T) -> T {
        guard let existing = store[keyPath: keyPath] else {
            let newInstance = factory()
            fill(instance: newInstance, into: keyPath)
            return newInstance
        }
        return existing
    }

    private func fill<T>(instance: T, into keyPath: WritableKeyPath<Store,T?>) {
        let lifeCycle = store.lifecycle(for: keyPath)
        switch lifeCycle {
            case .recreateOnMemoryWarning:
                cleanupTasks.append {
                    self.store[keyPath: keyPath] = nil
                    print("erasing instance for keyPath: \(keyPath)")
                }
            case .singleton:
                // nothing to do
                break
        }
        store[keyPath: keyPath] = instance
        print("created singleton for keypath: \(keyPath)")
    }

    fileprivate let factory = RootDependencyFactory()

    private(set) var _network: Network?


}

extension RootDependencyContainer: NetworkProviding {
    var network: Networkable { resolve(keyPath: \.network) { factory.makeNetwork() } }
}


