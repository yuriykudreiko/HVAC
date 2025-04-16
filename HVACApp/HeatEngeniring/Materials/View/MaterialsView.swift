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
    
    @FocusState var isFocused: Bool
    
    var body: some View {
        NavigationView {
            ScrollViewReader { proxy in
                makeList()
                    .searchable(text: $viewModel.searchText, prompt: "Введите название материала")
                    .autocorrectionDisabled(true)
                    .navigationTitle("Материалы")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button {
                                viewModel.close()
                            } label: {
                                Image(systemName: "xmark")
                            }
                        }
                    }
                    .safeAreaInset(edge: .bottom) {
                        makeMaterialWidthView()
                    }
                    .animation(.default, value: viewModel.selectedMaterial)
                    .onChange(of: isFocused) {
                        Task {
                            try? await Task.sleep(nanoseconds: 300_000_000)
                            
                            await MainActor.run {
                                if isFocused, let selectedMaterialId = viewModel.selectedMaterial?.id {
                                    withAnimation {
                                        proxy.scrollTo(selectedMaterialId)
                                    }
                                }
                            }
                        }
                    }
            }
        }
        .onReceive(viewModel.$isScreenShown) { isScreenShown in
            if !isScreenShown {
                dismiss()
            }
        }
        .alert("Выберите наименование материала из списка", isPresented: $viewModel.shouldShowNoMaterialError) {
            Button("OK", role: .cancel) { }
        }
    }
    
    // MARK: - Views
    
    func makeList() -> some View {
        List {
            ForEach(viewModel.sections) { sectionModel in
                Section {
                    ForEach(sectionModel.materials) { material in
                        makeMaterialRow(material: material)
                            .id(material.id)
                    }
                } header: {
                    Text(sectionModel.name)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .onTapGesture {
                            isFocused = false
                        }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.sidebar)
    }
    
    func makeMaterialRow(material: MaterialModel) -> some View {
        HStack(alignment: .top) {
            Text("\(material.id)")
                .font(.system(size: 16))
                .multilineTextAlignment(.leading)
                .frame(width: 27, alignment: .leading)
                .foregroundStyle(.primary)
            
            Text("\(material.name)")
                .lineLimit(nil)
                .font(.system(size: 16))
                .foregroundStyle(.primary)
            
            Spacer()
            
            Text("\(material.density)")
                .font(.system(size: 14))
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(viewModel.selectedMaterial?.id == material.id ? Color.blue : Color.black)
        .contentShape(Rectangle())
        .onTapGesture {
            viewModel.select(material: material)
        }
    }
    
    func makeMaterialWidthView() -> some View {
        VStack(alignment: .leading, spacing: 4) {
            VStack(alignment: .leading, spacing: 4) {
                TextField("Введите толщину материала, δ мм", text: $viewModel.materialWidth)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .overlay(
                        RoundedRectangle(cornerRadius: 1)
                            .stroke(viewModel.shouldShowNoWidthError ? Color.red : Color.blue, lineWidth: 2)
                    )
                
                Text("Введите толщину материала")
                    .font(.system(size: 10))
                    .foregroundStyle(Color.red)
                    .opacity(viewModel.shouldShowNoWidthError ? 1 : 0)
            }
            
            Button {
                viewModel.addButtonWasTapped()
            } label: {
                Text("Добавить выбранный материал")
            }
            .buttonStyle(GrowingButton())
        }
        .padding(16)
        .background {
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 16,
                style: .circular
            )
            .fill(Color.white)
            .edgesIgnoringSafeArea(.bottom)
            .shadow(
                color: Color.black.opacity(0.1),
                radius: 12,
                x: 0,
                y: 4
            )
        }
    }
    
}
