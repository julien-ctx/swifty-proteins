//
//  SplashView.swift
//  SwiftyProteins
//
//  Created by Minguk on 03/06/2024.
//

import Foundation
import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("launchimage")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .cornerRadius(20)
            Text("S W I F T Y - P R O T E I N S")
                .font(.headline)
                .fontWeight(.bold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}
