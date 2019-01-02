import VueResource from 'vue-resource'

Vue.use(VueResource)

if ($('#new_user').length) {
  new Vue({
    el: '#new_user',
    data: {
      email: '',
      password: '',
      passwordConfirmation: '',
      errors: null
    },
    computed: {
      validEmail: function() {
        const regExp = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/
        return this.email !== '' && regExp.test(this.email)
      },
      validPassword: function() {
        return this.password.length >= 10
      },
      equalPasswords: function() {
        return this.password === this.passwordConfirmation
      },
      emailError: function() {
        if (this.errors === null) return ''
        else {
          const errors = this.errors.filter(function(error) {
            return error.email !== undefined
          })
          if (errors.length > 0) return `Email ${errors[0].email}`
          else return ''
        }
      }
    },
    methods: {
      createUser: function() {
        const params = { user: { email: this.email, encrypted_password: this.password }, _csrf_token: $('#_csrf_token').val() }
        this.$http.post('http://localhost:4000/registrations', params, {}).then(function(response) {
          if (response.status === 200) this.errors = response.body
          else window.location = "./complete"
        })
      }
    }
  })
}
