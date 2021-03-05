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
      <v-tabs  center-active centered >
        <v-tab v-on:click="$emit('change-charts', 'overview')">Overview</v-tab>
        <v-tab v-on:click="$emit('change-charts', 'vaccines')">Vaccines</v-tab>
        <v-tab v-on:click="$emit('change-charts', 'cases')">Cases</v-tab>
        <v-tab v-on:click="$emit('change-charts', 'hospitalizations')">Hospitalizations</v-tab>
        <v-tab v-on:click="$emit('change-charts', 'deaths')">Deaths</v-tab>
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
