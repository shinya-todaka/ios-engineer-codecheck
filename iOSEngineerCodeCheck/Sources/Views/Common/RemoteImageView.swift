//
//  RemoteImageView.swift
//  iOSEngineerCodeCheck
//
//  Created by 戸高新也 on 2021/02/07.
//  Copyright © 2021 YUMEMI Inc. All rights reserved.
//

import SwiftUI
import Nuke

class RemoteImage: ObservableObject {
    @Published var image: UIImage

    init(urlString: String, placeholder: UIImage) {
        self.image = placeholder
        guard let url = URL(string: urlString) else { return }
        
        loadImage(url: url)
    }

    private func loadImage(url: URL) {
        ImagePipeline.shared.loadImage(with: url) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.image = response.image
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

struct RemoteImageView: View {
    @ObservedObject var remoteImage: RemoteImage
    var body: some View {
        Image(uiImage: remoteImage.image)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

struct RemoteImageView_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImageView(remoteImage: RemoteImage(urlString: "https://avatars.githubusercontent.com/u/10639145?s=200&v=4", placeholder: UIImage(systemName: "applelogo")!))
    }
}
