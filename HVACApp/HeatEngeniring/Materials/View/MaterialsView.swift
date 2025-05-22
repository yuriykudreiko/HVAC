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
                    .searchable(
                        text: $viewModel.searchText,
                        isPresented: $viewModel.isSearchStarted,
                        prompt: "Введите название материала"
                    )
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
                    .animation(.default, value: viewModel.isSearchStarted)
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
                            .listRowInsets(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                            .listRowBackground(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(viewModel.selectedMaterial?.id == material.id ? 
                                          Color.blue.opacity(0.1) : Color.clear)
                                    .padding(.vertical, 4)
                            )
                    }
                } header: {
                    Text(sectionModel.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                        .onTapGesture {
                            isFocused = false
                        }
                }
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .listStyle(.plain)
        .background(Color(.systemGroupedBackground))
    }
    
    func makeMaterialRow(material: MaterialModel) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Text("\(material.id)")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.secondary)
                .frame(width: 30, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("\(material.name)")
                    .lineLimit(2)
                    .font(.system(size: 16))
                    .foregroundStyle(.primary)
                
                Text("Плотность: \(material.density) кг/м³")
                    .font(.system(size: 13))
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            if viewModel.selectedMaterial?.id == material.id {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.system(size: 20))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                viewModel.select(material: material)
            }
        }
    }
    
    func makeMaterialWidthView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Толщина материала")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)
                
                TextField("Введите толщину материала, δ мм", text: $viewModel.materialWidth)
                    .keyboardType(.numberPad)
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(viewModel.shouldShowNoWidthError ? Color.red : Color.blue.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 4)
                
                if viewModel.shouldShowNoWidthError {
                    Text("Введите толщину материала")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.red)
                        .transition(.opacity)
                }
            }
            
            Button {
                viewModel.addButtonWasTapped()
            } label: {
                HStack {
                    Text("Добавить материал")
                    Image(systemName: "plus.circle.fill")
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(GrowingButton())
        }
        .padding(20)
        .background {
            UnevenRoundedRectangle(
                topLeadingRadius: 20,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 20,
                style: .circular
            )
            .fill(Color.white)
            .edgesIgnoringSafeArea(.bottom)
            .shadow(
                color: Color.black.opacity(0.08),
                radius: 16,
                x: 0,
                y: -4
            )
        }
    }
    
}
