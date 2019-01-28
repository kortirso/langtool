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
        const config = { headers : { 'Authorization' : $('#access_token').val() } }
        this.$http.get(`http://localhost:4000/api/v1/tasks/${taskId}`, config).then(function(data) {
          this.positions = data.body.positions
        })
      }
    }
  })
}
