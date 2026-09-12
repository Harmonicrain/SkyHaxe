package org.openvideoads.vast.playlist.smil
;
    import org.openvideoads.vast.playlist.DefaultPlaylist;
    import org.openvideoads.vast.schedule.StreamSequence;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;

     class SMILPlaylist extends DefaultPlaylist 
    {
        public function new(k:StreamSequence=null, _arg_2:ProvidersConfigGroup=null, _arg_3:ProvidersConfigGroup=null)
        {
            super(k, _arg_2, _arg_3);
        }

        override public function loadFromString(k:String)
        {
            var _local_2= new com.sulake.core.utils.xml.XML(k);
            _Str_21786(new _Str_11061(_local_2.children().at(0).children().at(0).attribute("base").toString(), _local_2.children().at(1).children().at(0).attribute("src").toString()));
        }

        override public function getModel():Array<ASAny>
        {
            return new Array<ASAny>();
        }

        override public function toString(k:Bool=false):String
        {
            return "";
        }
    }

