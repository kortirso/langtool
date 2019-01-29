Vue.component('position-translation', {
  props: ['translation'],
  data: function () {
    return {
      total_rating: this.translation.total_rating
    }
  },
  computed: {
  },
  methods: {
    accept: function() {
      this.$emit('send', this.translation.text)
    },
    changeRating: function(value) {
      const data = { rating: { translation_id: this.translation.id, value: value } }
      const config = { headers : { 'Authorization' : $('#access_token').val() } }
      this.$http.post(`/api/v1/ratings`, data, config).then(function(data) {
        console.log(data)
        this.total_rating += data.body.translation.total_rating
      })
    }
  },
  template: `
    <div class="translation">
      <img :src="translation.editor" />
      <span class="value">{{ translation.text }}</span>
      <div class="controls">
        <span class="pushed accept" @click.prevent="accept"></span>
        <span class="pushed plus" @click.prevent="changeRating(1)">+</span>
        <span class="rating">{{ total_rating }}</span>
        <span class="pushed minus" @click.prevent="changeRating(-1)">-</span>
      </div>
    </div>
  `
})
