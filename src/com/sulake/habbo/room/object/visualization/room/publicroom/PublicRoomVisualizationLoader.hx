package com.sulake.habbo.room.object.visualization.room.publicroom;

#if html5
import js.Browser;

/**
 * Asset-URL rewriting for the Gordon content the room engine fetches.
 *
 * The generated `RoomEngine` owns loading, projection and drawing. This adapter contains only
 * the browser-specific URL rewriting that Flash never needed.
 *
 * external_vars states absolute URLs for the live hotel (`http://localhost/ngh/...`, no port),
 * which do not resolve against the dev server. Every asset path is rewritten onto this page's
 * origin before it is fetched; a path that skips this fails with a bare "Failed to fetch".
 */
class PublicRoomVisualizationLoader {
	/** Resolve a Gordon library beside the active room SWF on this page's origin. */
	public static function contentAssetUrl(contentBase:String, fileName:String):String {
		if (!~/^[A-Za-z0-9_.-]+$/.match(fileName))
			throw 'Unsafe Gordon asset name "$fileName"';
		return sameOriginPath(contentBase) + fileName;
	}

	/** Rewrite an absolute asset base onto this origin, as the Gordon loaders do. */
	public static function assetBase(value:String):String return sameOriginPath(value);

	/** The same rewrite for a single file rather than a directory. */
	public static function assetUrl(value:String):String {
		return new js.html.URL(value, Browser.window.location.href).pathname;
	}

	static function sameOriginPath(value:String):String {
		var path = new js.html.URL(value, Browser.window.location.href).pathname;
		return StringTools.endsWith(path, "/") ? path : path + "/";
	}
}
#end
