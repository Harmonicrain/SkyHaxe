package com.sulake.habbo.ui.widget.furniture.friendfurni
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.handler.FriendFurniEngravingWidgetHandler;
    import com.sulake.habbo.ui.widget.enums.FriendFurniEngravingWidgetTypeEnum;
    import com.sulake.habbo.room.object.data.StringArrayStuffData;

     class FriendFurniEngravingWidget extends RoomWidgetBase
    {
        var _stuffId:Int = -1;
        var _engravingView:FriendFurniEngravingView;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary, _arg_4:IHabboLocalizationManager)
        {
            super(k, _arg_2, _arg_3, _arg_4);
            this._Str_11963.widget = this;
        }

        public var stuffId(get,never):Int;
public function  get_stuffId():Int
        {
            return this._stuffId;
        }

        public var _Str_11963(get,never):FriendFurniEngravingWidgetHandler;
public function  get__Str_11963():FriendFurniEngravingWidgetHandler
        {
            return Std.downcast(_handler , FriendFurniEngravingWidgetHandler);
        }

        public function open(k:Int, _arg_2:Int, _arg_3:StringArrayStuffData)
        {
            this.close(this._stuffId);
            this._stuffId = k;
            switch (_arg_2)
            {
                case FriendFurniEngravingWidgetTypeEnum.LOVE_LOCK:
                    this._engravingView = new LoveLockEngravingView(this, _arg_3);
                    
                case FriendFurniEngravingWidgetTypeEnum.CARVE_A_TREE:
                    
                case FriendFurniEngravingWidgetTypeEnum.FRIENDS_PORTRAIT:
                    
                case FriendFurniEngravingWidgetTypeEnum.WILD_WEST_WANTED:
                    this._engravingView = new WildWestEngravingView(this, _arg_3);
                    
                case FriendFurniEngravingWidgetTypeEnum.HABBOWEEN:
                    this._engravingView = new HabboweenEngravingView(this, _arg_3);
                    
            }
            this._engravingView.open();
        }

        public function close(k:Int)
        {
            if (((k == this._stuffId) && (this._engravingView != null)))
            {
                this._engravingView.dispose();
                this._engravingView = null;
                this._stuffId = -1;
            }
        }
    }

