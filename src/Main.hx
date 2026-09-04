package;

import com.sulake.habbo.communication.demo.HabboCommunicationDemo;
import openfl.display.Sprite;

class Main extends Sprite {
    public function new() {
        super();
        addChild(new HabboCommunicationDemo());
    }
}
