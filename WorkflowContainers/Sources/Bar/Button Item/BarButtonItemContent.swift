// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit)

import UIKit

public extension Bar.ButtonItem {
	enum Content: Equatable {
		case text(String)
		case icon(UIImage)
		case spinner
		case back(title: String?)
	}
}

#endif
