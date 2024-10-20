// Copyright © Fleuronic LLC. All rights reserved.

#if canImport(UIKit) && !os(watchOS)

public extension Bar {
	enum Visibility {
		case hidden
		case visible(Content)
	}
}

#endif
