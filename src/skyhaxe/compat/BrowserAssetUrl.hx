package skyhaxe.compat;

import openfl.net.URLRequest;

/** Browser-only URL boundary for assets that Flash could load outside browser CORS. */
class BrowserAssetUrl {
    public static function normalizeRequest(request:URLRequest):URLRequest {
        #if html5
        if (request == null || request.url == null || request.url.length == 0) return request;

        try {
            var parsed = new js.html.URL(request.url, js.Browser.window.location.href);
            if (parsed.origin == js.Browser.window.location.origin) return request;
            var parameters = com.sulake.habbo.utils.HabboWebTools.getParameterMap(null);
            var sourceValue:Dynamic = ASCompat.getDynamicProperty(parameters,
                "image.proxy.source.url");
            var proxyValue:Dynamic = ASCompat.getDynamicProperty(parameters, "image.proxy.url");
            var source = sourceValue == null ? null : Std.string(sourceValue);
            var proxy = proxyValue == null ? null : Std.string(proxyValue);
            if (source == null || proxy == null || source == "" || proxy == "") return request;
            var sourceUrl = new js.html.URL(source);
            if (parsed.origin != sourceUrl.origin
                    || !StringTools.startsWith(parsed.pathname, sourceUrl.pathname)) return request;

            // Only the configured source prefix can cross this boundary. The proxy receives a
            // relative path, not an arbitrary URL, so it cannot become an open proxy.
            var relative = parsed.pathname.substr(sourceUrl.pathname.length);
            var proxyBase = StringTools.endsWith(proxy, "/") ? proxy : proxy + "/";
            var normalized = new URLRequest(proxyBase + relative + parsed.search + parsed.hash);
            normalized.method = request.method;
            normalized.data = request.data;
            normalized.contentType = request.contentType;
            normalized.requestHeaders = request.requestHeaders;
            return normalized;
        } catch (_:Dynamic) {
            return request;
        }
        #else
        return request;
        #end
    }
}
