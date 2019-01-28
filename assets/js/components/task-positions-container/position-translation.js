Vue.component('position-translation', {
  props: ['translation'],
  data: function () {
    return {
    }
  },
  computed: {
  },
  methods: {
    accept: function() {
      this.$emit('send', this.translation.text)
    }
  },
  template: `
    <div class="translation">
      <img :src="translation.editor" />
      <span class="value">{{ translation.text }}</span>
      <div class="controls">
        <span class="accept" @click.prevent="accept"></span>
        <span class="plus"></span>
        <span class="minus"></span>
      </div>
    </div>
  `
})
