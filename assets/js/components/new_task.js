import VueResource from 'vue-resource'

Vue.use(VueResource)

new Vue({
  el: '#new_task',
  data: {
    extensions: {'ruby_on_rails': '.yml'},
    extension: '',
    framework: '',
    file: null,
    fileName: null,
    from: '',
    to: ''
  },
  methods: {
    changeFramework: function(event) {
      this.extension = this.extensions[this.framework]
      this.file = null
      this.fileName = null
      this.from = ''
      this.to = ''
    },
    uploadFile: function(event) {
      this.file = event.target.files[0]
      this.fileName = "Selected: " + event.target.files[0].name
      this.from = ''
      this.to = ''
    },
    createTask: function() {
      let data = new FormData()
      data.append('task[file]', this.file)
      data.append('task[from]', this.from)
      data.append('task[to]', this.to)
      data.append('task[user_session_id]', $('#user_session_id').val())
      data.append('task[status]', 'created')
      data.append('_csrf_token', $('#_csrf_token').val())
      const config = { header : { 'Content-Type' : 'multipart/form-data' } }
      this.$http.post('http://localhost:4000/tasks', data, config).then(function(data) {
        console.log(data)
      })
    }
  }
})