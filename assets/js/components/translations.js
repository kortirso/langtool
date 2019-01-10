import VueResource from 'vue-resource'

const locales = {'en': 'English', 'ru': 'Russian', 'da': 'Danish'}

Vue.use(VueResource)

if ($('#translations').length) {
  new Vue({
    el: '#translations',
    data: {
      from: '',
      to: ''
    },
    methods: {
      createFilter: function() {
        this.$http.get('http://localhost:4000/dashboard/sentences').then(function(data) {
          console.log(data)
        })
      }
    }
  })
}
