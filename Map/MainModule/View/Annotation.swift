//
//  Annotation.swift
//  Map
//
//  Created by Dina Yestemir on 24.03.2021.
//

import Foundation
import MapKit
import UIKit

class CustomAnnotationView: MKPinAnnotationView { 
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        canShowCallout = true
        rightCalloutAccessoryView = UIButton(type: .infoLight)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
