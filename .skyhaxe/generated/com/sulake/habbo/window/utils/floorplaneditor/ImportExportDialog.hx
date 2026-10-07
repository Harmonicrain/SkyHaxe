package com.sulake.habbo.window.utils.floorplaneditor
;
    import com.sulake.core.window.components.IFrameWindow;
    import com.sulake.habbo.session.SecurityLevelEnum;
    import com.sulake.core.window.events.WindowMouseEvent;
    import com.sulake.habbo.communication.messages.outgoing.room.layout.UpdateFloorPropertiesMessageComposer;
    import com.sulake.core.window.events.WindowEvent;
    import com.sulake.core.window.IWindow;

     class ImportExportDialog 
    {
        var _bcFloorPlanEditor:BCFloorPlanEditor;
        var _layout:com.sulake.core.utils.xml.XML;
        var _window:IFrameWindow = null;

        public function new(k:BCFloorPlanEditor, _arg_2:com.sulake.core.utils.xml.XML)
        {
            this._bcFloorPlanEditor = k;
            this._layout = _arg_2;
        }

        
        public var visible(get,set):Bool;
public function  set_visible(k:Bool):Bool        {
            if (this._window == null)
            {
                this._window = cast(this._bcFloorPlanEditor.windowManager.buildFromXML(this._layout), IFrameWindow);
                this._window.center();
                this._window.procedure = this.windowProcedure;
            }
            if (k)
            {
                this._window.visible = true;
                this._window.findChildByName("data").caption = this._bcFloorPlanEditor._Str_4134._Str_21406();
                if (((this._bcFloorPlanEditor._Str_22721 > 0) || this._bcFloorPlanEditor.windowManager.sessionDataManager.hasSecurity(SecurityLevelEnum.EMPLOYEE)))
                {
                    this._window.findChildByName("save").enable();
                }
                else
                {
                    this._window.findChildByName("save").disable();
                }
                this._window.activate();
            }
            else
            {
                this._window.visible = false;
            }
return k;
        }
public function  get_visible():Bool
        {
            if (this._window == null)
            {
                return false;
            }
            return this._window.visible;
        }

        function windowProcedure(k:WindowEvent, _arg_2:IWindow)
        {
            if (k.type == WindowMouseEvent.CLICK)
            {
                switch (_arg_2.name)
                {
                    case "header_button_close":
                        this.visible = false;
                        return;
                    case "revert":
                        this._window.findChildByName("data").caption = this._bcFloorPlanEditor._Str_24411;
                        return;
                    case "save":
                        this._bcFloorPlanEditor.windowManager.communication.connection.send(new UpdateFloorPropertiesMessageComposer(this._window.findChildByName("data").caption, Std.int(this._bcFloorPlanEditor._Str_4134._Str_7642.x), Std.int(this._bcFloorPlanEditor._Str_4134._Str_7642.y), this._bcFloorPlanEditor._Str_4134._Str_6184, BCFloorPlanEditor._Str_8298(this._bcFloorPlanEditor.wallThickness), BCFloorPlanEditor._Str_8298(this._bcFloorPlanEditor.floorThickness)));
                        return;
                }
            }
        }
    }

