//
//  InputField.swift
//  Nutrify
//
//  Created by Jackie Lin on 11/27/24.
//

import SwiftUI

struct InputField: View {
    let label: String
    var axis: Axis = .horizontal
    @Binding var value: String

    var body: some View {
        TextField(label, text: $value, axis: axis)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .textInputAutocapitalization(.never)
    }
}

#Preview {
    @State var a = "2"
    return InputField(label: "hello", value: $a)
}
