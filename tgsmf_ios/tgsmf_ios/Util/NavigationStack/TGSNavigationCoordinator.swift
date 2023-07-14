//
//  TGSNavigationCoordinator.swift
//  tgsmf_ios
//
//  Created by xamarin dev on 2023/01/12.
//

import SwiftUI
import Combine


///     @StateObject var coordinator = TGSNavigationCoordinator()
///
///     LazyVStack {
///     coordinator.navigationLinkSection()
///         ...
///         }
///
///         self.coordinator.push(destination: .login)


//fileprivate extension Notification.Name {
//    static let popToRoot = Notification.Name("PopToRoot")
//}
//
//
//public final class TGSNavigationCoordinator: ObservableObject {
//    private var destination: TGSNavigationDestination = .main
//   
//    private let isRoot: Bool
//    private var cancellable: Set<AnyCancellable> = []
//    @Published private var navigationTrigger = false
//    @Published private var rootNavigationTrigger = false
//    
//    public init(isRoot: Bool = false) {
//        self.isRoot = isRoot
//        
//        if isRoot {
//            NotificationCenter.default.publisher(for: .popToRoot)
//                .sink { [unowned self] _ in
//                    rootNavigationTrigger = false
//                }
//                .store(in: &cancellable)
//        }
//    }
//    
//    @ViewBuilder
//    public func navigationLinkSection() -> some View {
//        NavigationLink(isActive: Binding<Bool>(get: getTrigger, set: setTrigger(newValue:))) {
//            destination.view
//        } label: {
//            EmptyView()
//        }
//    }
//    
//    public func popToRoot() {
//        NotificationCenter.default.post(name: .popToRoot, object: nil)
//    }
//    
//    public func push(destination: TGSNavigationDestination) {
//        self.destination = destination
//        if isRoot {
//            rootNavigationTrigger.toggle()
//        } else {
//            navigationTrigger.toggle()
//        }
//    }
//    
//    
//    private func getTrigger() -> Bool {
//        isRoot ? rootNavigationTrigger : navigationTrigger
//    }
//    
//    private func setTrigger(newValue: Bool) {
//        if isRoot {
//            rootNavigationTrigger = newValue
//        } else {
//            navigationTrigger = newValue
//        }
//    }
//}
