// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket} from "phoenix"

const userToken = $('#user_room_token').val()
const userSessionId = $('#user_session_id').val()

let socket = new Socket("/socket", {params: {userToken: userToken}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
if ($('#page_index_components').length) {
  let channel = socket.channel("room:" + userSessionId, {})

  channel.on("new_task", payload => {
    const taskItem = `<tr class='task' id='task_${payload.id}'><td scope='col'>${payload.id}</td><td scope='col'>${payload.file.file_name}</td><td scope='col'>${payload.from}-${payload.to}</td><td scope='col' class='status'>${payload.status}</td><td scope='col'></td></tr>`
    $("#tasks tbody").prepend(taskItem)
    const tasksCount = $("#tasks tbody tr.task").length
    if (tasksCount === 2 || tasksCount === 6) $("#tasks tbody tr")[tasksCount - 1].remove()
  })

  channel.on("complete_task", payload => {
    const taskItemStatus = $(`#task_${payload.id} td.status`)
    if (taskItemStatus.length == 1) $(taskItemStatus[0]).html(payload.status)
  })

  channel.join()
    .receive("ok", resp => { console.log("Joined successfully", resp) })
    .receive("error", resp => { console.log("Unable to join", resp) })
}

export default socket
