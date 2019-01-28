Vue.component('task-position', {
  props: ['task', 'position'],
  data: function () {
    return {
      object: this.position,
      sentence: this.position.sentence,
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
        this.$http.get(`http://localhost:4000/api/v1/sentences/${this.sentence.id}/translations/${this.task.to}`, config).then(function(data) {
          this.translations = data.body.translations
        })
      }
      this.isVisible = !this.isVisible
    },
    changeTranslation: function(value) {
      const data = { position: { result: value } }
      const config = { headers : { 'Authorization' : $('#access_token').val() } }
      this.$http.patch(`http://localhost:4000/api/v1/positions/${this.object.id}`, data, config).then(function(data) {
        this.object = data.body.position
      })
    }
  },
  template: `
    <div class="position lt-card">
      <div class="original">
        Source text - <span>{{ sentence.original }}</span>
      </div>
      <div class="original">
        Current translation - <span>{{ object.result }}</span>
      </div>
      <div class="translation_options" :class="{ visible: isVisible }">
        <position-translation v-for="translation in translations" v-on:send="changeTranslation" :translation="translation" :key="translation.id" />
      </div>
      <button class="btn btn-outline-primary btn-sm" @click.prevent="toggleOptions()">{{ buttonText }}</button>
    </div>
  `
})
