Vue.component('translation', {
  props: ['translation'],
  data: function () {
    return {
      object: this.translation,
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
      const config = { header : { 'Content-Type' : 'application/json' } }
      this.$http.patch(`http://localhost:4000/dashboard/translations/${this.object.id}`, { translation: { text: this.currentValue } }, config).then(function(data) {
        console.log(data)
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
