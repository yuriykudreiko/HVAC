//
//  MaterialsView.swift
//  HVACApp
//
//  Created by Yury Kudreika on 29.03.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import SwiftUI

struct MaterialsView: View {
    
    @ScaledMetric(relativeTo: .body) var scaledPadding: CGFloat = 10

    @ObservedObject var viewModel: MaterialsViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sections) { sectionModel in
                    Section(isExpanded: viewModel.bindExpandedSections(sectionModel: sectionModel)) {
                        ForEach(sectionModel.materials) { material in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("\(material.name)")
                                        .lineLimit(nil)
                                        .font(.system(size: 16))
                                    
                                    Text("\(material.density)")
                                        .font(.system(size: 14))
                                }
                                
                                Spacer()
                            }
                        }
                    } header: {
                        Text(sectionModel.name)
                            .multilineTextAlignment(.leading)
                            .lineLimit(nil)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .listStyle(.sidebar)
            .searchable(text: $viewModel.searchText, prompt: "Введите текст")
            .navigationTitle("Материалы")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
            }
        }
    }
    
}



struct ContentView1: View {
    
    @State private var showModal = false
    
    // If you are getting the "can only present once" issue, add this here.
    // Fixes the problem, but not sure why; feel free to edit/explain below.
    @SwiftUI.Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>
    
    
    var body: some View {
        Button(action: {
            self.showModal = true
        }) {
            Text("Show modal")
        }.sheet(isPresented: self.$showModal) {
            ModalView()
        }
    }
}


struct ModalView: View {
    
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        Group {
            Text("Modal view")
            Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Dismiss")
            }
        }
    }
}
