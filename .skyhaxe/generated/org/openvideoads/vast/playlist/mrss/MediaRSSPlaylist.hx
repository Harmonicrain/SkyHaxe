package org.openvideoads.vast.playlist.mrss
;
    import org.openvideoads.vast.playlist.DefaultPlaylist;
    import org.openvideoads.vast.schedule.StreamSequence;
    import org.openvideoads.vast.config.groupings.ProvidersConfigGroup;
    import org.openvideoads.util.Timestamp;
    import org.openvideoads.vast.playlist._Str_3480;

     class MediaRSSPlaylist extends DefaultPlaylist 
    {
        var _Str_1858:String = "Not available";
        var _title:String = "";
        var _Str_1676:String = "Not available";

        public function new(k:StreamSequence=null, _arg_2:ProvidersConfigGroup=null, _arg_3:ProvidersConfigGroup=null)
        {
            super(k, _arg_2, _arg_3);
        }

        override public function loadFromString(k:String)
        {
            var _local_4 = 0;
            var _local_5:com.sulake.core.utils.xml.XML = null;
            var _local_6:_Str_5739 = null;
            var _local_2= "http://search.yahoo.com/mrss/";
            com.sulake.core.utils.xml.XML.ignoreWhitespace = true;
            var _local_3= new com.sulake.core.utils.xml.XML(k);
            if (_local_3.length() > 0)
            {
                if (_local_3.child("channel").child("description" )!= null)
                {
                    this._Str_1858 = ASCompat.xmlListToString(_local_3.child("channel").child("description").text());
                }
                if (_local_3.child("channel").child("title" )!= null)
                {
                    this._title = ASCompat.xmlListToString(_local_3.child("channel").child("title").text());
                }
                if (_local_3.child("channel").child("link" )!= null)
                {
                    this._Str_1676 = ASCompat.xmlListToString(_local_3.child("channel").child("link").text());
                }
                _local_4 = 0;
                while (_local_4 < _local_3.child("channel").child("item").length())
                {
                    _local_5 = _local_3.child("channel").child("item").at(_local_4);
                    _local_6 = new _Str_5739();
                    _local_6.description = ASCompat.xmlListToString(_local_5.child("description"));
                    _local_6.guid = ASCompat.xmlListToString(_local_5.child("guid"));
                    _local_6.link = ASCompat.xmlListToString(_local_5.child("link"));
                    _local_6._Str_20606 = ASCompat.xmlListToString(_local_5.child("pubDate"));
                    _local_6.url = ASCompat.toString(_local_5.childByNamespace(_local_2, "content").attribute("url"));
                    _local_6.mimeType = ASCompat.toString(_local_5.childByNamespace(_local_2, "content").attribute("type"));
                    _local_6.filename = _local_5.childByNamespace(_local_2, "title").toString();
                    _local_6.duration = Timestamp._Str_4110(ASCompat.toNumber(ASCompat.toString(_local_5.childByNamespace(_local_2, "content").attribute("duration"))));
                    _Str_2519.push(_local_6);
                    _local_4++;
                }
            }
        }

        override public function newPlaylistItem():_Str_3480
        {
            return new _Str_5739();
        }

        override public function getModel():Array<ASAny>
        {
            return new Array<ASAny>();
        }

        override public function toString(k:Bool=false):String
        {
            var _local_2= "";
            _local_2 = (_local_2 + '<rss version="2.0" xmlns:media="http://search.yahoo.com/mrss/">');
            _local_2 = (_local_2 + "<channel>");
            _local_2 = (_local_2 + (("<description>" + this._Str_1858) + "</description>"));
            _local_2 = (_local_2 + (("<title>" + this._title) + "</title>"));
            _local_2 = (_local_2 + (("<link>" + this._Str_1676) + "</link>"));
            var _local_3 = 0;
            while (_local_3 < _Str_2519.length)
            {
                _local_2 = (_local_2 + _Str_2519[_local_3].toString(k));
                _local_3++;
            }
            _local_2 = (_local_2 + "</channel>");
            _local_2 = (_local_2 + "</rss>");
            return _local_2;
        }
    }

