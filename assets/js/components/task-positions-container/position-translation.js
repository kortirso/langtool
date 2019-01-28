Vue.component('position-translation', {
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
  },
  template: `
    <div class="translation">
      <img src="/images/yandex.png" />
      <input type="text" class="form-control" v-model="currentValue" />
      <div class="controls">
        <span class="accept visible"></span>
        <span class="plus" :class="{ visible: changed }"></span>
        <span class="minus" :class="{ visible: changed }"></span>
      </div>
    </div>
  `
})
