//
//  AppIconPickerView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 1/5/24.
//

import SwiftUI

struct AppIconPickerView: View {
    @AppStorage("chosenIcon") var chosenIcon: String = AppIcons.primary.rawValue
    
    var body: some View {
        ScrollView {
            VStack(spacing: 11) {
                ForEach(AppIcons.allCases) { appIcon in
                    HStack(spacing: 16) {
                        Image(uiImage: appIcon.preview)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 60, height: 60)
                            .cornerRadius(12)
                        Text(appIcon.description)
                            .bold()
                        Spacer()
                        Image(systemName: chosenIcon == appIcon.rawValue ? "checkmark.circle.fill" : "circle")
                    }
                    .padding(EdgeInsets(top: 14, leading: 16, bottom: 14, trailing: 16))
                    .background(Color.gray.opacity(0.3))
                    .cornerRadius(20)
                    .onTapGesture {
                        withAnimation {
                            chosenIcon = appIcon.rawValue
                            UIApplication.shared.setAlternateIconName(appIcon.iconName)
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    AppIconPickerView()
}
