package com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.main_layout
;
    import com.sulake.habbo.roomevents.HabboUserDefinedRoomEvents;
    import com.sulake.habbo.roomevents.wired_setup.IWiredTypeHolder;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.PresetManager;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.params.TextParam;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.TextPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.presets.WiredUIPreset;
    import com.sulake.habbo.roomevents.wired_setup.uibuilder.styles.WiredStyle;

     class IlluminaHeaderPreset extends HeaderPreset
    {
        var _name1Preset:TextPreset;
        var _name2Preset:TextPreset;

        public function new(_arg_1:HabboUserDefinedRoomEvents, _arg_2:PresetManager, _arg_3:WiredStyle, _arg_4:String, _arg_5:IWiredTypeHolder, _arg_6:Int, _arg_7:ASFunction, _arg_8:ASFunction, _arg_9:ASFunction)
        {
            super(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7, _arg_8, _arg_9);
        }

        override function createTopHeaderElement(_arg_1:String, _arg_2:IWiredTypeHolder):WiredUIPreset
        {
            var _local_5= this.getNameParts(_arg_1);
            var _local_3= new TextParam(1, true);
            _local_3.fontSize = 11;
            this._name1Preset = _presetManager.createText(_local_5[0], _local_3);
            _local_3 = new TextParam(1, true);
            _local_3.fontSize = _style.headerNameFontSize;
            _local_3.textColor = 0x494949;
            this._name2Preset = _presetManager.createText(_local_5[1], _local_3);
            var _local_4= _presetManager.createSimpleListView(true, [_presetManager.createSpacing(true, 3), this._name1Preset, this._name2Preset]);
            _local_4.spacing = -2;
            _local_4.window.x = 3;
            return _local_4;
        }

        function getNameParts(_arg_1:String):Array<ASAny>
        {
            var _local_2:Array<ASAny> = (cast ASCompat.stringSplit(_arg_1, ":", 2));
            while (_local_2.length < 2)
            {
                _local_2.push("");
            }
            while (_local_2[1].indexOf(" ") == 0)
            {
                _local_2[1] = _local_2[1].substring(1);
            }
            _local_2[0] = _local_2[0].toUpperCase();
            return _local_2;
        }

        override public function updateName(_arg_1:String)
        {
            var _local_2= this.getNameParts(_arg_1);
            this._name1Preset.text = _local_2[0];
            this._name2Preset.text = _local_2[1];
            resizeToWidth(_width);
        }

        override public function dispose()
        {
            super.dispose();
            this._name1Preset = null;
            this._name2Preset = null;
        }
    }

