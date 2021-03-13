<template>
  <div class="databox d-flex align-center" v-if="true">
    <DataBox :items="vaccineStats" />
  </div>
</template>

<script>
import DataBox from '../DataBox.vue'
import { numberWithCommas } from '../../utils/formatting.js'

export default {
  name: 'GeneralStats',

  components: { DataBox },

  methods: {
    makeStatsBox() {
      const {vaccinesHistory, casesHistory} = this.covidData
      this.getStats(vaccinesHistory, casesHistory)
    },
    getStats(vaccinesHistory, casesHistory) {
      const daily_cumulative = vaccinesHistory[vaccinesHistory.length - 1].daily_cumulative
      const total_deaths = casesHistory[casesHistory.length - 1].death_confirmed
      const total_positive = casesHistory[casesHistory.length - 1].positive
      const at_least_one_dose = vaccinesHistory[vaccinesHistory.length - 1].one_dose_total
      const fully_immunized = vaccinesHistory[vaccinesHistory.length - 1].fully_immunized_total
      const co_population = 5763976
      const co_18_population = Math.round(co_population * (1 - .219))
      const one_dose_percent = `${Math.round(vaccinesHistory[vaccinesHistory.length - 1].one_dose_total * 1000  / co_population) / 10} %`
      const fully_immunized_percent = `${Math.round(vaccinesHistory[vaccinesHistory.length - 1].fully_immunized_total * 1000  / co_population) / 10} %`
      const fully_immunized_18_percent = `${Math.round(vaccinesHistory[vaccinesHistory.length - 1].fully_immunized_total * 1000  / co_18_population) / 10} %`
      const one_dose_18_percent = `${Math.round(vaccinesHistory[vaccinesHistory.length - 1].one_dose_total * 1000  / co_18_population) / 10} %`

      this.vaccineStats = {
        "headers": ["CO Stats"],
        "rows": [
          ["Adults with at least one dose", `${numberWithCommas(at_least_one_dose)}  ( ${one_dose_18_percent} )`],
          ["Adults fully immunized", `${numberWithCommas(fully_immunized)}  ( ${fully_immunized_18_percent} )`],
          ["Total vaccines given", numberWithCommas(daily_cumulative)],
          ["Total population", numberWithCommas(co_population)],
          ["Total population 18+", numberWithCommas(co_18_population)],
          ["Overall with at least one dose", one_dose_percent],
          ["Overall fully immunized", fully_immunized_percent],
          ["Total positive cases", numberWithCommas(total_positive)],
          ["Total deaths", numberWithCommas(total_deaths)],
        ]
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
      vaccineStats: []
    }
  }
}
</script>

<style>
</style>
