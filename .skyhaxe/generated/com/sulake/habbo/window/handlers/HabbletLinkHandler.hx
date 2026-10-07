package com.sulake.habbo.window.handlers
;
    import com.sulake.core.runtime.events.ILinkEventTracker;
    import com.sulake.core.runtime.IDisposable;
    import com.sulake.habbo.window.HabboWindowManagerComponent;
    import com.sulake.habbo.utils.HabboWebTools;
    import com.sulake.habboclient.ExternalVariables;

     class HabbletLinkHandler implements ILinkEventTracker implements  IDisposable 
    {
        var _windowManager:HabboWindowManagerComponent;

        public function new(k:HabboWindowManagerComponent)
        {
            this._windowManager = k;
        }

        public var linkPattern(get,never):String;
public function  get_linkPattern():String
        {
            return "habblet/";
        }

        public function linkReceived(k:String)
        {
            var _local_3:String = null;
            var _local_2:Array<ASAny> = (cast k.split("/"));
            if (_local_2.length < 2)
            {
                return;
            }
            switch (_local_2[1])
            {
                case "open":
                    if (_local_2.length > 2)
                    {
                        _local_3 = _local_2[2];
                        if (_local_3 == "credits")
                        {
                            HabboWebTools.openWebPageAndMinimizeClient(this._windowManager.getProperty(ExternalVariables.WEB_SHOP_RELATIVE_URL));
                        }
                        else
                        {
                            HabboWebTools.openHabblet(_local_3);
                        }
                    }
                    return;
            }
        }

        public function dispose()
        {
            this._windowManager = null;
        }

        public var disposed(get,never):Bool;
public function  get_disposed():Bool
        {
            return this._windowManager == null;
        }
    }

