class RoomsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_#{params[:room_id]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(date)
    message = Message.create!(content: date['message'], room_id: date['room_id'], user_id: date['user_id'])
    template = ApplicationController.renderer.render(partial: 'messages/message', locals: {message: message})
    ActionCable.server.broadcast "room_#{params[:room_id]}_channel", template
  end
end
