Vue.component('new-translation', {
  data: function () {
    return {
      value: '',
      reverse: false
    }
  },
  computed: {
    changed: function() {
      return this.value !== ''
    }
  },
  methods: {
    add: function() {
      this.$emit('send', this.value, this.reverse)
      this.value = ''
      this.reverse = false
    },
    clear: function() {
      this.value = ''
      this.reverse = false
    }
  },
  template: `
    <div class="new_translation">
      <div class="new_translation_form">
        <input type="text" class="form-control" placeholder="New translation" v-model="value" />
        <div class="controls" :class="{ visible: changed }">
          <span class="accept" @click.prevent="add()"></span>
          <span class="decline" @click.prevent="clear()"></span>
        </div>
      </div>
      <div class="reverse" :class="{ visible: changed }">
        <input type="checkbox" v-model="reverse" />
        <label>Create reverse translation</label>
      </div>
    </div>
  `
})
