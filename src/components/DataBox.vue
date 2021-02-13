<template>
  <div class="dataTable">
    <v-simple-table class="text-left ">
        <tbody>
          <tr
            v-for="item in items"
            :key="item.description"
          >
            <td>{{ item.description }}</td>
            <td>{{ item.value }}</td>
          </tr>
        </tbody>
    </v-simple-table>
  </div>
</template>

<script>

export default {
  name: 'DataBox',
  props: ['items'],
  watch: {
    items: function(newVar, oldVar) {
      console.log("IT triggered")
      this.items = newVar
    }
  }
}
</script>

<style scoped>
li {
  list-style: none;
}
.dataTable {
  margin: 15px auto;
  border: 2px solid #E0E0E0;
  border-radius: 5px;
  max-width: 25rem;
}


</style>