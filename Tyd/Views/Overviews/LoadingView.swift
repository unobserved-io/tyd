//
//  LoadingView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 11/3/23.
//

import SwiftUI

struct LoadingView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        TabsView()
    }
}

#Preview {
    LoadingView()
}
