package skyhaxe.compat;

import openfl.net.URLRequest;

/** Browser-only URL boundary for assets that Flash could load outside browser CORS. */
class BrowserAssetUrl {
    public static function normalizeRequest(request:URLRequest):URLRequest {
        #if html5
        if (request == null || request.url == null || request.url.length == 0) return request;

        try {
            var parsed = new js.html.URL(request.url, js.Browser.window.location.href);
            var localCorpus = (parsed.hostname == "localhost" || parsed.hostname == "127.0.0.1")
                && StringTools.startsWith(parsed.pathname, "/ngh/");
            var remoteImageCorpus = parsed.hostname == "swf.nextgenhabbo.com"
                && StringTools.startsWith(parsed.pathname, "/c_images/");
            if ((!localCorpus || parsed.origin == js.Browser.window.location.origin)
                    && !remoteImageCorpus) return request;

            // Flash can read these directly. HTML5 uses same-origin mounts: local NGH files are
            // mounted as-is, while the single approved remote image host has a bounded bridge.
            var path = remoteImageCorpus
                ? "/__skyhaxe_remote__" + parsed.pathname
                : parsed.pathname;
            var normalized = new URLRequest(js.Browser.window.location.origin
                + path + parsed.search + parsed.hash);
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
