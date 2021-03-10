<template>
  <div class="databox d-flex align-center" v-if="true">
    <DataBox :items="rawVaccineStats" id="testing"/>
  </div>
</template>

<script>
import DataBox from '../DataBox.vue'
import { numberWithCommas } from '../../utils/formatting.js'

export default {
  name: 'RawVaccines',

  components: { DataBox },

  methods: {
    makeStatsBox() {
      const {vaccinesHistory} = this.covidData
      this.getStats(vaccinesHistory)
    },
    getStats(vaccinesHistory) {
      const headers = [
        "Cumulative Total",
        "Daily J&J",
        "Daily Moderna",
        "Daily Pfizer",
        "Daily Qty",
        "Distributed Increase",
        "Distributed Cumulative",
        "Daily Fully Immunized",
        "Cumulative Fully Immunized",
        "Cumulative J&J",
        "Cumulative Moderna",
        "Daily One Dose Increase",
        "Cumulative One Dose",
        "Cumulative Pfizer",
        "Date",
        "Total Providers"
      ]

      const vaccines = vaccinesHistory.reverse().map(v => [
        (v.reporting_date.slice(5) + '-' + v.reporting_date.slice(0, 4)).replaceAll("-", "/"),
        v.daily_cumulative,
        v.daily_jandj  ,
        v.daily_moderna  ,
        v.daily_pfizer  ,
        v.daily_qty,
        v.distributed_increase,
        v.distrubuted_total,
        v.fully_immunized_increase,
        v.fully_immunized_total,
        v.jandj_total,
        v.moderna_total,
        v.one_dose_increase,
        v.one_dose_total,
        v.pfizer_total,
        v.reporting_date,
        v.total_vaccine_providers
      ])


      this.rawVaccineStats = {
        "headers": headers,
        "rows": vaccines
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
      rawVaccineStats: []
    }
  }
}
</script>

<style>
#testing {
  max-width: 100%;
}
</style>
