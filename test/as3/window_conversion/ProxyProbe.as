package window_conversion {
    import com.sulake.core.window.utils.IIterator;
    public class ProxyProbe implements IIterator {
        public var privateData:String = "must not enumerate this";
        private var stored:*;
        public function getProperty(key:*):* { return stored; }
        public function setProperty(key:*, value:*):void { stored = value; }
        public function get length():uint { return 2; }
        public function indexOf(value:*):int { return -1; }
        public function nextNameIndex(index:int):int { return index == 0 ? 3 : (index == 3 ? 9 : 0); }
        public function nextValue(index:int):* { return index == 3 ? "A" : "B"; }
    }
}
