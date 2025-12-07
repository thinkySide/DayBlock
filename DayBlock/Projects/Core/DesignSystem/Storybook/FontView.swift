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
        ScrollView {
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
            }
            .padding()
        }
    }
}

#Preview {
    DesignSystemFontFamily.registerAllCustomFonts()
    return FontView()
}
