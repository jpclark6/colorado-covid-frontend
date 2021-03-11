<template>
  <v-app>
    <Title v-on:change-charts="changeCharts" />
    <v-main>
      <Charts class="mt-5" :shownCharts="currentCharts" id="all-charts"/>
    </v-main>
  </v-app>
</template>

<script>
import Title from './components/Title.vue'
import Charts from './components/Charts.vue'

export default {
  name: 'App',

  components: {
    Title,
    Charts
  },

  methods: {
    changeCharts(shownCharts) {
      this.currentCharts = shownCharts
      window.scrollTo(0,0)
    }
  },

  data: () => ({
    currentCharts: "overview"
  }),
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  /* text-align: center;
  margin-top: 60px; */
  color: #2c3e50;
}
@media (min-width: 800px) {
  #all-charts {
    max-width: 90%;
    margin: auto;
  }
}

</style>