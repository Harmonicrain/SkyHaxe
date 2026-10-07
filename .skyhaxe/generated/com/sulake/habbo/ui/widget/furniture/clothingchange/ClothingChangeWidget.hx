package com.sulake.habbo.ui.widget.furniture.clothingchange
;
    import com.sulake.habbo.ui.widget.RoomWidgetBase;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.habbo.ui.IRoomWidgetHandler;
    import com.sulake.habbo.window.IHabboWindowManager;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.habbo.localization.IHabboLocalizationManager;
    import com.sulake.habbo.ui.widget.events.RoomWidgetClothingChangeUpdateEvent;
    import flash.events.IEventDispatcher;
    import com.sulake.core.assets.XmlAsset;
    import com.sulake.core.window._enum.WindowType;
    import com.sulake.habbo.window._enum.HabboWindowStyle;
    import com.sulake.core.window._enum.WindowParam;
    import flash.geom.Rectangle;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.IWindow;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.habbo.avatar.figuredata.FigureData;
    import com.sulake.habbo.ui.widget.messages.RoomWidgetClothingChangeMessage;

     class ClothingChangeWidget extends RoomWidgetBase
    {
        static inline final BOY= "Boy";
        static inline final GIRL= "Girl";

        var _genderSelectionWindow:IWindowContainer;
        var _objectId:Int = 0;
        var _objectCategory:Int = 0;
        var _roomId:Int = 0;

        public function new(k:IRoomWidgetHandler, _arg_2:IHabboWindowManager, _arg_3:IAssetLibrary=null, _arg_4:IHabboLocalizationManager=null)
        {
            super(k, _arg_2, _arg_3, _arg_4);
        }

        override public function dispose()
        {
            this.hideGenderSelectionInterface();
            super.dispose();
        }

        override public function registerUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.addEventListener(RoomWidgetClothingChangeUpdateEvent.RWCCUE_SHOW_GENDER_SELECTION, this.onUpdate);
            k.addEventListener(RoomWidgetClothingChangeUpdateEvent.RWCCUE_SHOW_CLOTHING_EDITOR, this.onUpdate);
            super.registerUpdateEvents(k);
        }

        override public function unregisterUpdateEvents(k:IEventDispatcher)
        {
            if (k == null)
            {
                return;
            }
            k.removeEventListener(RoomWidgetClothingChangeUpdateEvent.RWCCUE_SHOW_GENDER_SELECTION, this.onUpdate);
            k.removeEventListener(RoomWidgetClothingChangeUpdateEvent.RWCCUE_SHOW_CLOTHING_EDITOR, this.onUpdate);
        }

        function onUpdate(k:RoomWidgetClothingChangeUpdateEvent)
        {
            switch (k.type)
            {
                case RoomWidgetClothingChangeUpdateEvent.RWCCUE_SHOW_GENDER_SELECTION:
                    this.showGenderSelectionInterface(k);
                    return;
            }
        }

        function showGenderSelectionInterface(k:RoomWidgetClothingChangeUpdateEvent)
        {
            this.hideGenderSelectionInterface();
            this._objectId = k.objectId;
            this._objectCategory = k.objectCategory;
            this._roomId = k.roomId;
            var _local_2= assets.getAssetByName("boygirl");
            var _local_3= cast(_local_2, XmlAsset);
            if (_local_3 == null)
            {
                return;
            }
            this._genderSelectionWindow = Std.downcast(windowManager.createWindow("clothing change gender selection", "", WindowType.WINDOW_TYPE_CONTAINER, HabboWindowStyle.NULL, (((ASCompat.toInt(WindowParam.WINDOW_PARAM_MOUSE_DRAGGING_TARGET )| ASCompat.toInt(WindowParam.WINDOW_PARAM_PARENT_WINDOW)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_EXPAND_TO_ACCOMMODATE_CHILDREN)) | ASCompat.toInt(WindowParam.WINDOW_PARAM_INPUT_EVENT_PROCESSOR)), new Rectangle(100, 100, 200, 200), null, 0) , IWindowContainer);
            this._genderSelectionWindow.buildFromXML(new com.sulake.core.utils.xml.XML(_local_3.content));
            this._genderSelectionWindow.addEventListener(WindowMouseEvent.CLICK, this.onGenderSelectionMouseEvent);
            this._genderSelectionWindow.center();
            var _local_4= this._genderSelectionWindow.findChildByTag("close");
            if (_local_4 != null)
            {
                _local_4.procedure = this.onGenderSelectionWindowClose;
            }
            _local_4 = this._genderSelectionWindow.findChildByName(BOY);
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onGenderSelectionMouseEvent);
            }
            _local_4 = this._genderSelectionWindow.findChildByName(GIRL);
            if (_local_4 != null)
            {
                _local_4.addEventListener(WindowMouseEvent.CLICK, this.onGenderSelectionMouseEvent);
            }
        }

        function hideGenderSelectionInterface()
        {
            if (this._genderSelectionWindow != null)
            {
                this._genderSelectionWindow.dispose();
                this._genderSelectionWindow = null;
            }
        }

        function onGenderSelectionWindowClose(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type != WindowMouseEvent.CLICK)
            {
                return;
            }
            this.hideGenderSelectionInterface();
        }

        function onGenderSelectionMouseEvent(k:WindowMouseEvent)
        {
            var _local_2= k.target ;
            var _local_3= _local_2.name;
            switch (_local_3)
            {
                case BOY:
                    this.requestEditor(FigureData.M);
                    this.hideGenderSelectionInterface();
                    return;
                case GIRL:
                    this.requestEditor(FigureData.F);
                    this.hideGenderSelectionInterface();
                    return;
                case "close"
                   | "close_btn":
                    this.hideGenderSelectionInterface();
                    return;
            }
        }

        function requestEditor(k:String)
        {
            var _local_2= new RoomWidgetClothingChangeMessage(RoomWidgetClothingChangeMessage.RWCCM_REQUEST_EDITOR, k, this._objectId, this._objectCategory, this._roomId);
            messageListener.processWidgetMessage(_local_2);
        }
    }

