Vue.component('sentence', {
  props: ['sentence'],
  data: function () {
    return {
      object: this.sentence
    }
  },
  methods: {
    sendText: function(value) {
      let data = new FormData()
      data.append('example[sentence_id]', this.object.id)
      data.append('example[text]', value)
      data.append('example[to]', $('translation_language').val())
      data.append('_csrf_token', $('#_csrf_token').val())
      const config = { header : { 'Content-Type' : 'application/json' } }
      this.$http.post('http://localhost:4000/dashboard/examples', data, config).then(function(data) {
        this.object = data.body.sentence
      })
    }
  },
  template: `
    <div class="sentence lt-card">
      <div class="original">
        Source text - <span>{{ object.original }}</span>
      </div>
      <div class="translations">
        <translation v-for="translation in object.translations" :key="translation.id" :translation="translation" />
      </div>
      <new-translation v-on:send="sendText" />
    </div>
  `
})
