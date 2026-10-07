package com.sulake.habbo.friendlist.domain
;
    import com.sulake.habbo.friendlist._Str_6180;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.friendlist.HabboFriendList;

     class _Str_2740 
    {
        var _id:Int = 0;
        var _name:String;
        var _Str_20054:String;
        var _Str_21821:String;
        var _Str_17873:_Str_6180;
        var _Str_15618:Bool = false;
        var _selected:Bool = false;
        var _view:IWindowContainer;

        public function new(k:HabboFriendList, _arg_2:Int, _arg_3:_Str_6180, _arg_4:String, _arg_5:String, _arg_6:String)
        {
            this._id = _arg_2;
            this._name = _arg_4;
            this._Str_17873 = _arg_3;
            this._Str_20054 = _arg_5;
            this._Str_21821 = _arg_6;
            this._Str_17873.init(k);
        }

        public function setSelected(k:Bool)
        {
            if (k)
            {
                this._Str_15618 = false;
            }
            this._selected = k;
        }

        public function _Str_9276(k:Bool)
        {
            if (this.selected)
            {
                this._Str_15618 = false;
            }
            else
            {
                this._Str_15618 = k;
            }
        }

        public var _Str_14035(get,never):Bool;
public function  get__Str_14035():Bool
        {
            return this._Str_15618;
        }

        public var id(get,never):Int;
public function  get_id():Int
        {
            return this._id;
        }

        public var name(get,never):String;
public function  get_name():String
        {
            return this._name;
        }

        public var _Str_24165(get,never):String;
public function  get__Str_24165():String
        {
            return this._Str_20054;
        }

        public var _Str_22380(get,never):String;
public function  get__Str_22380():String
        {
            return this._Str_21821;
        }

        public var selected(get,never):Bool;
public function  get_selected():Bool
        {
            return this._selected;
        }

        public var _Str_4621(get,never):_Str_6180;
public function  get__Str_4621():_Str_6180
        {
            return this._Str_17873;
        }

        
        public var view(get,set):IWindowContainer;
public function  get_view():IWindowContainer
        {
            return this._view;
        }
public function  set_view(k:IWindowContainer):IWindowContainer        {
            return this._view = k;
        }
    }

