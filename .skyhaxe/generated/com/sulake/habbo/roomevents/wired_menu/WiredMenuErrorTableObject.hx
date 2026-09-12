package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /** One official July Monitor diagnostic row. */
     final class WiredMenuErrorTableObject implements ITableObject
    {
        var _error:ASObject;
        var _latest:String;
        var _openCallback:ASFunction;

        public function new(
            error:ASObject, latest:String, openCallback:ASFunction)
        {
            this._error = error;
            this._latest = latest;
            this._openCallback = openCallback;
        }

        public var identifier(get,never):String;
public function  get_identifier():String
        {
            return ASCompat.toString(this._error.id);
        }

        public var data(get,never):ASObject;
public function  get_data():ASObject
        {
            return this._error;
        }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case "name":
                    return new TableCell(TableCell.TYPE_LINK,
                        ASCompat.toString(this._error.name), false, false, null,
                        this.open);
                case "category":
                    return new TableCell(TableCell.TYPE_TEXT,
                        ASCompat.toString(this._error.category));
                case "count":
                    return new TableCell(TableCell.TYPE_TEXT,
                        ASCompat.toString(this._error.count));
                case "latest":
                    return new TableCell(TableCell.TYPE_TEXT, this._latest);
            }
            return new TableCell(TableCell.TYPE_TEXT, "");
        }

        public function isPropertyUpdated(columnId:String,
                                          previous:ASObject):Bool
        {
            var old=
                ASCompat.dynamicAs(previous , WiredMenuErrorTableObject);
            if (old == null)
            {
                return true;
            }
            switch (columnId)
            {
                case "name":
                    return ASCompat.toString(this._error.name)
                        != ASCompat.toString(old._error.name);
                case "category":
                    return ASCompat.toString(this._error.category)
                        != ASCompat.toString(old._error.category);
                case "count":
                    return ASCompat.toInt(this._error.count) != ASCompat.toInt(old._error.count);
                case "latest":
                    return this._latest != old._latest;
            }
            return false;
        }

        public function isUpdated(previous:ASObject):Bool
        {
            return this.isPropertyUpdated("name", previous)
                || this.isPropertyUpdated("category", previous)
                || this.isPropertyUpdated("count", previous)
                || this.isPropertyUpdated("latest", previous);
        }

        function open()
        {
            if (this._openCallback != null)
            {
                this._openCallback(this._error);
            }
        }
    }

