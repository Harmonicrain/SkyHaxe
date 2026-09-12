package com.sulake.habbo.ui.widget.chooser
;
    import com.sulake.habbo.ui.widget.events._Str_3405;
    import com.sulake.habbo.utils.BuildersClubTools;
    import com.sulake.habbo.window.utils.tableview.ITableObject;
    import com.sulake.habbo.window.utils.tableview.TableCell;

     class FurniChooserTableObject implements ITableObject
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
                case FurniChooserView.COLUMN_FURNI_NAME:
                    return new TableCell(TableCell.TYPE_TEXT, this._item.name, false, true);
                case FurniChooserView.COLUMN_FURNI_OWNER:
                    if (BuildersClubTools.isBuildersClubFurniture(this._item.id))
                    {
                        return new TableCell(TableCell.TYPE_TEXT, "-", false, true);
                    }
                    if ((this._item.owner == null) || (this._item.owner.length == 0))
                    {
                        return new TableCell(TableCell.TYPE_TEXT, "-");
                    }
                    return new TableCell(TableCell.TYPE_TEXT, this._item.owner, false, true);
                case FurniChooserView.COLUMN_ID:
                    return new TableCell(TableCell.TYPE_TEXT, (Std.string(this._item.id) + ""), false, true);
                default:
                    return null;
            }
        }

        public function isPropertyUpdated(columnId:String, previous:ASObject):Bool
        {
            return true;
        }

        public function isUpdated(previous:ASObject):Bool
        {
            return true;
        }
    }

