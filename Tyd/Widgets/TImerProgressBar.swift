//
//  TImerProgressBar.swift
//  Tyd
//
//  Created by Ricky Kresslein on 6/28/23.
//

import SwiftUI

struct ProgressBar: View {
    @Binding var progress: Float

    var body: some View {
        ZStack {
            Ellipse()
                .trim(from: 0.5, to: 1.0)
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .opacity(0.3)
                .foregroundColor(.accentColor)
                .frame(width: 250.0, height: 300.0)
                .padding(.horizontal)

            Ellipse()
                .trim(from: 0.5, to: CGFloat(min((progress / 2) + 0.5, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.accentColor)
                .animation(.linear, value: min((progress / 2) + 0.5, 1.0))
                .frame(width: 250.0, height: 300.0)
                .padding(.horizontal)
        }
    }
}
