//
//  TrackingCompletionOverlay.swift
//  Tracking
//
//  Created by Claude on 1/24/26.
//

import SwiftUI
import DesignSystem

struct TrackingCompletionOverlay: View {

    let color: Color
    var onAnimationComplete: (() -> Void)?

    @State private var circleScale: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var isCheckSymbolAnimating: Bool = false

    var body: some View {
        GeometryReader { geometry in
            let size = max(geometry.size.width, geometry.size.height)
            Circle()
                .fill(color)
                .frame(width: size, height: size)
                .scaleEffect(circleScale)
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                .overlay {
                    VStack(spacing: 20) {
                        Image(systemName: Symbol.checkmark_square_fill.symbolName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .foregroundStyle(DesignSystem.Colors.gray0.swiftUIColor)
                            .symbolEffect(
                                .bounce,
                                options: .repeat(1),
                                isActive: isCheckSymbolAnimating
                            )

                        Text("블럭 생산을 완료했어요!")
                            .brandFont(.pretendard(.semiBold), 20)
                            .foregroundStyle(DesignSystem.Colors.gray0.swiftUIColor)
                    }
                    .opacity(contentOpacity)
                }
        }
        .ignoresSafeArea()
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        Task {
            
            // 1. 원 애니메이션
            withAnimation(.bouncy(duration: 2.5)) {
                circleScale = 2
            }
            
            try? await Task.sleep(for: .seconds(0.8))
            
            // 2. 전체 콘텐츠 보여주기
            withAnimation(.easeOut(duration: 0.5)) {
                contentOpacity = 1
            }
            
            try? await Task.sleep(for: .seconds(0.5))

            // 3. 체크 아이콘 애니메이션
            isCheckSymbolAnimating = true
            
            // 4. 애니메이션 완료
            onAnimationComplete?()
        }
    }
}
