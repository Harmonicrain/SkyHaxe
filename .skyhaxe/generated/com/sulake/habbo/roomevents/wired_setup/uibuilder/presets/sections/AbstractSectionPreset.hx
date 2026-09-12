package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.sections
;
    import com.sulake.core.window.IWindow;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.SectionParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SectionPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.SourceTypeSelectorPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class AbstractSectionPreset extends WiredUIPreset
    {
        var _section:SectionPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle)
        {
            super(_arg_1, _arg_2, _arg_3);
        }

        function initializeSection(_arg_1:String, _arg_2:WiredUIPreset, _arg_3:SectionParam = null)
        {
            this._section = _presetManager.createSection(_arg_1, _arg_2, _arg_3);
        }

        override public function  get_window():IWindow
        {
            return this._section.window;
        }

        public var sectionTitle(never,set):String;
public function  set_sectionTitle(_arg_1:String):String        {
            return this._section.titleText = _arg_1;
        }

        override public function resizeToWidth(_arg_1:Int)
        {
            super.resizeToWidth(_arg_1);
            this._section.resizeToWidth(_arg_1);
        }

        public var splitterVisible(never,set):Bool;
public function  set_splitterVisible(_arg_1:Bool):Bool        {
            return this._section.splitterVisible = _arg_1;
        }

        public function getSourceTypeSelector():SourceTypeSelectorPreset
        {
            return this._section.getSourceTypeSelector();
        }

        override function  get_childPresets():Array<ASAny>
        {
            return [this._section];
        }

        override public function dispose()
        {
            super.dispose();
            this._section = null;
        }
    }

