"""Read-only packaging of original RoomUI resources for the isolated runtime test."""
from prepare_window_skin_candidate import prepare

if __name__ == "__main__":
    prepare("HabboRoomUICom", "room-ui", "v24", "room-ui", "infostand_asset_candidate")
