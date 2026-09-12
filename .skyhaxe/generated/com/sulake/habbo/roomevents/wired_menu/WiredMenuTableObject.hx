package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /**
     * Small typed adapter for July menu data displayed by the clean client's
     * existing TableView. Packet strings remain text and are never parsed as XML.
     */
     final class WiredMenuTableObject implements ITableObject
    {
        var _identifier:String;
        var _cells:ASObject;
        var _data:ASObject;

        public function new(identifier:String, cells:ASObject,
                                             data:ASObject=null)
        {
            this._identifier = identifier;
            this._cells = cells == null ? {} : cells;
            this._data = data;
        }

        public var identifier(get,never):String;
public function  get_identifier():String
        {
            return this._identifier;
        }

        public var data(get,never):ASObject;
public function  get_data():ASObject
        {
            return this._data;
        }

        public function getTableCell(columnId:String):TableCell
        {
            var value:ASObject = ASCompat.getDynamicProperty(this._cells, columnId);
            if (Std.is(value , TableCell))
            {
                return ASCompat.dynamicAs(value , TableCell);
            }
            return new TableCell(TableCell.TYPE_TEXT,
                value == null ? "" : ASCompat.toString(value));
        }

        public function isPropertyUpdated(columnId:String,
                                          previous:ASObject):Bool
        {
            var old= ASCompat.dynamicAs(previous , WiredMenuTableObject);
            return old == null ||
                ASCompat.toString(ASCompat.getDynamicProperty(this._cells, columnId)) != ASCompat.toString(ASCompat.getDynamicProperty(old._cells, columnId));
        }

        public function isUpdated(previous:ASObject):Bool
        {
var key:String  = null;            var old= ASCompat.dynamicAs(previous , WiredMenuTableObject);
            if (old == null)
            {
                return true;
            }
            final _iter_:ASObject = this._cells; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.___keys())
            {
key = _tmp_;
                if (this.isPropertyUpdated(key, old))
                {
                    return true;
                }
            }
            return false;
        }
    }

