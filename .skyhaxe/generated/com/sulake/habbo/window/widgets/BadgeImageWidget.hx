package com.sulake.habbo.window.widgets
;
    import com.sulake.core.window.utils.PropertyStruct;
    import com.sulake.habbo.window._enum._Str_4387;
    import com.sulake.core.window.components.IWidgetWindow;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.components.IRegionWindow;
    import com.sulake.habbo.communication.messages.incoming.users.GroupDetailsChangedMessageEvent;
    import com.sulake.habbo.communication.messages.incoming.users.HabboGroupBadgesMessageEvent;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.iterators.EmptyIterator;
    import com.sulake.core.window.utils.IIterator;
    import com.sulake.core.window.theme.PropertyKeys;
    import flash.display.BitmapData;
    import com.sulake.habbo.communication.messages.outgoing.users.GetHabboGroupDetailsMessageComposer;
    import com.sulake.habbo.gamecenter.GameConfigurations;
    import flash.geom.Point;

     class BadgeImageWidget implements IBadgeImageWidget
    {
        public static inline final BADGE_IMAGE= "badge_image";
        static final typePropertyKey:String = (BADGE_IMAGE + ":type");
        static final badgeIdPropertyKey:String = (BADGE_IMAGE + ":badge_id");
        static final typeProperty:PropertyStruct = new PropertyStruct(typePropertyKey, _Str_4387.NORMAL, PropertyStruct.STRING, false, _Str_4387.ALL);
        static final badgeIdProperty:PropertyStruct = new PropertyStruct(badgeIdPropertyKey, "", PropertyStruct.STRING);

        var _disposed:Bool = false;
        var _widgetWindow:IWidgetWindow;
        var _windowManager:HabboWindowManagerComponent;
        var _refreshing:Bool = false;
        var _root:IWindowContainer;
        var _bitmap:IStaticBitmapWrapperWindow;
        var _region:IRegionWindow;
        var _type:String;
        var _badgeId:String;
        var _groupId:Int = 0;
        var _groupDetailsChangedMessageEvent:GroupDetailsChangedMessageEvent;
        var _habboGroupBadgesMessageEvent:HabboGroupBadgesMessageEvent;

        public function new(k:IWidgetWindow, _arg_2:HabboWindowManagerComponent)
        {
            this._type = ASCompat.toString(typeProperty.value);
            this._badgeId = ASCompat.toString(badgeIdProperty.value);
            this._widgetWindow = k;
            this._windowManager = _arg_2;
            this._root = Std.downcast(this._windowManager.buildFromXML(((this._windowManager.assets.getAssetByName("badge_image_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            this._bitmap = Std.downcast(this._root.findChildByName("bitmap") , IStaticBitmapWrapperWindow);
            this._region = Std.downcast(this._root.findChildByName("region") , IRegionWindow);
            this._region.addEventListener(WindowMouseEvent.CLICK, this.onClick);
            this._widgetWindow.rootWindow = this._root;
            this._root.width = this._widgetWindow.width;
            this._root.height = this._widgetWindow.height;
        }

        public function dispose()
        {
            if (!this._disposed)
            {
                this.groupId = 0;
                if (this._region != null)
                {
                    this._region.removeEventListener(WindowMouseEvent.CLICK, this.onClick);
                    this._region.dispose();
                    this._region = null;
                }
                this._bitmap = null;
                if (this._root != null)
                {
                    this._root.dispose();
                    this._root = null;
                }
                if (this._widgetWindow != null)
                {
                    this._widgetWindow.rootWindow = null;
                    this._widgetWindow = null;
                }
                this._windowManager = null;
                this._disposed = true;
            }
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._disposed;
        }

        public var iterator(get,never):IIterator;
public function  get_iterator():IIterator
        {
            return EmptyIterator.INSTANCE;
        }

        
        public var properties(get,set):Array<ASAny>;
public function  get_properties():Array<ASAny>
        {
            var _local_2:PropertyStruct = null;
            var k:Array<ASAny> = [];
            if (this._disposed)
            {
                return k;
            }
            k.push(typeProperty.withValue(this._type));
            k.push(badgeIdProperty.withValue(this._badgeId));
            final _iter_ = this._bitmap.properties; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.key != PropertyKeys.ASSET_URI)
                {
                    k.push(_local_2.withNameSpace(BADGE_IMAGE));
                }
            }
            return k;
        }
public function  set_properties(k:Array<ASAny>):Array<ASAny>        {
            var _local_3:PropertyStruct = null;
            this._refreshing = true;
            var _local_2:Array<ASAny> = [];
            if (checkNullIteratee(k)) for (_tmp_ in k)
            {
_local_3  = _tmp_;
                switch (_local_3.key)
                {
                    case typePropertyKey:
                        this.type = ASCompat.toString(_local_3.value);
                        
                    case badgeIdPropertyKey:
                        this.badgeId = ASCompat.toString(_local_3.value);
                        
                }
                if (_local_3.key != ((BADGE_IMAGE + ":") + PropertyKeys.ASSET_URI))
                {
                    _local_2.push(_local_3.withoutNameSpace());
                }
            }
            this._bitmap.properties = _local_2;
            this._refreshing = false;
            this.refresh();
return k;
        }

        
        public var type(get,set):String;
public function  get_type():String
        {
            return this._type;
        }
public function  set_type(k:String):String        {
            this._type = k;
            this.refresh();
return k;
        }

        
        public var badgeId(get,set):String;
public function  get_badgeId():String
        {
            return this._badgeId;
        }
public function  set_badgeId(k:String):String        {
            this._badgeId = k;
            this.refresh();
return k;
        }

        
        public var groupId(get,set):Int;
public function  get_groupId():Int
        {
            return this._groupId;
        }
public function  set_groupId(k:Int):Int        {
            this._groupId = k;
            var _local_2= ((this._type == _Str_4387.GROUP) && (this._groupId > 0));
            if (((!(this._windowManager == null)) && (!(this._windowManager.communication == null))))
            {
                if (((!_local_2) && (!(this._habboGroupBadgesMessageEvent == null))))
                {
                    this._windowManager.communication.removeHabboConnectionMessageEvent(this._groupDetailsChangedMessageEvent);
                    this._windowManager.communication.removeHabboConnectionMessageEvent(this._habboGroupBadgesMessageEvent);
                    this._groupDetailsChangedMessageEvent = null;
                    this._habboGroupBadgesMessageEvent = null;
                }
                else
                {
                    if ((_local_2 && (this._habboGroupBadgesMessageEvent == null)))
                    {
                        this._groupDetailsChangedMessageEvent = new GroupDetailsChangedMessageEvent(this.onGroupDetailsChanged);
                        this._habboGroupBadgesMessageEvent = new HabboGroupBadgesMessageEvent(this._Str_18218);
                        this._windowManager.communication.addHabboConnectionMessageEvent(this._groupDetailsChangedMessageEvent);
                        this._windowManager.communication.addHabboConnectionMessageEvent(this._habboGroupBadgesMessageEvent);
                    }
                }
            }
return k;
        }

        public var bitmapData(get,never):BitmapData;
public function  get_bitmapData():BitmapData
        {
            return this._bitmap.bitmapData;
        }

        
        public var pivotPoint(get,set):UInt;
public function  get_pivotPoint():UInt
        {
            return this._bitmap.pivotPoint;
        }
public function  set_pivotPoint(k:UInt):UInt        {
            this._bitmap.pivotPoint = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var stretchedX(get,set):Bool;
public function  get_stretchedX():Bool
        {
            return this._bitmap.stretchedX;
        }
public function  set_stretchedX(k:Bool):Bool        {
            this._bitmap.stretchedX = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var stretchedY(get,set):Bool;
public function  get_stretchedY():Bool
        {
            return this._bitmap.stretchedY;
        }
public function  set_stretchedY(k:Bool):Bool        {
            this._bitmap.stretchedY = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var zoomX(get,set):Float;
public function  get_zoomX():Float
        {
            return this._bitmap.zoomX;
        }
public function  set_zoomX(k:Float):Float        {
            this._bitmap.zoomX = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var zoomY(get,set):Float;
public function  get_zoomY():Float
        {
            return this._bitmap.zoomY;
        }
public function  set_zoomY(k:Float):Float        {
            this._bitmap.zoomY = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var greyscale(get,set):Bool;
public function  get_greyscale():Bool
        {
            return this._bitmap.greyscale;
        }
public function  set_greyscale(k:Bool):Bool        {
            this._bitmap.greyscale = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var etchingColor(get,set):UInt;
public function  get_etchingColor():UInt
        {
            return this._bitmap.etchingColor;
        }
public function  set_etchingColor(k:UInt):UInt        {
            this._bitmap.etchingColor = k;
            this._bitmap.invalidate();
return k;
        }

        
        public var fitSizeToContents(get,set):Bool;
public function  get_fitSizeToContents():Bool
        {
            return this._bitmap.fitSizeToContents;
        }
public function  set_fitSizeToContents(k:Bool):Bool        {
            this._bitmap.fitSizeToContents = k;
            this._bitmap.invalidate();
return k;
        }

        function onClick(k:WindowMouseEvent)
        {
            if (this._groupId > 0)
            {
                this._windowManager.communication.connection.send(new GetHabboGroupDetailsMessageComposer(this._groupId, true));
            }
        }

        function refresh()
        {
            if (this._refreshing)
            {
                return;
            }
            this._bitmap.assetUri = this.assetUri;
            this._bitmap.invalidate();
        }

        var assetUri(get,never):String;
function  get_assetUri():String
        {
            var k= "";
            if (((!(this._badgeId == null)) && (this._badgeId.length > 0)))
            {
                switch (this._type)
                {
                    case _Str_4387.NORMAL:
                        if (GameConfigurations.isGameBadge(this._badgeId))
                        {
                            k = GameConfigurations.getBadgeImageUri(this._badgeId);
                        }
                        else
                        {
                            k = (("${image.library.url}album1584/" + this._badgeId) + ".gif");
                        }
                        
                    case _Str_4387.GROUP:
                        k = ASCompat.stringReplace(this._windowManager.getProperty("group.badge.url"), "%imagerdata%", this._badgeId);
                        
                    case _Str_4387.PERK:
                        k = (("${image.library.url}perk/" + this._badgeId) + ".png");
                        
                }
            }
            return k;
        }

        function _Str_22252(k:Int, _arg_2:String)
        {
            if (k != this._groupId)
            {
                return;
            }
            this._badgeId = _arg_2;
            this._windowManager.resourceManager.removeAsset(this.assetUri);
            this.refresh();
        }

        function onGroupDetailsChanged(k:GroupDetailsChangedMessageEvent)
        {
            this._Str_22252(k.groupId, this._badgeId);
        }

        function _Str_18218(k:HabboGroupBadgesMessageEvent)
        {
            if (k.badges.hasKey(this._groupId))
            {
                this._Str_22252(this._groupId, k.badges.getValue(this._groupId));
            }
        }

        public var etchingPoint(get,never):Point;
public function  get_etchingPoint():Point
        {
            return new Point(0, 1);
        }

        
        public var wrapX(get,set):Bool;
public function  get_wrapX():Bool
        {
            return false;
        }
public function  set_wrapX(k:Bool):Bool        {
return k;
        }

        
        public var wrapY(get,set):Bool;
public function  get_wrapY():Bool
        {
            return false;
        }
public function  set_wrapY(k:Bool):Bool        {
return k;
        }
    }







