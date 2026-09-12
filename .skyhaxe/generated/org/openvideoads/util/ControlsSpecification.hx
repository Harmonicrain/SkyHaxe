package org.openvideoads.util
;
    import org.openvideoads.base.Debuggable;

     class ControlsSpecification extends Debuggable 
    {
        public static inline final PLAY= "PLAY";
        public static inline final PAUSE= "PAUSE";
        public static inline final STOP= "STOP";
        public static inline final PLAYLIST= "PLAYLIST";
        public static inline final TIME= "TIME";
        public static inline final VOLUME= "VOLUME";
        public static inline final MUTE= "MUTE";
        public static inline final FULLSCREEN= "FULLSCREEN";

        var _Str_17432:Bool = true;
        var _visible:Bool = true;
        var _Str_2699:Bool = false;
        var _Str_16538:Bool = true;
        var _Str_16202:Bool = true;
        var _Str_16043:Bool = true;
        var _Str_16384:Bool = false;
        var _Str_17436:Bool = false;
        var _Str_18122:Bool = true;
        var _Str_17845:Bool = true;
        var _Str_18434:Bool = true;
        var _height:Int = -999;
        var _Str_21506:Bool = false;
        var _Str_18977:Bool = false;

        public function new(k:ASObject=null)
        {
            super();
            if (k != null)
            {
                this.initialise(k);
            }
        }

        public function initialise(k:ASObject)
        {
            if (k != null)
            {
                if (ASCompat.hasOwnProperty(k, "manage"))
                {
                    this._Str_17432 = StringUtils._Str_2810(k.manage);
                }
                if (ASCompat.hasOwnProperty(k, "visible"))
                {
                    this._visible = StringUtils._Str_2810(k.visible);
                }
                if (ASCompat.hasOwnProperty(k, "enable"))
                {
                    this.enabled = StringUtils._Str_2810(k.enable);
                }
                if (this.enabled == false)
                {
                    if (ASCompat.hasOwnProperty(k, "enablePlay"))
                    {
                        this._Str_16538 = StringUtils._Str_2810(k.enablePlay);
                    }
                    if (ASCompat.hasOwnProperty(k, "enablePause"))
                    {
                        this._Str_16202 = StringUtils._Str_2810(k.enablePause);
                    }
                    if (ASCompat.hasOwnProperty(k, "enableStop"))
                    {
                        this._Str_16043 = StringUtils._Str_2810(k.enableStop);
                    }
                    if (ASCompat.hasOwnProperty(k, "enablePlaylist"))
                    {
                        this._Str_16384 = StringUtils._Str_2810(k.enablePlaylist);
                    }
                    if (ASCompat.hasOwnProperty(k, "enableTime"))
                    {
                        this._Str_17436 = StringUtils._Str_2810(k.enableTime);
                    }
                    if (ASCompat.hasOwnProperty(k, "enableVolume"))
                    {
                        this._Str_18122 = StringUtils._Str_2810(k.enableVolume);
                    }
                    if (ASCompat.hasOwnProperty(k, "enableMute"))
                    {
                        this._Str_17845 = StringUtils._Str_2810(k.enableMute);
                    }
                    if (ASCompat.hasOwnProperty(k, "enableFullscreen"))
                    {
                        this._Str_18434 = StringUtils._Str_2810(k.enableFullscreen);
                    }
                    if (ASCompat.hasOwnProperty(k, "anchorNonLinearToBottom"))
                    {
                        this._Str_18977 = StringUtils._Str_2810(k.anchorNonLinearToBottom);
                    }
                }
                if (ASCompat.hasOwnProperty(k, "hideDock"))
                {
                    this.hideDock = StringUtils._Str_2810(k.hideDock);
                }
                if (ASCompat.hasOwnProperty(k, "height"))
                {
                    this.height = ASCompat.toInt(k.height);
                }
            }
        }

        public function _Str_25897():Bool
        {
            return this._visible;
        }

        public function controlEnabled(k:String):Bool
        {
            if (k != null)
            {
                k = k.toUpperCase();
                if (k == ControlsSpecification.PLAY)
                {
                    return this.enablePlay;
                }
                if (k == ControlsSpecification.PAUSE)
                {
                    return this.enablePause;
                }
                if (k == ControlsSpecification.PLAYLIST)
                {
                    return this.enablePlaylist;
                }
                if (k == ControlsSpecification.TIME)
                {
                    return this.enableTime;
                }
                if (k == ControlsSpecification.VOLUME)
                {
                    return this.enableVolume;
                }
                if (k == ControlsSpecification.MUTE)
                {
                    return this.enableMute;
                }
                if (k == ControlsSpecification.STOP)
                {
                    return this.enableStop;
                }
                if (k == ControlsSpecification.FULLSCREEN)
                {
                    return this.enableFullscreen;
                }
            }
            return false;
        }

        
        public var manage(get,set):Bool;
public function  set_manage(k:Bool):Bool        {
            return this._Str_17432 = k;
        }
public function  get_manage():Bool
        {
            if (this._Str_2699 == true)
            {
                return false;
            }
            return this._Str_17432;
        }

        
        public var hideDock(get,set):Bool;
public function  set_hideDock(k:Bool):Bool        {
            return this._Str_21506 = k;
        }
public function  get_hideDock():Bool
        {
            return this._Str_21506;
        }

        
        public var visible(get,set):Bool;
public function  set_visible(k:Bool):Bool        {
            return this._visible = k;
        }
public function  get_visible():Bool
        {
            return this._visible;
        }

        
        public var anchorNonLinearToBottom(get,set):Bool;
public function  set_anchorNonLinearToBottom(k:Bool):Bool        {
            return this._Str_18977 = k;
        }
public function  get_anchorNonLinearToBottom():Bool
        {
            return this._Str_18977;
        }

        
        public var enabled(get,set):Bool;
public function  set_enabled(k:Bool):Bool        {
            this._Str_2699 = k;
            this.enablePlay = k;
            this.enablePause = k;
            this.enablePlaylist = k;
            this.enableTime = k;
            this.enableVolume = k;
            this.enableStop = k;
            this.enableFullscreen = k;
            return this.enableMute = k;
        }
public function  get_enabled():Bool
        {
            return this._Str_2699;
        }

        
        public var enablePlay(get,set):Bool;
public function  set_enablePlay(k:Bool):Bool        {
            return this._Str_16538 = k;
        }
public function  get_enablePlay():Bool
        {
            return this._Str_16538;
        }

        
        public var enablePause(get,set):Bool;
public function  set_enablePause(k:Bool):Bool        {
            return this._Str_16202 = k;
        }
public function  get_enablePause():Bool
        {
            return this._Str_16202;
        }

        
        public var enableStop(get,set):Bool;
public function  set_enableStop(k:Bool):Bool        {
            return this._Str_16043 = k;
        }
public function  get_enableStop():Bool
        {
            return this._Str_16043;
        }

        
        public var enablePlaylist(get,set):Bool;
public function  set_enablePlaylist(k:Bool):Bool        {
            return this._Str_16384 = k;
        }
public function  get_enablePlaylist():Bool
        {
            return this._Str_16384;
        }

        
        public var enableTime(get,set):Bool;
public function  set_enableTime(k:Bool):Bool        {
            return this._Str_17436 = k;
        }
public function  get_enableTime():Bool
        {
            return this._Str_17436;
        }

        
        public var enableVolume(get,set):Bool;
public function  set_enableVolume(k:Bool):Bool        {
            return this._Str_18122 = k;
        }
public function  get_enableVolume():Bool
        {
            return this._Str_18122;
        }

        
        public var enableMute(get,set):Bool;
public function  set_enableMute(k:Bool):Bool        {
            return this._Str_17845 = k;
        }
public function  get_enableMute():Bool
        {
            return this._Str_17845;
        }

        
        public var enableFullscreen(get,set):Bool;
public function  set_enableFullscreen(k:Bool):Bool        {
            return this._Str_18434 = k;
        }
public function  get_enableFullscreen():Bool
        {
            return this._Str_18434;
        }

        
        public var height(get,set):Int;
public function  set_height(k:Int):Int        {
            return this._height = k;
        }
public function  get_height():Int
        {
            return this._height;
        }

        public function hasHeightSpecified():Bool
        {
            return !(this._height == -999);
        }
    }

