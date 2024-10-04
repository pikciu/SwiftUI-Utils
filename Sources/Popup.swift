import SwiftUI

extension View {

    public func popup(
        isPresented: Binding<Bool>,
        popupView: @escaping () -> some View
    ) -> some View {
        modifier(PopupModifier(isPresented: isPresented, popupView: popupView))
    }
    
    public func popup<T: Sendable>(
        onChange: Binding<T?>,
        popupView: @escaping (T) -> some View
    ) -> some View {
        let popup = PopupModifier(isPresented: onChange.isNotNil()) {
            popupView(onChange.wrappedValue!)
        }
        return modifier(popup)
    }

    func clearBackground(didMoveToWindow: @escaping () -> Void) -> some View {
        background(ClearBackgroundView(didMoveToWindow: didMoveToWindow))
    }
}

struct PopupModifier<PopupView: View>: ViewModifier {

    @Binding private var isPresented: Bool
    private let popupView: () -> PopupView

    @State private var isFullScreenCoverPresented: Bool
    @State private var isContentPresented: Bool

    init(isPresented: Binding<Bool>, popupView: @escaping () -> PopupView) {
        _isPresented = isPresented
        self.popupView = popupView
        isFullScreenCoverPresented = isPresented.wrappedValue
        isContentPresented = isPresented.wrappedValue
    }

    func body(content: Content) -> some View {
        content
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    isFullScreenCoverPresented = true
                } else {
                    isContentPresented = false
                }
            }
            .fullScreenCover(isPresented: $isFullScreenCoverPresented) {
                ZStack(alignment: .bottom) {
                    if isContentPresented {
                        Color.black.opacity(isContentPresented ? 0.15 : 0)
                            .transition(.opacity)
                            .onTapGesture {
                                withAnimation {
                                    isContentPresented = false
                                }
                            }
                            .zIndex(0)
                        popupView()
                            .onDisappear {
                                withoutAnimation {
                                    isFullScreenCoverPresented = false
                                    isPresented = false
                                }
                            }
                            .zIndex(1)
                    }
                }
                .ignoresSafeArea(.container)
                .clearBackground {
                    withAnimation {
                        isContentPresented = true
                    }
                }
            }
    }
}

private struct ClearBackgroundView: UIViewRepresentable {

    let didMoveToWindow: () -> Void

    func makeUIView(context: Context) -> UIView {
        let backgroundView = BackgroundView()
        backgroundView.action = didMoveToWindow
        return backgroundView
    }

    func updateUIView(_ uiView: UIView, context: Context) {}

    private class BackgroundView: UIView {

        var action: () -> Void = {}

        override func didMoveToWindow() {
            super.didMoveToWindow()

            superview?.superview?.backgroundColor = .clear
            superview?.superview?.layer.removeAllAnimations()
            if window != nil {
                action()
            }
        }
    }
}
