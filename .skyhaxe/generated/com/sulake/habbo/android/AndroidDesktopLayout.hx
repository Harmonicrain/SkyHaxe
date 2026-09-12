package com.sulake.habbo.android
;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.ui.widget.enums.RoomWidgetEnum;
    import com.sulake.habbo.utils.HabboWebTools;

     final class AndroidDesktopLayout
    {
        static inline final TOOLBAR_HEIGHT= 47;
        static inline final INFOSTAND_MARGIN= 8;

        var _infoStand:IWindow;
        var _infoStandDesktop:IWindowContainer;

        public static function create():AndroidDesktopLayout
        {
            return (HabboWebTools.isAirMobile ? new AndroidDesktopLayout() : null);
        }

        public function addWidget(widgetType:String, window:IWindow):Bool
        {
            if (((widgetType != RoomWidgetEnum.INFOSTAND) || (window == null)))
            {
                return false;
            }
            this.detachInfoStand();
            this._infoStand = window;
            this._infoStandDesktop = window.desktop ;
            if (this._infoStandDesktop == null)
            {
                this._infoStand = null;
                return false;
            }
            this._infoStandDesktop.addChild(this._infoStand);
            this._infoStand.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.positionInfoStand);
            this._infoStandDesktop.addEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.positionInfoStand);
            this.positionInfoStand();
            return true;
        }

        public function removeWidget(widgetType:String, window:IWindow):Bool
        {
            if (widgetType != RoomWidgetEnum.INFOSTAND)
            {
                return false;
            }
            this.detachInfoStand(window);
            return true;
        }

        public function dispose()
        {
            this.detachInfoStand();
        }

        function detachInfoStand(window:IWindow=null)
        {
            var target= ((window != null) ? window : this._infoStand);
            if (this._infoStand != null)
            {
                this._infoStand.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.positionInfoStand);
            }
            if (this._infoStandDesktop != null)
            {
                this._infoStandDesktop.removeEventListener(WindowEvent.WINDOW_EVENT_RESIZED, this.positionInfoStand);
                if (((target != null) && ((target.parent : ASAny) == (this._infoStandDesktop : ASAny))))
                {
                    this._infoStandDesktop.removeChild(target);
                }
            }
            this._infoStand = null;
            this._infoStandDesktop = null;
        }

        function positionInfoStand(event:WindowEvent=null)
        {
            var bottomMargin = 0;
            if (((this._infoStand == null) || (this._infoStandDesktop == null)))
            {
                return;
            }
            bottomMargin = Std.int(Math.fceil(TOOLBAR_HEIGHT / AndroidUiPolicy.uiScale));
            this._infoStand.x = Std.int(Math.max(INFOSTAND_MARGIN, (this._infoStandDesktop.width - this._infoStand.width) - INFOSTAND_MARGIN));
            this._infoStand.y = Std.int(Math.max(INFOSTAND_MARGIN, ((this._infoStandDesktop.height - this._infoStand.height) - bottomMargin) - INFOSTAND_MARGIN));
        }
public function new(){}
    }

