import Observation

@Observable
public final class Navigation<T: Route> {
    public var stack = [T]()
    
    public init() { }

    public func push(_ route: T) {
        stack.append(route)
    }

    public func popToRoot() {
        stack.removeAll()
    }
}
