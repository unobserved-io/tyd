//
//  AboutView.swift
//  Tyd
//
//  Created by Ricky Kresslein on 1/1/24.
//

import SwiftUI

struct AboutView: View {
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        ScrollView {
            VStack(spacing: 40.0) {
                VStack {
                    Image("TydLogo")
                        .foregroundStyle(.accent)
                        .padding(.bottom, 10.0)
                    HStack(alignment: .lastTextBaseline) {
                        Text("by")
                            .padding(.trailing, 8.0)
                            .opacity(0.4)

                        Image(
                            uiImage: colorScheme == .light
                                ? .unobservedText.resize(targetSize: CGSize(width: 220, height: 17.0))
                                : .unobservedTextWhite.withRenderingMode(.alwaysOriginal).resize(targetSize: CGSize(width: 220, height: 17.0))
                        )
                    }
                }

                Text("""
                Thank you for using Tyd. We understand the trust it takes to put your personal information into an app, which is why we make privacy a promise.

                Tyd is created by Unobserved. As the name suggests, Unobserved creates privacy-first software for people who don't believe their data should be spread across the internet, often under the control of people and companies who use it for sketchy purposes.

                No accounts are required for any Unobserved apps, no data is collected, even for analytics, and we never show ads to monetize our apps. This is app design as it should be.
                """)

                Text("Questions, suggestions, or concerns? Email [support@unobserved.io](mailto:support@unobserved.io)")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)

                Text("Version \(appVersion ?? "unknown")")
            }
            .padding()
        }
    }
}

#Preview {
    AboutView()
}

extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
}
