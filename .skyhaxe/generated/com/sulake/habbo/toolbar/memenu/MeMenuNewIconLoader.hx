package com.sulake.habbo.toolbar.memenu
;
    import com.sulake.habbo.avatar.IAvatarImage;
    import com.sulake.habbo.avatar.IAvatarImageListener;
    import com.sulake.habbo.avatar._enum.AvatarScaleType;
    import com.sulake.habbo.avatar._enum.AvatarSetType;
    import com.sulake.habbo.communication.messages.incoming.avatar.FigureUpdateEvent;
    import com.sulake.habbo.communication.messages.incoming.handshake.UserObjectEvent;
    import com.sulake.habbo.toolbar.HabboToolbar;
    import com.sulake.habbo.toolbar.HabboToolbarIconEnum;
    import com.sulake.habbo.utils.HabboFaceFocuser;
    import flash.display.BitmapData;
    import flash.geom.Point;
    import flash.geom.Rectangle;

     class MeMenuNewIconLoader implements IAvatarImageListener 
    {
        static inline final ICON_WIDTH= 44;
        static inline final ICON_HEIGHT= 41;
        static inline final ICON_CIRCLE_RADIUS= 22;
        static inline final PORTRAIT_OFFSET_X:Float = 0;
        static inline final PORTRAIT_OFFSET_Y:Float = 2;

        var _toolbar:HabboToolbar;
        var _lastFigure:String;
        var _lastFocusedFace:BitmapData;
        var _userObjectEvent:UserObjectEvent;
        var _figureUpdateEvent:FigureUpdateEvent;

        public function new(k:HabboToolbar)
        {
            this._toolbar = k;
            this._userObjectEvent = new UserObjectEvent(this.onUserObject);
            this._figureUpdateEvent = new FigureUpdateEvent(this.onFigureUpdate);
            this._toolbar.communicationManager.addHabboConnectionMessageEvent(this._userObjectEvent);
            this._toolbar.communicationManager.addHabboConnectionMessageEvent(this._figureUpdateEvent);
            this.renderAvatar();
        }

        function renderAvatar(k:String=null)
        {
var _local_6:BitmapData  = null;            var _local_2:BitmapData = null;
            var _local_3:String = null;
            var _local_4:String = null;
            var _local_5:IAvatarImage = null;
            if (this._toolbar.avatarRenderManager != null)
            {
                _local_3 = ((k == null) ? this._toolbar.sessionDataManager.figure : k);
                if (_local_3 != this._lastFigure)
                {
                    _local_4 = this._toolbar.sessionDataManager.gender;
                    _local_5 = this._toolbar.avatarRenderManager.createAvatarImage(_local_3, AvatarScaleType.LARGE, _local_4, this);
                    if (((!(_local_5 == null)) && (!_local_5.isPlaceholder())))
                    {
                        _local_5.setDirection(AvatarSetType.FULL, 4);
                        _local_5.setDirection(AvatarSetType.HEAD, 3);
_local_6= HabboFaceFocuser.focusUserFace(_local_5, AvatarSetType.FULL, 3, 1);
                        _local_2 = this.renderPortraitIntoIcon(_local_6);
                        if (_local_6 != null)
                        {
                            _local_6.dispose();
                        }
                        _local_5.dispose();
                    }
                    this._lastFigure = _local_3;
                    if (this._lastFocusedFace != null)
                    {
                        this._lastFocusedFace.dispose();
                    }
                    this._lastFocusedFace = _local_2;
                }
                else
                {
                    _local_2 = this._lastFocusedFace;
                }
            }
            if (this._toolbar != null)
            {
                if (_local_2 != null)
                {
                    this._toolbar.setAssetUri(HabboToolbarIconEnum.MEMENU, _local_2.clone());
                }
            }
        }

        function renderPortraitIntoIcon(k:BitmapData):BitmapData
        {
            if (k == null)
            {
                return null;
            }
            var _local_2= new BitmapData(ICON_WIDTH, ICON_HEIGHT, true, 0);
            var _local_3= Std.int(Math.fround(((k.width - ICON_WIDTH) / 2) - PORTRAIT_OFFSET_X));
            var _local_4= Std.int(Math.fround(((k.height - ICON_HEIGHT) / 2) - PORTRAIT_OFFSET_Y));
            if (_local_3 < 0)
            {
                _local_3 = 0;
            }
            if (_local_4 < 0)
            {
                _local_4 = 0;
            }
            if ((_local_3 + ICON_WIDTH) > k.width)
            {
                _local_3 = (k.width - ICON_WIDTH);
            }
            if ((_local_4 + ICON_HEIGHT) > k.height)
            {
                _local_4 = (k.height - ICON_HEIGHT);
            }
            _local_2.copyPixels(k, new Rectangle(_local_3, _local_4, ICON_WIDTH, ICON_HEIGHT), new Point(0, 0));
            var _local_5= HabboFaceFocuser.cutCircleFromBitmap(_local_2, ICON_CIRCLE_RADIUS);
            _local_2.dispose();
            return _local_5;
        }

        public function avatarImageReady(k:String)
        {
            this._lastFigure = "";
            this.renderAvatar();
        }

        function onUserObject(k:UserObjectEvent)
        {
            this.renderAvatar(k.getParser().figure);
        }

        function onFigureUpdate(k:FigureUpdateEvent)
        {
            if (this.disposed)
            {
                return;
            }
            this.renderAvatar(k.figure);
        }

        public function dispose()
        {
            if (this.disposed)
            {
                return;
            }
            if (this._userObjectEvent != null)
            {
                this._toolbar.communicationManager.removeHabboConnectionMessageEvent(this._userObjectEvent);
                this._userObjectEvent = null;
            }
            if (this._figureUpdateEvent != null)
            {
                this._toolbar.communicationManager.removeHabboConnectionMessageEvent(this._figureUpdateEvent);
                this._figureUpdateEvent = null;
            }
            if (this._lastFocusedFace != null)
            {
                this._lastFocusedFace.dispose();
                this._lastFocusedFace = null;
            }
            this._toolbar = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._toolbar == null;
        }
    }

