package com.sulake.habbo.ui.widget.chooser
;
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

     class UserChooserTableObject implements ITableObject
    {
        var _item:_Str_3405;

        public function new(item:_Str_3405)
        {
            this._item = item;
        }

        public var chooserItem(get,never):_Str_3405;
public function  get_chooserItem():_Str_3405
        {
            return this._item;
        }

        public var identifier(get,never):String;
public function  get_identifier():String
        {
            return (Std.string(this._item.category) + "-" + Std.string(this._item.id));
        }

        public function getTableCell(columnId:String):TableCell
        {
            switch (columnId)
            {
                case UserChooserView.COLUMN_USER_NAME:
                    return new TableCell(TableCell.TYPE_TEXT, this._item.name, false, true);
                case UserChooserView.COLUMN_TYPE:
                    return new TableCell(TableCell.TYPE_TEXT, ("${new_user_chooser.usertype." + Std.string(this._item.type)) + "}");
                default:
                    return null;
            }
        }

        public function isPropertyUpdated(columnId:String, previous:ASObject):Bool
        {
            return false;
        }

        public function isUpdated(previous:ASObject):Bool
        {
            return false;
        }
    }

