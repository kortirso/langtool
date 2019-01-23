Vue.component('sentence', {
  props: ['sentence'],
  data: function () {
    return {
      object: this.sentence,
      translations: this.sentence.translations
    }
  },
  methods: {
    sendText: function(value, reverse) {
      let data = new FormData()
      data.append('example[sentence_id]', this.object.id)
      data.append('example[text]', value)
      data.append('example[to]', $('#translation_language').val())
      data.append('reverse', reverse)
      data.append('_csrf_token', $('#_csrf_token').val())
      const config = { header : { 'Content-Type' : 'application/json' } }
      this.$http.post('http://localhost:4000/dashboard/examples', data, config).then(function(data) {
        let translations = this.translations
        translations.push(data.body.translation)
        this.translations = translations
      })
    }
  },
  template: `
    <div class="sentence lt-card">
      <div class="original">
        Source text - <span>{{ object.original }}</span>
      </div>
      <div class="options">
        <div class="translations">
          <translation v-for="translation in translations" :key="translation.id" :translation="translation" />
        </div>
        <new-translation v-on:send="sendText" />
      </div>
    </div>
  `
})
