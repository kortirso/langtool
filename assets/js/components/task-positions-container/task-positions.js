Vue.component('task-positions', {
  props: ['task'],
  data: function () {
    return {
      positions: this.task.positions
    }
  },
  methods: {
  },
  template: `
    <div class="positions">
    </div>
  `
})
