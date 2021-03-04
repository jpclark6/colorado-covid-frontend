<template>
  <v-app-bar
    fixed
    color="#451010"
    dark
    app
    src="../assets/covid.jpg"
  >
    <template v-slot:img="{ props }">
      <v-img
        v-bind="props"
        gradient="to top right, rgba(5,5,5,.7), rgba(75,50,50,.7)"
      ></v-img>
    </template>
    <v-spacer></v-spacer>

    <div class="text-center text-h4 text-md-h4">Colorado COVID Data</div>
    <v-spacer></v-spacer>
   
    <template v-slot:extension>
      <v-tabs align-with-title >
        <v-tab>Overview</v-tab>
        <v-tab>Vaccines</v-tab>
        <v-tab>Cases</v-tab>
        <v-tab>Hospitalizations</v-tab>
        <v-tab>Deaths</v-tab>
      </v-tabs>
    </template>
  </v-app-bar>
</template>

<script>
export default {
  name: 'Title',
}
</script>

<style scoped>
#title {
  font-size: 1.75em !important;
  text-align: center;
}
</style>
