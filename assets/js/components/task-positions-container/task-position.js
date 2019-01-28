Vue.component('task-position', {
  props: ['task', 'position'],
  methods: {
  },
  template: `
    <div class="position lt-card">
      <div class="original">
        Source text - <span>{{ position.sentence.original }}</span>
      </div>
      <p>{{ position.result }}</p>
    </div>
  `
})
