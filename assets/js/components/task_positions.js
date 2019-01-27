import VueResource from 'vue-resource'

Vue.use(VueResource)

if ($('#task_positions').length) {
  new Vue({
    el: '#task_positions',
    data: {
      positions: []
    },
    created: function() {
      this.getPositions($('#task_id').val())
    },
    methods: {
      getPositions: function(taskId) {
        this.$http.get(`http://localhost:4000/api/v1/tasks/${taskId}`).then(function(data) {
          this.positions = data.body.positions
        })
      }
    }
  })
}
