"""Apply the HTML5 local-corpus URL boundary to the generated bitmap loader.

The converted loader remains the implementation. This creates an isolated v32 overlay and adds
one browser-host call before loading, leaving the AS3 source and Flash configuration unchanged.
"""
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
RELATIVE = Path("com/sulake/core/assets/loaders/BitmapFileLoader.hx")
SOURCE = ROOT / ".toolchain/v32/generated" / RELATIVE
TARGET = ROOT / ".toolchain/v32/platform" / RELATIVE


def main() -> None:
    text = SOURCE.read_text(encoding="utf-8")
    import_anchor = "    import flash.display.Loader;"
    if text.count(import_anchor) != 1:
        raise RuntimeError("Generated BitmapFileLoader imports changed; review the browser boundary")
    text = text.replace(import_anchor, "    import ASCompat.checkNullIteratee;\n" + import_anchor)
    old = """        function loadPreparedRequest(urlRequest:URLRequest, label:String)
        {
            var preparedRequest= this.prepareAirBitmapRequest(urlRequest);"""
    new = """        function loadPreparedRequest(urlRequest:URLRequest, label:String)
        {
            var preparedRequest= this.prepareAirBitmapRequest(urlRequest);
            preparedRequest = skyhaxe.compat.BrowserAssetUrl.normalizeRequest(preparedRequest);"""
    if text.count(old) != 1:
        raise RuntimeError("Generated BitmapFileLoader contract changed; review the browser boundary")
    text = text.replace(old, new)

    complete_old = """        function completeEventHandler(event:Event)
        {
            if (HabboWebTools.isAirApplication)"""
    complete_new = """        function completeEventHandler(event:Event)
        {
            #if html5
            // The browser has already enforced origin access before COMPLETE. The transport URL
            // may differ from Flash's configured asset identity, which must remain unchanged.
            loadEventHandler(event);
            return;
            #end
            if (HabboWebTools.isAirApplication)"""
    if text.count(complete_old) != 1:
        raise RuntimeError("Generated BitmapFileLoader completion contract changed; review the browser boundary")
    text = text.replace(complete_old, complete_new)

    remember_old = """        function rememberRequestUrl(primary:URLRequest, fallback:URLRequest)
        {
            if (((primary != null)"""
    remember_new = """        function rememberRequestUrl(primary:URLRequest, fallback:URLRequest)
        {
            #if html5
            // AssetLibrary keys the pending request by the configured URL and later looks it up
            // through loader.url. Keep that identity stable while remembering the real transport.
            if (primary != null && primary.url != null && primary.url.length > 0)
            {
                this._lastRequestedUrl = primary.url;
            }
            else if (fallback != null && fallback.url != null && fallback.url.length > 0)
            {
                this._lastRequestedUrl = fallback.url;
            }
            return;
            #end
            if (((primary != null)"""
    if text.count(remember_old) != 1:
        raise RuntimeError("Generated BitmapFileLoader request identity changed; review the browser boundary")
    text = text.replace(remember_old, remember_new)

    TARGET.parent.mkdir(parents=True, exist_ok=True)
    TARGET.write_text(text, encoding="utf-8", newline="\n")
    print(f"Prepared browser bitmap-loader overlay: {TARGET.relative_to(ROOT)}")


if __name__ == "__main__":
    main()
