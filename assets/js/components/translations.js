import VueResource from 'vue-resource'

Vue.use(VueResource)

if ($('#translations').length) {
  new Vue({
    el: '#translations',
    data: {
      from: '',
      to: '',
      sentences: []
    },
    methods: {
      createFilter: function() {
        const config = { headers : { 'Authorization' : $('#access_token').val() } }
        this.$http.get(`http://localhost:4000/api/v1/sentences?from=${this.from}&to=${this.to}`, config).then(function(data) {
          this.sentences = data.body.sentences
        })
      }
    }
  })
}
