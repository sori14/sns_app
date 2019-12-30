module RoomHelper
  def room_name(room)
    if room.user_id == current_user.id
      User.find(room.other_user_id).name
    else
      User.find(room.user_id).name
    end
  end
end
