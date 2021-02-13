<template>
  <v-app>
    <Title />
    <Charts />
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

  data: () => ({
    //
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

</style>