//
//  InputField.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/27/24.
//

import SwiftUI

struct InputField: View {
    let label: String
    @Binding var value: String

    var body: some View {
        TextField(label, text: $value)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textInputAutocapitalization(.never)
    }
}

#Preview {
    @State var a = "2"
    return InputField(label: "hello", value: $a)
}
