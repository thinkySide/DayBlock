//
//  Home.swift
//  ListKavsoft
//
//  Created by 김민준 on 1/29/26.
//

import SwiftUI
import CoreData

struct Home: View {

    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [.init(keyPath: \Category.dateCreated, ascending: true)]
    ) private var categories: FetchedResults<Category>

    @Environment(\.managedObjectContext) private var context
    @EnvironmentObject private var properties: DragProperties

    /// Scroll Properties
    @State private var scrollPosition: ScrollPosition = .init()
    @State private var currentScrollOffset: CGFloat = .zero
    @State private var dragScrollOffset: CGFloat = .zero
    @GestureState private var isActive: Bool = false

    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                ForEach(categories) { category in
                    CustomDisclosureGroup(category: category)
                }
            }
            .padding(15)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("", systemImage: "plus.circle.fill") {
                    for index in 1...5 {
                        let category = Category(context: context)
                        category.dateCreated = .init()

                        let card = FlashCard(context: context)
                        card.title = "Card \(index)"
                        card.category = category

                        try? context.save()
                    }
                }
            }
        }
        .scrollPosition($scrollPosition)
        .onScrollGeometryChange(for: CGFloat.self, of: {
            $0.contentOffset.y + $0.contentInsets.top
        }, action: { oldValue, newValue in
            currentScrollOffset = newValue
        })
        .allowsTightening(!properties.show)
        .contentShape(.rect)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .global)
                .updating($isActive, body: { _, out, _ in
                    out = true
                })
                .onChanged { value in
                    if dragScrollOffset == 0 {
                        dragScrollOffset = currentScrollOffset
                    }

                    scrollPosition.scrollTo(y: dragScrollOffset + (-value.translation.height))
                },
            /// Drag 프리뷰 시에만 활성화
            isEnabled: properties.show
        )
        .onChange(of: isActive) { oldValue, newValue in
            /// 제스처 종료 시 데이터 리셋
            if !newValue {
                dragScrollOffset = 0
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
}
