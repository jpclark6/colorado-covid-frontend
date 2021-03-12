<template>
  <div>
    <v-data-table
      :headers="headers"
      :items="items"
      :items-per-page="5"
      class="data-table"
    ></v-data-table>
    <p class="mt-4">*Some stats are delayed a day or two from the government data so out of place numbers on the latest dates should be taken with a grain of salt</p>
  </div>
</template>

<script>

export default {
  name: 'DataTable',
  props: ['tableData'],
  watch: {
    tableData: function(newVar, oldVar) {
      this.headers = newVar.headers
      this.items = newVar.items
    }
  },
  data () {
    return {
      headers: [],
      items: []
    }
  }
}
</script>

<style scoped>
li {
  list-style: none;
}
.data-table {
  margin: 15px auto;
  border: 2px solid #E0E0E0;
  border-radius: 5px;
  padding: .5em;
}
</style>