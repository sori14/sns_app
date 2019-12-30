App.room = App.cable.subscriptions.create("RoomsChannel", {
    connected: function () {
        // Called when the subscription is ready for use on the server
    },

    disconnected: function () {
        // Called when the subscription has been terminated by the server
    },

    received: function (template) {
        const messages = document.getElementById('messages')
        messages.innerHTML += template
    },

    speak: function (content, room_id, user_id) {
        // RoomChannelのspeakメソッドを呼び出す。
        return this.perform('speak', {message: content, room_id: room_id, user_id: user_id});
    }

});

document.addEventListener('DOMContentLoaded', function () {
    const messages = document.getElementById('messages')
    const input = document.getElementById('message_content')
    const button = document.getElementById('button')
    button.addEventListener('click', function () {
        const content = input.value
        const room_id = messages.getAttribute('room_id')
        const user_id = messages.getAttribute('user_id')
        // room.jsのspeakメソッドを用いる
        App.room.speak(content, room_id, user_id)
        input.value = ''
    })
})
