package com.sulake.habbo.window.utils.tableview
;
     class TableColumn
    {
        var _id:String;
        var _columnName:String;
        var _widthFactor:Float = Math.NaN;
        var _alignment:String;

        public function new(id:String, columnName:String, widthFactor:Float, alignment:String="center")
        {
            this._id = id;
            this._columnName = columnName;
            this._widthFactor = widthFactor;
            if (alignment == "left")
            {
                alignment = "none";
            }
            this._alignment = alignment;
        }

        public var id(get,never):String;
public function  get_id():String
        {
            return this._id;
        }

        public var columnName(get,never):String;
public function  get_columnName():String
        {
            return this._columnName;
        }

        public var widthFactor(get,never):Float;
public function  get_widthFactor():Float
        {
            return this._widthFactor;
        }

        public var alignment(get,never):String;
public function  get_alignment():String
        {
            return this._alignment;
        }
    }

