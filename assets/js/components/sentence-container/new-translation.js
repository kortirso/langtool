Vue.component('new-translation', {
  data: function () {
    return {
      value: ''
    }
  },
  computed: {
    changed: function() {
      return this.value !== ''
    }
  },
  methods: {
    add: function() {
      this.$emit('send', this.value)
      this.value = ''
    },
    clear: function() {
      this.value = ''
    }
  },
  template: `
    <div class="new_translation">
      <input type="text" class="form-control" placeholder="New translation" v-model="value" />
      <div class="controls" :class="{ visible: changed }">
        <span class="accept" @click.prevent="add()"></span>
        <span class="decline" @click.prevent="clear()"></span>
      </div>
    </div>
  `
})
