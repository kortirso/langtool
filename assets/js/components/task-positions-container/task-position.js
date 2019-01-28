Vue.component('task-position', {
  props: ['task', 'position'],
  data: function () {
    return {
      translations: [],
      isVisible: false
    }
  },
  computed: {
    buttonText: function() {
      return this.isVisible ? "Hide translation options" : "Show translation options"
    }
  },
  methods: {
    toggleOptions: function() {
      if (this.translations.length === 0) {
        const config = { headers : { 'Authorization' : $('#access_token').val() } }
        this.$http.get(`http://localhost:4000/api/v1/sentences/${this.position.sentence.id}/translations/${this.task.to}`, config).then(function(data) {
          this.translations = data.body.translations
        })
      }
      this.isVisible = !this.isVisible
    }
  },
  template: `
    <div class="position lt-card">
      <div class="original">
        Source text - <span>{{ position.sentence.original }}</span>
      </div>
      <div class="original">
        Current translation - <span>{{ position.result }}</span>
      </div>
      <div class="translation_options" :class="{ visible: isVisible }">
        <position-translation v-for="translation in translations" :key="translation.id" :translation="translation" />
      </div>
      <button class="btn btn-outline-primary btn-sm" @click.prevent="toggleOptions()">{{ buttonText }}</button>
    </div>
  `
})
