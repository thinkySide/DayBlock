//
//  ContentView.swift
//  ListKavsoft
//
//  Created by 김민준 on 1/29/26.
//

import SwiftUI
import CoreData

struct ContentView: View {

    @StateObject private var dragProperties: DragProperties = .init()

    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Flash Cards")
                .navigationBarTitleDisplayMode(.inline)
        }
        .preferredColorScheme(.dark)
        .overlay(alignment: .topLeading) {
            if let previewImage = dragProperties.previewImage {
                Image(uiImage: previewImage)
                    .opacity(0.8)
                    .offset(
                        x: dragProperties.initialViewLocation.x,
                        y: dragProperties.initialViewLocation.y
                    )
                    .offset(dragProperties.offset)
                    .ignoresSafeArea()
            }
        }
        .environmentObject(dragProperties)
    }
}
