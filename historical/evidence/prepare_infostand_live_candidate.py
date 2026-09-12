"""Explicit missing-service guards for the V24 widget profile, not replacement services."""
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
SOURCE = REPO / ".toolchain/v24/generated/com/sulake/habbo/ui"
TARGET = REPO / ".toolchain/v21/openfl/com/sulake/habbo/ui"
EDITS = {
    "widget/infostand/InfoStandWidget.hx": [
        ("this.mainContainer.height = _local_2.height;",
         """this.mainContainer.height = _local_2.height;
            var ancestors = [];
            var node:com.sulake.core.window.IWindow = _local_2;
            while (node != null) {
                ancestors.push({name:node.name, x:node.x, y:node.y, width:node.width, height:node.height,
                    visible:node.visible, alpha:(untyped node.alpha), scaleX:(untyped node.scaleX),
                    scaleY:(untyped node.scaleY), childCount:(untyped node.numChildren)});
                node = node.parent;
            }
            js.Browser.document.documentElement.setAttribute("data-skyhaxe-infostand-view", haxe.Json.stringify(ancestors));"""),
        ("this.mainContainer.visible = true;",
         """this.mainContainer.visible = true;
            js.Browser.document.documentElement.setAttribute("data-skyhaxe-infostand-state", "shown:" + view);"""),
        ("public function close()\n        {",
         """public function close()
        {
            js.Browser.document.documentElement.setAttribute("data-skyhaxe-infostand-state", "closed");"""),
        ("function objectDeselectedHandler(k:RoomWidgetRoomObjectUpdateEvent)\n        {",
         """function objectDeselectedHandler(k:RoomWidgetRoomObjectUpdateEvent)
        {
            js.Browser.document.documentElement.setAttribute("data-skyhaxe-infostand-deselected",
                Std.string(k.id) + ":" + Std.string(k.category));"""),
    ],
    "widget/infostand/InfoStandFurniView.hx": [
        ("var showWiredInspect= !playTestMode",
         "var showWiredInspect= !playTestMode && this._widget.handler.container.userDefinedRoomEvents != null"),
    ],
    "RoomDesktop.hx": [
        ("if (this._roomWidgetFactory == null)",
         """if (k == RoomWidgetEnum.AVATAR_INFO && (this._inventory == null || this._friendList == null)) {
                js.Browser.document.documentElement.setAttribute("data-skyhaxe-avatar-info", "waiting-for-inventory-and-friends");
                return;
            }
            if (this._roomWidgetFactory == null)"""),
        ("new InfoStandWidgetHandler(this._soundManager.musicController)",
         "new InfoStandWidgetHandler(this._soundManager == null ? null : this._soundManager.musicController)"),
        ("this._toolbar.events.addEventListener(HabboToolbarEvent.HTIE_ICON_ZOOM, this.onToolbarEvent);",
         "if (this._toolbar != null) this._toolbar.events.addEventListener(HabboToolbarEvent.HTIE_ICON_ZOOM, this.onToolbarEvent);"),
    ],
    "RoomUI.hx": [
        ("function defineToolbarState(k:IRoomSession)\n        {",
         "function defineToolbarState(k:IRoomSession)\n        {\n            if (this._toolbar == null) return;"),
    ],
}


def main():
    for relative, edits in EDITS.items():
        source = SOURCE / relative
        if not source.is_file():
            source = REPO / "generated/com/sulake/habbo/ui" / relative
        text = source.read_text(encoding="utf-8")
        # The original candidate's import.hx supplies this outside the OpenFL overlay path.
        text = text.replace(";", ";\n    import flash.Vector;", 1)
        for old, new in edits:
            if text.count(old) != 1:
                raise RuntimeError(f"Review changed Infostand profile source: {relative}: {old}")
            text = text.replace(old, new)
        target = TARGET / relative
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(text, encoding="utf-8", newline="\n")
    print("Prepared original Infostand runtime with explicit absent toolbar/audio guards")


if __name__ == "__main__":
    main()
