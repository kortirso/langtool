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
    changeFramework: function() {
      this.extension = this.extensions[this.framework]
    },
    uploadFile: function(event) {
      this.file = event.target.files[0]
      this.fileName = "Selected: " + event.target.files[0].name
    }
  }
})