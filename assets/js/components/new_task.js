import VueResource from 'vue-resource'

const extensions = {'ruby_on_rails': '.yml'}
const locales = {'en': 'English', 'ru': 'Russian', 'da': 'Danish'}

Vue.use(VueResource)

if ($('#page_index_components').length) {
  new Vue({
    el: '#new_task',
    data: {
      framework: '',
      file: null,
      fileName: null,
      from: '',
      to: '',
      error: null
    },
    computed: {
      extension: function() {
        return this.framework === '' ? '' : extensions[this.framework]
      },
      originalLanguage: function() {
        return this.from === '' ? 'Autodetection' : locales[this.from]
      },
      fileError: function() {
        return this.error !== null
      }
    },
    watch: {
      framework: function() {
        this.file = null
        this.fileName = null
        this.setError(null)
        // reset previously selected file
        $('#localization_file').val('') 
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
        const config = { headers : { 'Content-Type' : 'multipart/form-data' } }
        this.$http.post('http://localhost:4000/tasks/detection', data, config).then(function(data) {
          if (data.body.code !== undefined) {
            const locale = locales[data.body.code]
            if (locale !== undefined) {
              this.from = data.body.code
              this.error = null
            } else this.setError('Locale is not supported')
          } else this.setError(data.body.error)
        })
      },
      setError: function(error) {
        this.from = ''
        this.error = error
      },
      createTask: function() {
        let data = new FormData()
        data.append('task[file]', this.file)
        data.append('task[from]', this.from)
        data.append('task[to]', this.to)
        data.append('task[session_id]', $('#session_id').val())
        data.append('task[status]', 'created')
        data.append('_csrf_token', $('#_csrf_token').val())
        const config = { headers : { 'Content-Type' : 'multipart/form-data' } }
        this.$http.post('http://localhost:4000/tasks', data, config).then(function(data) {
          this.framework = ''
        })
      }
    }
  })
}
