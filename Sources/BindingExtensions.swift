import SwiftUI

extension Binding {
    
    public func isNotNil<T: Sendable>() -> Binding<Bool> where Value == T? {
        Binding<Bool>(
            get: { wrappedValue != nil },
            set: { newValue in
                if !newValue {
                    wrappedValue = nil
                }
            }
        )
    }
}
