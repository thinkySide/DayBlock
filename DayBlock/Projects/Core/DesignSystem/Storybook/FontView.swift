//
//  FontView.swift
//  Storybook
//
//  Created by 김민준 on 12/7/25.
//

import SwiftUI
import DesignSystem

struct FontView: View {
    
    @State private var textSize: CGFloat = 20
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: textSize) {
                Text("Pretendard/Regular")
                    .brandFont(.pretendard(.regular), textSize)
                
                Text("Pretendard/Medium")
                    .brandFont(.pretendard(.medium), textSize)
                
                Text("Pretendard/SemiBold")
                    .brandFont(.pretendard(.semiBold), textSize)
                
                Text("Pretendard/Bold")
                    .brandFont(.pretendard(.bold), textSize)
                
                Divider()
                
                Text("Poppins/SemiBold")
                    .brandFont(.pretendard(.semiBold), textSize)
                
                Text("Poppins/Bold")
                    .brandFont(.poppins(.bold), textSize)
                
                Spacer()
            }
            
            VStack(spacing: 4) {
                Text("\(Int(textSize))")
                    .brandFont(.poppins(.semiBold), 16)
                    .foregroundStyle(.blue)
                
                Slider(value: $textSize, in: 8...32, step: 1)
                    .frame(width: 160)
            }
        }
        .padding()
    }
}

#Preview {
    DesignSystemPreview {
        FontView()
    }
}
