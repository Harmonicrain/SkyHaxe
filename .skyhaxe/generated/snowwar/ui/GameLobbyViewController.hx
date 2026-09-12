package snowwar.ui
;
	import com.sulake.core.runtime.IDisposable;
	import com.sulake.core.assets.XmlAsset;
	import com.sulake.habbo.avatar._enum.AvatarSetType;
	import com.sulake.habbo.avatar._enum.AvatarScaleType;
	import com.sulake.habbo.game.WindowUtils;
	import com.sulake.habbo.avatar.IAvatarImageListener;
	import com.sulake.habbo.avatar.IAvatarImage;
	import com.sulake.core.window.components.IItemGridWindow;
	import com.sulake.core.utils.Map;
	import com.sulake.core.window.IWindow;
	import com.sulake.core.window.IWindowContainer;
	import com.sulake.core.window.components.IBitmapWrapperWindow;
	import com.sulake.core.window.components.IRegionWindow;
	import com.sulake.core.window.components.ITextWindow;
	import com.sulake.core.window.events.WindowEvent;
	import com.sulake.core.window.events.WindowMouseEvent;
	import snowwar._str_400._SafeStr_3813;
	import flash.display.BitmapData;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import snowwar.SnowWarEngine;
	import snowwar._str_254.SnowWarAnimatedWindowElement;
	import snowwar._str_496._SafeStr_4032;

     class GameLobbyViewController implements IDisposable implements  IAvatarImageListener 
    {
        var gameViewController:GamesMainViewController;
        var _SafeStr_18579:SnowWarEngine;
        var _SafeStr_18580:String;
        var _SafeStr_18581:Int = 0;
        var _SafeStr_18582:Int = 0;
        var _SafeStr_18583:Int = 0;
        var _SafeStr_9206:IWindowContainer;
        var _SafeStr_18584:Timer;
        var _SafeStr_5217:Int = -1;
        var _SafeStr_14545:Int = -1;
        var _SafeStr_5041:Bool = false;
        var _SafeStr_18585:Array<ASAny>;
        var _SafeStr_18586:Map;

        public function new(k:GamesMainViewController, _arg_2:String, _arg_3:Int, _arg_4:Int)
        {
            this._SafeStr_18585 = [];
            this.gameViewController = k;
            this._SafeStr_18579 = k.snowWarEngine;
            this._SafeStr_18586 = new Map();
            this._SafeStr_18580 = _arg_2;
            this._SafeStr_18581 = _arg_3;
            this._SafeStr_18582 = this._SafeStr_18578;
            this._SafeStr_18583 = _arg_4;
        }

        function _SafeStr_18587()
        {
            var _local_3:Point = null;
            this._SafeStr_9206 = Std.downcast(this.gameViewController.mainWindow.findChildByName("snowwar_lobby_cont") , IWindowContainer);
            this._SafeStr_9206.center();
            this._SafeStr_9206.findChildByName("cancel_link_region").procedure = this._SafeStr_16837;
            var k= Std.downcast(this._SafeStr_9206.findChildByName("players_grid") , IItemGridWindow);
            var _local_2= Std.downcast(WindowUtils.createWindow("snowwar_lobby_player") , IWindowContainer);
            var _local_4 = 0;
            while (_local_4 < this._SafeStr_18583)
            {
                k.addGridItem(_local_2.clone());
                _local_4++;
            }
            _local_2.dispose();
            this._SafeStr_9206.visible = false;
        }

        function createWindow(k:String):IWindowContainer
        {
            var _local_2= Std.downcast(this._SafeStr_18579.assets.getAssetByName(k) , XmlAsset);
            return Std.downcast(this._SafeStr_18579.windowManager.buildFromXML(((_local_2.content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
        }

        function _SafeStr_16837(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this._SafeStr_9859(true);
            if (!this._SafeStr_18579.gameCenterEnabled)
            {
                this.gameViewController.createAndVisible(true);
            }
            else
            {
                this.gameViewController.close(true);
            }
        }

        public function _SafeStr_9859(k:Bool)
        {
            if (k)
            {
                this._SafeStr_18579.communication.connection.send(new _SafeStr_3813());
            }
            this._SafeStr_18588();
            this._SafeStr_14545 = -1;
        }

        
        public var visible(get,set):Bool;
public function  set_visible(k:Bool):Bool        {
            if (this._SafeStr_9206 == null)
            {
                this._SafeStr_18587();
            }
            return this._SafeStr_9206.visible = k;
        }
public function  get_visible():Bool
        {
            if (this._SafeStr_9206 != null)
            {
                return this._SafeStr_9206.visible;
            }
            return false;
        }

        public function dispose()
        {
            var k:SnowWarAnimatedWindowElement = null;
            if (this._SafeStr_18586 != null)
            {
                final _iter_ = this._SafeStr_18586; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_.getValues())
                {
k  = _tmp_;
                    k.dispose();
                }
                this._SafeStr_18586.dispose();
                this._SafeStr_18586 = null;
            }
            if (this._SafeStr_9206 != null)
            {
                this._SafeStr_9206.dispose();
                this._SafeStr_9206 = null;
            }
            this._SafeStr_18588();
            this._SafeStr_18585 = [];
            this._SafeStr_5041 = true;
            this._SafeStr_14545 = -1;
        }

        function _SafeStr_18588()
        {
            if (this._SafeStr_18584 != null)
            {
                this._SafeStr_18584.removeEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
                this._SafeStr_18584.stop();
                this._SafeStr_18584 = null;
            }
            this._SafeStr_5217 = -1;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._SafeStr_5041;
        }

        public function _SafeStr_13276(k:Int)
        {
            var _local_2:_SafeStr_4032 = null;
            final _iter_ = this._SafeStr_18585; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
            {
_local_2  = _tmp_;
                if (_local_2.userId == k)
                {
                    this._SafeStr_18585.splice(this._SafeStr_18585.indexOf(_local_2), 1);
                    break;
                }
            }
            this._SafeStr_18592(true);
        }

        public function _SafeStr_13272(k:_SafeStr_4032)
        {
            if (k != null)
            {
                this._SafeStr_18585.push(k);
                this._SafeStr_18592(true, k.figure);
            }
        }

        public function _SafeStr_18590()
        {
            if (this._SafeStr_18585 != null)
            {
                this._SafeStr_18585 = [];
            }
        }

        public function _SafeStr_13269(k:Int)
        {
            this._SafeStr_18588();
            this._SafeStr_5217 = k;
            this._SafeStr_18584 = new Timer(1000, k);
            this._SafeStr_18584.addEventListener(TimerEvent.TIMER, (this._SafeStr_18589 : ASAny));
            this._SafeStr_18584.start();
            this._SafeStr_18592(false);
        }

        function _SafeStr_18589(k:TimerEvent)
        {
            if (((this._SafeStr_5217 != 0) && (this._SafeStr_5217 > 0)))
            {
                this._SafeStr_5217--;
                HabboGamesCom.log([("on tick " + Std.string(this._SafeStr_5217))]);
                this._SafeStr_18592(false);
            }
        }

        public function _SafeStr_13270()
        {
            this._SafeStr_18588();
            this._SafeStr_18592(false);
        }

        public var _SafeStr_18591(never,set):Int;
public function  set__SafeStr_18591(k:Int):Int        {
            return this._SafeStr_14545 = k;
        }

        function _SafeStr_18592(k:Bool, _arg_2:String=null)
        {
            var _local_6:String = null;
            var _local_7:String = null;
            var _local_11:IRegionWindow = null;
            var _local_12:IBitmapWrapperWindow = null;
            var _local_13:SnowWarAnimatedWindowElement = null;
            var _local_14:_SafeStr_4032 = null;
            var _local_15:IAvatarImage = null;
            var _local_16:BitmapData = null;
            var _local_17:Point = null;
            var _local_3:IWindow = Std.downcast(this._SafeStr_9206.findChildByName("wait_text") , ITextWindow);
            var _local_4:IWindow = Std.downcast(this._SafeStr_9206.findChildByName("wait_text_stroke") , ITextWindow);
            var _local_5= this._SafeStr_18579.localization;
            if (this._SafeStr_5217 >= 0)
            {
                _local_6 = "snowwar.lobby_game_start_countdown";
                _local_5.registerParameter(_local_6, "seconds", Std.string(this._SafeStr_5217));
                _local_7 = ((((_local_6 + " ") + "%seconds%") + " ") + Std.string(this._SafeStr_5217));
            }
            else
            {
                if (this._SafeStr_14545 >= 0)
                {
                    _local_6 = "snowwar.lobby_arena_queue_position";
                    _local_5.registerParameter(_local_6, "position", Std.string(this._SafeStr_14545));
                    _local_7 = ((((_local_6 + " ") + "%position%") + " ") + Std.string(this._SafeStr_14545));
                }
                else
                {
                    _local_6 = "snowwar.lobby_waiting_for_more_players";
                    _local_7 = _local_6;
                }
            }
            var _local_8= _local_5.getLocalization(_local_6);
            if (ASCompat.stringAsBool(_local_8))
            {
                _local_3.caption = _local_8;
                _local_4.caption = _local_8;
            }
            else
            {
                _local_3.caption = _local_7;
                _local_4.caption = _local_7;
            }
            var _local_9 = 0;
            var _local_10= Std.downcast(this._SafeStr_9206.findChildByName("players_grid") , IItemGridWindow);
            if (k)
            {
                final _iter_ = this._SafeStr_18585; if (checkNullIteratee(_iter_)) for (_tmp_ in _iter_)
                {
_local_14  = _tmp_;
                    _local_15 = null;
                    if (((_local_14.figure == _arg_2) || (!ASCompat.stringAsBool(_arg_2))))
                    {
                        _local_15 = this._SafeStr_18579.avatarRenderManager.createAvatarImage(_local_14.figure, AvatarScaleType.LARGE, _local_14.gender, this);
                    }
                    if (_local_15 != null)
                    {
                        _local_15.setDirection(AvatarSetType.HEAD, 2);
_local_16 = _local_15.getCroppedImage(AvatarSetType.HEAD);
                        _local_11 = Std.downcast(_local_10.getGridItemAt(_local_9) , IRegionWindow);
                        if (_local_11 != null)
                        {
                            _local_11.toolTipCaption = _local_14.name;
                            _local_11.mouseThreshold = 0;
                            _local_12 = Std.downcast(_local_11.findChildByName("image") , IBitmapWrapperWindow);
                            _local_13 = this._SafeStr_18586.remove(_local_12);
                            if (_local_13 != null)
                            {
                                _local_13.dispose();
                            }
                            if (_local_12.bitmap != null)
                            {
                                _local_12.bitmap.dispose();
                            }
                            _local_12.bitmap = new BitmapData(_local_12.width, _local_12.height, true, 0);
                            _local_17 = new Point(((_local_12.width - _local_16.width) / 2), ((_local_12.height - _local_16.height) / 2));
                            _local_12.bitmap.copyPixels(_local_16, _local_16.rect, _local_17);
                        }
                        _local_16.dispose();
                        _local_15.dispose();
                    }
                    _local_9++;
                }
                while (_local_9 < this._SafeStr_18593)
                {
                    _local_11 = Std.downcast(_local_10.getGridItemAt(_local_9) , IRegionWindow);
                    _local_12 = Std.downcast(_local_11.findChildByName("image") , IBitmapWrapperWindow);
                    if (!this._SafeStr_18586.hasKey(_local_12))
                    {
                        _local_13 = new SnowWarAnimatedWindowElement(this._SafeStr_18579.assets, _local_12, "load_", 8);
                        this._SafeStr_18586.add(_local_12, _local_13);
                    }
                    _local_9++;
                }
            }
        }

        public function avatarImageReady(k:String)
        {
            this._SafeStr_18592(true, k);
        }

        
        public var _SafeStr_18594(get,set):String;
public function  get__SafeStr_18594():String
        {
            return this._SafeStr_18580;
        }

        
        public var _SafeStr_13274(get,set):Int;
public function  get__SafeStr_13274():Int
        {
            return this._SafeStr_18581;
        }

        
        public var _SafeStr_18578(get,set):Int;
public function  get__SafeStr_18578():Int
        {
            return this._SafeStr_18582;
        }

        
        public var _SafeStr_18593(get,set):Int;
public function  get__SafeStr_18593():Int
        {
            return this._SafeStr_18583;
        }
public function  set__SafeStr_18594(k:String):String        {
            return this._SafeStr_18580 = k;
        }
public function  set__SafeStr_18593(k:Int):Int        {
            return this._SafeStr_18583 = k;
        }
public function  set__SafeStr_13274(k:Int):Int        {
            return this._SafeStr_18581 = k;
        }
public function  set__SafeStr_18578(k:Int):Int        {
            return this._SafeStr_18582 = k;
        }

        public var counter(never,set):Int;
public function  set_counter(k:Int):Int        {
            return this._SafeStr_5217 = k;
        }
    }

