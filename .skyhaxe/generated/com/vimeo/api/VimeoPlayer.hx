package com.vimeo.api
;
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.system.Security;
    import flash.net.URLRequest;
    import flash.system.LoaderContext;
    import flash.display.Loader;
    import flash.events.Event;
    import flash.display.DisplayObject;
    import flash.events.MouseEvent;
    import flash.events.TimerEvent;
    import flash.geom.Point;

     class VimeoPlayer extends Sprite 
    {
        var container:Sprite;
        var _Str_3552:ASObject = false;
        var _Str_9384:Sprite;
        var _Str_16225:Int = 400;
        var _Str_17880:Int = 300;
        var _Str_21432:Int = 2;
        var _Str_11297:Timer;

        public function new(k:String, _arg_2:Int, _arg_3:Int, _arg_4:Int, _arg_5:String="10", _arg_6:Int=2)
        {
            this.container = new Sprite();
            this._Str_9384 = new Sprite();
            this._Str_11297 = new Timer(200);
            super();
            this._Str_19791(_arg_3, _arg_4);
            Security.allowDomain(["vimeo.com"]);
            Security.allowDomain(["api.vimeo.com"]);
            var _local_7= "&js_api=1";
            this._Str_21432 = _arg_6;
            if (_arg_5 != "9")
            {
                switch (_arg_6)
                {
                    case 2:
                        _local_7 = "&api=1";
                        
                }
            }
            else
            {
                this._Str_21432 = 1;
            }
            var _local_8= new URLRequest((((((((((((("http://api.vimeo.com/moogaloop_api.swf?oauth_key=" + k) + "&clip_id=") + Std.string(_arg_2)) + "&width=") + Std.string(_arg_3)) + "&height=") + Std.string(_arg_4)) + "&fullscreen=0&fp_version=") + _arg_5) + _local_7) + "&cache_buster=") + Std.string(Math.random() * 1000)));
            var _local_9= new LoaderContext(true);
            var _local_10= new Loader();
            _local_10.contentLoaderInfo.addEventListener(Event.COMPLETE, (this.onComplete : ASAny), false, 0, true);
            _local_10.load(_local_8, _local_9);
            this.addEventListener(Event.ADDED_TO_STAGE, (this._Str_24616 : ASAny), false, 0, true);
        }

        public function destroy()
        {
            if (this._Str_3552 == null)
            {
                return;
            }
            if (ASCompat.getDynamicProperty(this._Str_3552, "destroy")!= /*undefined*/null)
            {
                this._Str_3552.destroy();
            }
            if (this.container.contains(cast(this._Str_3552, DisplayObject)))
            {
                this.container.removeChild(cast(this._Str_3552, DisplayObject));
            }
            if (this.contains(this._Str_9384))
            {
                this.removeChild(this._Str_9384);
            }
            if (this.contains(this.container))
            {
                this.removeChild(this.container);
            }
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, (this.mouseMove : ASAny));
        }

        function _Str_19791(k:Int, _arg_2:Int)
        {
            this._Str_16225 = k;
            this._Str_17880 = _arg_2;
        }

        function onComplete(k:Event)
        {
            this.container.addChild(k.currentTarget.loader.content);
            this._Str_3552 = k.currentTarget.loader.content;
            this.addChild(this._Str_9384);
            this.container.mask = this._Str_9384;
            this.addChild(this.container);
            this._Str_21200();
            this._Str_11297.addEventListener(TimerEvent.TIMER, (this._Str_20624 : ASAny));
            this._Str_11297.start();
        }

        function _Str_20624(k:TimerEvent)
        {
            if (this._Str_3552.player_loaded)
            {
                this._Str_11297.stop();
                this._Str_11297.removeEventListener(TimerEvent.TIMER, (this._Str_20624 : ASAny));
                this._Str_3552.disableMouseMove();
                if (stage != null)
                {
                    stage.addEventListener(MouseEvent.MOUSE_MOVE, (this.mouseMove : ASAny), false, 0, true);
                }
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }

        function mouseMove(k:Event)
        {
            var _local_3:Point = null;
            var _local_2= Std.downcast(k , MouseEvent);
            if (_local_2 == null)
            {
                return;
            }
            if ((ASCompat.toBool(this._Str_3552) && ASCompat.toBool(this._Str_3552.player_loaded)))
            {
                _local_3 = this.parent.localToGlobal(new Point(this.x, this.y));
                if (((((_local_2.stageX >= _local_3.x) && (_local_2.stageX <= (_local_3.x + this._Str_16225))) && (_local_2.stageY >= _local_3.y)) && (_local_2.stageY <= (_local_3.y + this._Str_17880))))
                {
                    this._Str_3552.mouseMove(_local_2);
                }
                else
                {
                    this._Str_3552.mouseOut();
                }
            }
        }

        function _Str_21200()
        {
            var _local_2:ASAny = this._Str_9384.graphics;
            _local_2.beginFill(0, 1);
            _local_2.drawRect(container.x, container.y, _Str_16225, _Str_17880);
            _local_2.endFill();
        }

        public function play()
        {
            this._Str_3552.play();
        }

        public function pause()
        {
            this._Str_3552.pause();
        }

        public function _Str_26324():Int
        {
            return ASCompat.toInt(this._Str_3552.duration);
        }

        public function _Str_26202(k:Int)
        {
            this._Str_3552.seek(k);
        }

        public function _Str_25964(k:String)
        {
            this._Str_3552.color = ASCompat.toUInt(("0x" + k));
        }

        public function loadVideo(k:Int)
        {
            this._Str_3552.loadVideo(k);
        }

        public function setSize(k:Int, _arg_2:Int)
        {
            this._Str_19791(k, _arg_2);
            this._Str_3552.setSize(k, _arg_2);
            this._Str_21200();
        }

        function _Str_24616(k:Event)
        {
            stage.addEventListener(MouseEvent.MOUSE_MOVE, (this.mouseMove : ASAny));
            this.addEventListener(Event.REMOVED_FROM_STAGE, (this._Str_21890 : ASAny), false, 0, true);
        }

        function _Str_21890(k:Event)
        {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE, (this.mouseMove : ASAny));
            this.removeEventListener(Event.REMOVED_FROM_STAGE, (this._Str_21890 : ASAny));
        }
    }

