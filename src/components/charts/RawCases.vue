<template>
  <div>
    <v-btn depressed color="#e6e6ff" class="my-2" @click="toggle = !toggle">
      {{ toggle ? "Hide" : "Show" }} Raw Case Data
    </v-btn>
    <div v-show='toggle'>
      <DataTable :tableData="rawCaseStats" />
    </div>
  </div>
</template>

<script>
import DataTable from '../DataTable.vue'

export default {
  name: 'RawCases',

  components: { DataTable },

  methods: {
    makeStatsBox() {
      const { casesHistory } = this.covidData
      this.getStats(casesHistory)
    },

    getStats(casesHistory) {
      const headers = [
        { text: "Date", value: "date"},
        { text: "New Cases", value: "positiveIncrease"},
        { text: "Total Cases", value: "positive"},
        { text: "New Deaths", value: "deathIncrease"},
        { text: "Total Deaths", value: "deathConfirmed"},
        { text: "New Hospitalizations", value: "hospitalizedIncrease"},
        { text: "Current Hospitalizations", value: "hospitalizedCurrently"},
        { text: "Total Hospitalizations", value: "totalHospitalized"},
        { text: "New Tests", value: "testedIncrease"},
        { text: "Total Tested", value: "tested"},
      ]

      const items = casesHistory.reverse().map(v => {
          const data = {
            date: (v.reporting_date.slice(5) + '-' + v.reporting_date.slice(0, 4)).replaceAll("-", "/"),
            positiveIncrease: v.positive_increase,
            positive: v.positive,
            deathIncrease: v.death_increase,
            deathConfirmed: v.death_confirmed,
            hospitalizedIncrease: v.hospitalized_increase,
            hospitalizedCurrently: v.hospitalized_currently,
            totalHospitalized: v.total_hospitalized,
            tested: v.tested,
            testedIncrease: v.tested_increase,
          } 
          return data
        }
      )

      this.rawCaseStats = {
        headers,
        items,
      }
    }
  },

  props: [
    'covidData',
    'readyToChart'
  ],

  watch: {
    readyToChart: function(newVar, oldVar) {
      this.makeStatsBox()
    }
  },

  data() {
    return {
      rawCaseStats: [],
      toggle: false
    }
  }
}
</script>

<style>
#testing {
  max-width: 100%;
}
</style>
