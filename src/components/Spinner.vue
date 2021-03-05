<template>
  <div v-show="!trigger">
      <v-progress-circular
        indeterminate
        color="primary"
        :size="70"
        :width="7"
      ></v-progress-circular>
      <div>Loading data</div>
    </div>
</template>

<script>
export default {
  name: 'Spiner'
}
</script>