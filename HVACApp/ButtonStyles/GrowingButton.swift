//
//  GrowingButton.swift
//  HVACApp
//
//  Created by Yury Kudreika on 11.04.25.
//  Copyright © 2025 Yury Kudreika. All rights reserved.
//

import SwiftUI

struct GrowingButton: ButtonStyle {
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .frame(minWidth: 0, maxWidth: .infinity)
            .background(.blue)
            .foregroundStyle(.white)
            .clipShape(Capsule())
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
    
}
