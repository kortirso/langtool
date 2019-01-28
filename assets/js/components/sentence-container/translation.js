Vue.component('translation', {
  props: ['translation'],
  data: function () {
    return {
      initialValue: this.translation.text,
      currentValue: this.translation.text
    }
  },
  computed: {
    changed: function() {
      return this.initialValue !== this.currentValue
    }
  },
  methods: {
    accept: function() {
      let data = new FormData()
      data.append('translation[text]', this.currentValue)
      data.append('_csrf_token', $('#_csrf_token').val())
      const config = { header : { 'Content-Type' : 'application/json' } }
      this.$http.patch(`http://localhost:4000/dashboard/translations/${this.translation.id}`, data, config).then(function(data) {
        this.initialValue = data.body.text
        this.currentValue = data.body.text
      })
    },
    decline: function() {
      this.currentValue = this.initialValue
    }
  },
  template: `
    <div class="translation">
      <img src="/images/yandex.png" />
      <input type="text" class="form-control" v-model="currentValue" />
      <div class="controls" :class="{ visible: changed }">
        <span class="accept" @click.prevent="accept()"></span>
        <span class="decline" @click.prevent="decline()"></span>
      </div>
    </div>
  `
})
