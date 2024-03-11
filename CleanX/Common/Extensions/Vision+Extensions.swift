//
//  Vision+Extensions.swift
//  CleanX
//
//  Created by Nikita Arshinov on 11.03.24.
//

import Vision
import CoreImage

extension CIImage {
    // Сreating a print to compare photos
    var featurePrintObservation: VNFeaturePrintObservation? {
        do {
            let request = VNGenerateImageFeaturePrintRequest()
            if #available(iOS 17.0, *) {
                request.revision = VNGenerateImageFeaturePrintRequestRevision2
            } else {
                request.revision = VNGenerateImageFeaturePrintRequestRevision1
            }
            let requestHandler = VNImageRequestHandler(ciImage: self, options: [:])
            try requestHandler.perform([request])
            guard let featurePrint = request.results?.first as? VNFeaturePrintObservation else { return nil }
            return featurePrint
        } catch {
            return nil
        }
    }
}

extension VNFeaturePrintObservation {
    // Сomparison of prints to find similar photos
    func isSimilar(to print: VNFeaturePrintObservation) -> Bool {
        var distance: Float = .zero
        try? self.computeDistance(&distance, to: print)
        return distance < 0.5
    }
}


