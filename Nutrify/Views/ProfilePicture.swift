//
//  ProfilePicture.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/28/24.
//

import SwiftUI

struct ProfilePicture: View {
    var profilePictureUrl: String? = nil
    
    var body: some View {
        AsyncImage(url: URL(string: profilePictureUrl ?? "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZG3qkyaZZsnYyKv3-iTLyK_WT6QFmBQz3IQ&s")) {
            result in result.image?
                .resizable()
        }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
}

#Preview {
    ProfilePicture()
}
