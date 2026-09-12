package skyhaxe;

#if js
import js.Browser;

/**
 * Runtime configuration for the browser host, in the shape NGHWin already uses.
 *
 * The AIR host (`HabboAir.as`) reads a `config.ini` next to the executable, treats `base.url` and
 * `gordon.path` as shorthand, derives every gamedata URL from them, and hands the result to
 * `HabboWebTools.airParameters`. The browser host is the same role -- the closure's seam note for
 * `Habbo.as` is "HTML supplies parameters" -- so it reads the same file in the same order rather
 * than carrying its own hardcoded URLs.
 *
 * Precedence matches NGHWin: derived defaults lose to anything the file states explicitly. That
 * matters beyond tidiness, because the client's own configuration treats a host parameter as
 * read-only (`HabboConfigurationManager.setProperty` records the key and refuses later writes),
 * so a value set here survives the `external.variables.txt` download that would otherwise replace
 * it. That is what lets the config point `external.texts.txt` at the origin serving the client:
 * the shipped variables file names an absolute URL on another port, and the browser blocks the
 * cross-origin read, which leaves localization waiting forever and the configuration manager
 * locked behind it.
 */
class BrowserConfig {
    /** Keys consumed to build the others rather than passed through to the client. */
    static inline final BASE_URL_KEY = "base.url";
    static inline final GORDON_PATH_KEY = "gordon.path";

    final values = new Map<String, String>();

    function new() {}

    /**
     * Fetch and parse the config, then fill in everything it did not state.
     *
     * A missing file is not an error: the derived defaults alone are a working same-origin setup,
     * which keeps a plain checkout runnable without one.
     */
    public static function load(url:String, onReady:BrowserConfig->Void):Void {
        var config = new BrowserConfig();
        function finish(text:Null<String>):Void {
            if (text != null) config.parse(text);
            config.applyDefaults();
            onReady(config);
        }
        Browser.window.fetch(url).then(function(response) {
            if (!response.ok) return cast Promise_resolveNull();
            return response.text();
        }).then(function(text:Null<String>) {
            finish(text);
            return null;
        }).catchError(function(_) finish(null));
    }

    static function Promise_resolveNull():js.lib.Promise<Null<String>> {
        return js.lib.Promise.resolve(null);
    }

    /** `key=value` lines, `#` or `;` comments, surrounding whitespace ignored -- the AIR format. */
    function parse(text:String):Void {
        for (rawLine in ~/\r\n|\r|\n/g.split(text)) {
            var line = StringTools.trim(rawLine);
            if (line == "" || line.charAt(0) == "#" || line.charAt(0) == ";") continue;
            var eq = line.indexOf("=");
            if (eq <= 0) continue;
            var key = StringTools.trim(line.substring(0, eq));
            var value = StringTools.trim(line.substring(eq + 1));
            if (key != "") values.set(key, value);
        }
    }

    /** Only fills a gap, so an explicit line in the file always wins. */
    function setDefault(key:String, value:String):Void {
        if (!values.exists(key)) values.set(key, value);
    }

    function get_baseUrl():String {
        var base = values.get(BASE_URL_KEY);
        if (base == null || base == "") base = Browser.location.origin + "/ngh";
        // A trailing slash would double up against every path appended below.
        while (StringTools.endsWith(base, "/")) base = base.substring(0, base.length - 1);
        return base;
    }

    /**
     * The same derived set `HabboAir.applyDefaultParameters` writes.
     *
     * The two connection defaults differ from AIR's on purpose: a browser cannot open a raw
     * socket, so the client talks to the WebSocket gateway on the host serving the page.
     */
    function applyDefaults():Void {
        var base = get_baseUrl();
        var gordon = values.get(GORDON_PATH_KEY);
        if (gordon == null || gordon == "") gordon = "/gordon/PRODUCTION-201611291003-338511768/";

        setDefault("connection.info.host", Browser.location.hostname);
        setDefault("connection.info.port", "2096");

        setDefault("client.allow.cross.domain", "1");
        setDefault("client.notify.cross.domain", "0");
        setDefault("site.url", base);
        setDefault("url.prefix", base);
        setDefault("client.reload.url", base + "/index.php");
        setDefault("client.fatal.error.url", base + "/index.php");
        setDefault("client.connection.failed.url", base + "/index.php");
        // HabboAir supplies this host parameter before HabboLoadingScreen exists. It is not a
        // localization entry in external_dev_texts.txt; without the AIR/browser-host default the
        // converted web loader correctly displays the literal fallback key `client.starting`.
        setDefault("client.starting", "Scratching ear's ear");
        setDefault("external.variables.txt", base + "/gamedata/external_dev_vars.txt");
        setDefault("external.texts.txt", base + "/gamedata/external_dev_texts.txt");
        setDefault("external.override.variables.txt",
            base + "/gamedata/override/external_override_variables.txt");
        setDefault("external.override.texts.txt",
            base + "/gamedata/override/external_flash_override_texts.txt");
        setDefault("external.figurepartlist.txt", base + "/gamedata/figuredata.xml");
        setDefault("flash.dynamic.avatar.download.configuration", base + "/gamedata/figuremap.xml");
        setDefault("productdata.load.url", base + "/gamedata/productdata.txt");
        setDefault("furnidata.load.url", base + "/furnidata.xml");
        // These are all absolute in the shipped variables file, pointing at the host that
        // serves the SWFs rather than the one serving the page, so the browser blocks every
        // one of them. Same-origin defaults keep the images and icons readable.
        setDefault("habbicons.asset.root", base + "/habbicons");
        var images = base + "/c_images/";
        setDefault("image.library.url", images);
        setDefault("image.library.url.server", images);
        setDefault("image.library.url.stickers", images);
        setDefault("image.library.badgepart.url", images + "Badgeparts/");
        setDefault("image.library.catalogue.url", images + "catalogue/");
        setDefault("image.library.playlist.url", images + "playlist/");
        setDefault("badge.image.path", images + "album1584");
        setDefault("flash.client.url", base + gordon);
        setDefault("has.identity", "1");
        setDefault("account_id", "1");
        setDefault("unique_habbo_id", "1");
        setDefault("processlog.enabled", "0");
        setDefault("flash.client.origin", "popup");

        values.remove(BASE_URL_KEY);
        values.remove(GORDON_PATH_KEY);
    }

    public function get(key:String):Null<String> {
        return values.get(key);
    }

    public function set(key:String, value:String):Void {
        values.set(key, value);
    }

    public function keys():Iterator<String> {
        return values.keys();
    }
}
#end
