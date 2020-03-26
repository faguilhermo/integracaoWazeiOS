//
//  Localization.swift
//  integracaoWazeiOS
//
//  Created by Fabrício Guilhermo on 26/03/20.
//  Copyright © 2020 Fabrício Guilhermo. All rights reserved.
//

import CoreLocation

final class Localization: NSObject {
    public func convertAddressToCoordinates(address: String, local: @escaping(_ local: CLPlacemark) -> Void) {
        let converter = CLGeocoder()
        converter.geocodeAddressString(address) { (localizationList, error) in
            guard let localization = localizationList?.first else { return }
            local(localization)
        }
    }
}
