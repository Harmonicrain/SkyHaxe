package com.sulake.habbo.ui.widget.avatarinfo
;
    import com.sulake.habbo.ui.widget.contextmenu.ButtonMenuView;
    import com.sulake.habbo.ui.widget.contextmenu.IContextMenuParentWidget;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.room.object.RoomObjectTypeEnum;
    import flash.geom.Rectangle;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.habbo.friendlist.RelationshipStatusEnum;

     class AvatarContextInfoButtonView extends ButtonMenuView 
    {
        var _Str_2306:Int = 0;
        var _userName:String;
        var _userType:Int = 0;
        var _allowNameChange:Bool = false;
        var _roomIndex:Int = 0;

        public function new(k:IContextMenuParentWidget)
        {
            super(k);
        }

        public static function setup(k:AvatarContextInfoButtonView, _arg_2:Int, _arg_3:String, _arg_4:Int, _arg_5:Int, _arg_6:Bool=false, _arg_7:Bool=false)
        {
            k._Str_2306 = _arg_2;
            k._userName = _arg_3;
            k._userType = _arg_5;
            k._roomIndex = _arg_4;
            k._allowNameChange = _arg_6;
            k._Str_3403 = _arg_7;
            com.sulake.habbo.ui.widget.contextmenu.ContextInfoView._Str_8532(k);
        }


        public var userId(get,never):Int;
public function  get_userId():Int
        {
            return this._Str_2306;
        }

        public var userType(get,never):Int;
public function  get_userType():Int
        {
            return this._userType;
        }

        public var roomIndex(get,never):Int;
public function  get_roomIndex():Int
        {
            return this._roomIndex;
        }

        public var userName(get,never):String;
public function  get_userName():String
        {
            return this._userName;
        }

        public var allowNameChange(get,never):Bool;
public function  get_allowNameChange():Bool
        {
            return this._allowNameChange;
        }

        override function updateWindow()
        {
            var _local_2:com.sulake.core.utils.xml.XML = null;
            var _local_3:IWindow = null;
            if ((((!(_widget != null)) || (!(_widget.assets != null))) || (!(_widget.windowManager != null))))
            {
                return;
            }
            if (_window == null)
            {
                _local_2 = ((_widget.assets.getAssetByName("avatar_info_widget").content : com.sulake.core.utils.xml.XML) );
                _window = Std.downcast(_widget.windowManager.buildFromXML(_local_2, 0) , IWindowContainer);
                if (_window == null)
                {
                    return;
                }
            }
            var k= _window.findChildByName("name");
            k.caption = this._userName;
            this._Str_11603();
            if (!this._allowNameChange)
            {
                _window.findChildByName("change_name_container").visible = false;
                _window.height = 39;
            }
            else
            {
                _local_3 = _window.findChildByName("change_name_container");
                _local_3.visible = true;
                _window.height = (39 + _local_3.height);
                addMouseClickListener(_window.findChildByName("change_name_container"), clickHandler);
            }
            activeView = _window;
			_window.color = RelationshipStatusEnum.relationshipColor(_widget.friendList.getRelationshipStatus(this.userId));
			if (_Str_5032 != null)
			{
				_Str_5032.color = RelationshipStatusEnum.relationshipColor(_widget.friendList.getRelationshipStatus(this.userId));
			}
        }

        override function getOffset(k:Rectangle):Int
        {
            var _local_2= -_Str_3007.height;
            if ((((this._userType == RoomObjectTypeEnum.HABBO) || (this._userType == RoomObjectTypeEnum.BOT)) || (this._userType == RoomObjectTypeEnum.RENTABLE_BOT)))
            {
                _local_2 = (_local_2 + ((k.height > 50) ? 25 : 0));
            }
            else
            {
                _local_2 = (_local_2 - 4);
            }
            return _local_2;
        }

        function _Str_11603()
        {
var status:String  = null;            var k:IStaticBitmapWrapperWindow = null;
            if (((_widget != null) && (_widget.friendList != null)))
            {
                k = cast(_window.findChildByName("relationship_status"), IStaticBitmapWrapperWindow);
status= RelationshipStatusEnum._Str_7401(_widget.friendList.getRelationshipStatus(this.userId));
                k.assetUri = ("relationship_status_" + status);
				_window.color = RelationshipStatusEnum.relationshipColor(_widget.friendList.getRelationshipStatus(this.userId));
				if (_Str_5032 != null)
				{
					_Str_5032.color = RelationshipStatusEnum.relationshipColor(_widget.friendList.getRelationshipStatus(this.userId));
				}
				Logger.log(["_26: " + Std.string(_window.color) + ""]);
				Logger.log(["_26: " + Std.string(k.parent.color) + ""]);
				Logger.log(["_26: " + Std.string(k.parent.parent.color) + ""]);
				
                k.assetUri = ("relationship_status_" + status);
            }
        }
    }

