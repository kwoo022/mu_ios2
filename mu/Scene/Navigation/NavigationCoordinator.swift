import SwiftUI
import Combine
import tgsmf_ios

//MARK: 메인화면으로 한번에 이동을 위한 알림
fileprivate extension Notification.Name {
    static let popToRoot = Notification.Name("PopToRoot")
}

public final class NavigationCoordinator: ObservableObject {
    private var destination: NavigationDestination = .none
    
    
    private let isRoot: Bool
    private var cancellable: Set<AnyCancellable> = []
    @Published private var navigationTrigger = false
    @Published private var rootNavigationTrigger = false
    
    public init(isRoot: Bool = false) {
        self.isRoot = isRoot
        if isRoot {
            NotificationCenter.default.publisher(for: .popToRoot)
                .sink { [unowned self] _ in
                    rootNavigationTrigger = false
                }
                .store(in: &cancellable)
        }
    }
    
    @ViewBuilder
    public func navigationLinkSection() -> some View {
        NavigationLink(isActive: Binding<Bool>(get: getTrigger, set: setTrigger(newValue:))) {
            destination.view
                .navigationBarHidden(true)
        } label: {
            EmptyView()
        }
    }
    
    public func popToRoot() {
        NotificationCenter.default.post(name: .popToRoot, object: nil)
    }
    
    public func push(destination: NavigationDestination) {
        self.destination = destination
        if isRoot {
            rootNavigationTrigger.toggle()
        } else {
            navigationTrigger.toggle()
        }
    }
    
    public func getTriggerBinding() -> Binding<Bool> {
        return Binding<Bool>(get: getTrigger, set: setTrigger(newValue:))
    }
    
    private func getTrigger() -> Bool {
        isRoot ? rootNavigationTrigger : navigationTrigger
    }
    
    private func setTrigger(newValue: Bool) {
        if isRoot {
            rootNavigationTrigger = newValue
        } else {
            navigationTrigger = newValue
        }
    }
}
