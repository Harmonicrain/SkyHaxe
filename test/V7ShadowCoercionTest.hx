import com.sulake.habbo.room.object.RoomObjectVariableEnum;
import com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization;
import com.sulake.room.object.RoomObjectModel;
import com.sulake.room.object.visualization.RoomObjectSprite;

@:access(com.sulake.habbo.room.object.visualization.furniture.FurnitureVisualization)
class V7ShadowCoercionTest {
    static function main() {
        var model = new RoomObjectModel();
        var missing = model.getNumber(RoomObjectVariableEnum.FURNITURE_LIFT_AMOUNT);
        if (!Math.isNaN(missing)) throw "Absent model value must remain NaN";
        var visualization = new FurnitureVisualization();
        visualization._Str_13574 = 0;
        visualization.Z_MULTIPLIER = missing;
        var sprite = new RoomObjectSprite();
        for (scale in [32, 64]) {
            sprite.offsetY = -8 + visualization.getSpriteYOffset(scale, 0, 0);
            if (sprite.offsetY != -8) throw 'Shadow offset corrupted at scale $scale';
        }
        visualization.Z_MULTIPLIER = 0.1;
        if (visualization.getSpriteYOffset(64, 0, 0) != 4)
            throw "Normal lift must still round upward";
        trace("V7_SHADOW_COERCION_PASS actual-generated-visualization model-NaN sprite-offset scales32+64");
    }
}
