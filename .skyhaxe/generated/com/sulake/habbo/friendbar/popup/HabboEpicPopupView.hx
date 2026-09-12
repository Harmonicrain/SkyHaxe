package com.sulake.habbo.friendbar.popup
;
    import com.sulake.habbo.friendbar.view.AbstractView;
    import com.sulake.habbo.friendbar.IHabboEpicPopupView;
    import com.sulake.habbo.communication.IHabboCommunicationManager;
    import com.sulake.core.window.IWindowContainer;
    import com.sulake.core.runtime.IContext;
    import com.sulake.core.assets.IAssetLibrary;
    import com.sulake.core.runtime.ComponentDependency;
    import com.sulake.iid.IIDHabboCommunicationManager;
    import com.sulake.habbo.communication.messages.incoming.quest.EpicPopupMessageEvent;
    import com.sulake.core.window.components.IStaticBitmapWrapperWindow;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class HabboEpicPopupView extends AbstractView implements IHabboEpicPopupView 
    {
        var _communicationManager:IHabboCommunicationManager;
        var _activeFrame:IWindowContainer;

        public function new(k:IContext, _arg_2:UInt, _arg_3:IAssetLibrary)
        {
            super(k, _arg_2, _arg_3);
        }

        override function  get_dependencies():Vector<ComponentDependency>
        {
            return super.dependencies.concat(Vector.ofArray([new ComponentDependency(new IIDHabboCommunicationManager(), function (k:IHabboCommunicationManager)
            {
                _communicationManager = k;
            })]));
        }

        override public function dispose()
        {
            if (this._activeFrame != null)
            {
                this._activeFrame.dispose();
                this._activeFrame = null;
            }
            super.dispose();
        }

        override function initComponent()
        {
            this._communicationManager.addHabboConnectionMessageEvent(new EpicPopupMessageEvent(this._Str_24581));
        }

        function _Str_24581(k:EpicPopupMessageEvent)
        {
            this._Str_8168(k.getParser()._Str_24035);
        }

        public function _Str_8168(k:String)
        {
            if (this._activeFrame != null)
            {
                this._activeFrame.dispose();
            }
            this._activeFrame = Std.downcast(_windowManager.buildFromXML(((assets.getAssetByName("epic_popup_frame_xml").content : com.sulake.core.utils.xml.XML) )) , IWindowContainer);
            cast(this._activeFrame.findChildByName("content_static_bitmap"), IStaticBitmapWrapperWindow).assetUri = k;
            this._activeFrame.procedure = this._Str_12416;
            this._activeFrame.center();
        }

        function _Str_12416(k:WindowEvent, _arg_2:IWindow)
        {
            if (((!(this._activeFrame == null)) && (k.type == WindowMouseEvent.CLICK)))
            {
                switch (k.target.name)
                {
                    case "close_button"
                       | "header_button_close":
                        this._activeFrame.dispose();
                        this._activeFrame = null;
                        return;
                }
            }
        }
    }

