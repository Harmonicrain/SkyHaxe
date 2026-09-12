package com.sulake.habbo.roomevents.wired_trading.chests.subcontrollers.views
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.window.widgets.IProductDisplayInfo;

     class ChestItemTypeRenderableWrapper implements IProductDisplayInfo
    {
        var _type:ChestItemType;
        public function new(type:ChestItemType) { this._type = type; }
        public var productTypeId(get,never):Int;
public function  get_productTypeId():Int
        {
            // July's chest protocol uses 0/1 for wall/floor, while this
            // client's product widgets use the legacy 1/2 identifiers.
            return this._type.isWallItem ? 1 : 2;
        }
        public var itemTypeId(get,never):String;
public function  get_itemTypeId():String { return Std.string(this._type.typeId); }
        public var extraData(get,never):String;
public function  get_extraData():String { return this._type.legacyPosterId; }
        public var petFigureString(get,never):String;
public function  get_petFigureString():String { return ""; }
        public var botFigureString(get,never):String;
public function  get_botFigureString():String { return ""; }
        public var figureSetIds(get,never):Vector<Int>;
public function  get_figureSetIds():Vector<Int> { return null; }
    }

