package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.contracts.itemtable
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.wiredtrading.ChestItemType;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

     class ItemTypeTableObject implements ITableObject
    {
        var _chestItemType:ChestItemType;
        var _localizedName:String;
        var _lowerName:String;
        var _displayCode:String;

        public function new(chestItemType:ChestItemType,
            localizedName:String, displayCode:String)
        {
            this._chestItemType = chestItemType;
            this._localizedName = localizedName;
            this._displayCode = displayCode;
            this._lowerName = localizedName.toLowerCase();
        }

        public var identifier(get,never):String;
public function  get_identifier():String
        {
            return (this._chestItemType.isWallItem ? "1-" : "0-") + this._displayCode;
        }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "furni_name":
                    return new TableCell(TableCell.TYPE_TEXT, this._localizedName, false, true);
                case "furni_code":
                    return new TableCell(TableCell.TYPE_TEXT, this._displayCode, false, true);
                case "furni_type":
                    return new TableCell(TableCell.TYPE_TEXT,
                        this._chestItemType.isWallItem
                            ? "${inventory.filter.placement.wall}"
                            : "${inventory.filter.placement.floor}");
            }
            return null;
        }

        public function isPropertyUpdated(columnId:String, previous:ASObject):Bool { return false; }
        public function isUpdated(previous:ASObject):Bool { return false; }
        public var chestItemType(get,never):ChestItemType;
public function  get_chestItemType():ChestItemType { return this._chestItemType; }
        public var localizedName(get,never):String;
public function  get_localizedName():String { return this._localizedName; }
        public var displayCode(get,never):String;
public function  get_displayCode():String { return this._displayCode; }
        public function matchesSubstring(value:String):Bool
        {
            return this._lowerName.indexOf(value) != -1 ||
                this._displayCode.toLowerCase().indexOf(value) != -1;
        }
    }

