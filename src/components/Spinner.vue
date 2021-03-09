<template>
  <div>
      <v-progress-circular
        indeterminate
        color="primary"
        :size="70"
        :width="7"
      ></v-progress-circular>
      <div><b>Fetching the numbers</b></div>
    </div>
</template>

<script>
export default {
  name: 'Spiner'
}
</script>