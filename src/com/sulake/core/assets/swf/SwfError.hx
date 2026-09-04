package com.sulake.core.assets.swf;

/**
 * A SWF the reader cannot serve.
 *
 * Distinct from a generic exception on purpose: G0 established that every reachable symbol in the
 * corpus is readable, so one of these means either a corpus regression or a reader gap -- both
 * worth failing loudly rather than degrading to a blank asset.
 */
class SwfError {
	public var message(default, null):String;

	public function new(message:String) {
		this.message = message;
	}

	public function toString():String {
		return "SwfError: " + message;
	}
}
