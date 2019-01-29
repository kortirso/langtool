Vue.component('position-translation', {
  props: ['translation'],
  data: function () {
    return {
      total_rating: this.translation.total_rating,
      rated: this.translation.rated
    }
  },
  computed: {
    rating: function() {
      if (this.total_rating > 0) return "+" + this.total_rating
      else return this.total_rating
    }
  },
  methods: {
    accept: function() {
      this.$emit('send', this.translation.text)
    },
    changeRating: function(value) {
      const data = { rating: { translation_id: this.translation.id, value: value } }
      const config = { headers : { 'Authorization' : $('#access_token').val() } }
      this.$http.post(`/api/v1/ratings`, data, config).then(function(data) {
        this.total_rating += data.body.translation.total_rating
        this.rated = true
      })
    }
  },
  template: `
    <div class="translation">
      <img :src="translation.editor" />
      <span class="value">{{ translation.text }}</span>
      <div class="controls">
        <span class="pushed accept" @click.prevent="accept"></span>
        <span class="rating">Rating {{ rating }}</span>
        <span class="pushed plus" @click.prevent="changeRating(1)" :class="{ hidden: rated }">+</span>
        <span class="pushed minus" @click.prevent="changeRating(-1)" :class="{ hidden: rated }">-</span>
      </div>
    </div>
  `
})
