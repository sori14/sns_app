module RoomHelper
  def room_name(room)
    if room.user_id == current_user.id
      User.find(room.other_user_id).name
    else
      User.find(room.user_id).name
    end
  end

  def room(current_user,other_user)
    room = Room.where(user_id: current_user.id, other_user_id: other_user.id)
    unless room
      room = Room.where(user_id: other_user.id, other_user_id: current_user.id)
    end
    return room
  end
end
