import VueResource from 'vue-resource'

const locales = {'en': 'English', 'ru': 'Russian', 'da': 'Danish'}

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
        this.$http.get(`http://localhost:4000/dashboard/sentences?from=${this.from}&to=${this.to}`).then(function(data) {
          this.sentences = data.body.sentences
        })
      }
    }
  })
}
