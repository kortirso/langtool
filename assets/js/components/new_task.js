import VueResource from 'vue-resource'

Vue.use(VueResource)

new Vue({
  el: '#new_task',
  data: {
    extensions: {'ruby_on_rails': '.yml'},
    locales: {'en': 'English', 'ru': 'Russian', 'da': 'Danish'},
    framework: '',
    file: null,
    fileName: null,
    from: {code: '', name: ''},
    to: ''
  },
  computed: {
    extension: function() {
      return this.framework === '' ? '' : this.extensions[this.framework]
    },
    original_language: function() {
      return this.from.name === '' ? 'Autodetection' : this.from.name
    }
  },
  watch: {
    framework: function() {
      this.file = null
      this.fileName = null
      this.from = {code: '', name: ''}
    },
    file: function() {
      this.to = ''
    }
  },
  methods: {
    uploadFile: function(event) {
      // update file
      this.file = event.target.files[0]
      this.fileName = "Selected: " + event.target.files[0].name
      // send file for locale autodetection
      let data = new FormData()
      data.append('file', this.file)
      data.append('_csrf_token', $('#_csrf_token').val())
      const config = { header : { 'Content-Type' : 'multipart/form-data' } }
      this.$http.post('http://localhost:4000/tasks/detection', data, config).then(function(data) {
        if (data.body.code !== undefined) {
          const locale = this.locales[data.body.code]
          if (locale !== undefined) this.from = {code: data.body.code, name: locale}
          else this.from = {code: '', name: 'Locale is not supported'}
        } else this.from = {code: '', name: data.body.error}
      })
    },
    createTask: function() {
      let data = new FormData()
      data.append('task[file]', this.file)
      data.append('task[from]', this.from.code)
      data.append('task[to]', this.to)
      data.append('task[user_session_id]', $('#user_session_id').val())
      data.append('task[status]', 'created')
      data.append('_csrf_token', $('#_csrf_token').val())
      const config = { header : { 'Content-Type' : 'multipart/form-data' } }
      this.$http.post('http://localhost:4000/tasks', data, config).then(function(data) {
        this.framework = ''
      })
    }
  }
})