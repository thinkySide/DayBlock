//
//  CalendarView.swift
//  Calendar
//
//  Created by 김민준 on 2/4/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import HorizonCalendar

public struct CalendarView: View {
    
    private var store: StoreOf<CalendarFeature>

    public init(store: StoreOf<CalendarFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar()
            
            Header()
                .padding(.horizontal, 20)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func Header() -> some View {
        HStack {
             Text("2023.08")
                .brandFont(.poppins(.bold), 22)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
            
            Button {
                
            } label: {
                Text("today")
                    .brandFont(.poppins(.bold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .frame(height: 26)
                    .padding(.horizontal, 10)
                    .background(DesignSystem.Colors.gray100.swiftUIColor)
                    .clipShape(Capsule())
            }
            .padding(.leading, 8)
            .scaleButton()
            
            Spacer()
            
            CalendarMonthIndicator()
        }
    }
    
    @ViewBuilder
    private func CalendarMonthIndicator() -> some View {
        HStack(spacing: 16) {
            Button {
                
            } label: {
                DesignSystem.Icons.arrowLeft.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .scaleButton()
            
            Button {
                
            } label: {
                DesignSystem.Icons.arrowRight.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .scaleButton()
        }
    }
}
