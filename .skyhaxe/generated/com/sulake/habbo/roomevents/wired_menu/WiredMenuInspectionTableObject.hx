package com.sulake.habbo.roomevents.wired_menu
;
    import com.sulake.habbo.communication.messages.incoming.userdefinedroomevents.WiredVariable;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

    /** One live variable row in the July Inspection table. */
     final class WiredMenuInspectionTableObject implements ITableObject
    {
        var _variable:WiredVariable;
        var _value:Int = 0;
        var _canModify:Bool = false;
        var _highlightChanges:Bool = false;
        var _roomEvents:HabboUserDefinedRoomEvents;

        public function new(
            variable:WiredVariable,
            value:Int,
            canModify:Bool,
            highlightChanges:Bool,
            roomEvents:HabboUserDefinedRoomEvents)
        {
            this._variable = variable;
            this._value = value;
            this._canModify = canModify;
            this._highlightChanges = highlightChanges;
            this._roomEvents = roomEvents;
        }

        public var identifier(get,never):String;
public function  get_identifier():String
        {
            return this._variable.variableId;
        }

        public var variable(get,never):WiredVariable;
public function  get_variable():WiredVariable
        {
            return this._variable;
        }

        public var value(get,never):Int;
public function  get_value():Int
        {
            return this._value;
        }

        public var canModify(get,never):Bool;
public function  get_canModify():Bool
        {
            return this._canModify;
        }

        public function getTableCell(columnId:String):TableCell
        {
            if (columnId == "variable")
            {
                return new TableCell(TableCell.TYPE_TEXT,
                    this._variable.variableName, false, true,
                    this._variable.variableName);
            }
            if (columnId == "value")
            {
                return this.createValueCell();
            }
            return new TableCell(TableCell.TYPE_TEXT, "");
        }

        public function isPropertyUpdated(columnId:String,
                                          previous:ASObject):Bool
        {
            var old=
                ASCompat.dynamicAs(previous , WiredMenuInspectionTableObject);
            if (old == null)
            {
                return true;
            }
            if (columnId == "variable")
            {
                return this._variable.variableName !=
                    old._variable.variableName;
            }
            if (columnId == "value")
            {
                return this._canModify != old._canModify
                    || this._variable.hasValue != old._variable.hasValue
                    || (this._variable.hasValue
                        && (this._value != old._value
                            || this.connectedText() != old.connectedText()));
            }
            return false;
        }

        public function isUpdated(previous:ASObject):Bool
        {
            return this.isPropertyUpdated("variable", previous)
                || this.isPropertyUpdated("value", previous);
        }

        function createValueCell():TableCell
        {
            if (!this._variable.hasValue)
            {
                return new TableCell(TableCell.TYPE_TEXT, "");
            }
            if (this._value == 2147483647
                || this._value == -2147483648)
            {
                return new TableCell(TableCell.TYPE_TEXT,
                    this.loc("wiredmenu.inspection.flash_restriction.text"),
                    false, false, null, null, false,
                    this.loc("wiredmenu.inspection.flash_restriction.desc"),
                    16734003);
            }
            var connected= this.connectedText();
            var display= Std.string(this._value)
                + (connected == null ? "" : " (" + connected + ")");
            return new TableCell(TableCell.TYPE_TEXT, display,
                this._variable.canWriteValue && this._canModify, true,
                Std.string(this._value), null, this._highlightChanges);
        }

        function connectedText():String
        {
            if (!this._variable.hasTextConnector
                || this._variable.textConnector == null)
            {
                return null;
            }
            var value:ASObject =
                this._variable.textConnector.getValue(this._value);
            return value == null ? null : ASCompat.toString(value);
        }

        function loc(key:String):String
        {
            return this._roomEvents.localization.getLocalization(key, key);
        }
    }

