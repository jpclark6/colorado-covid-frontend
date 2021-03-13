<template>
  <div>
    <v-btn depressed color="#e6e6ff" class="my-2" @click="toggle = !toggle">
      {{ toggle ? "Hide" : "Show" }} Raw Vaccine Data
    </v-btn>
    <div v-show='toggle'>
      <DataTable :tableData="rawVaccineStats" />
    </div>
  </div>
</template>

<script>
import DataTable from '../DataTable.vue'

export default {
  name: 'RawVaccines',

  components: { DataTable },

  methods: {
    makeStatsBox() {
      const { vaccinesHistory } = this.covidData
      this.getStats(vaccinesHistory)
    },

    getStats(vaccinesHistory) {
      const headers = [
        { text: "Date", value: "date"},
        { text: "Daily Qty", value: "dailyQty"},
        { text: "Cumulative Total", value: "cumulativeTotal"},
        { text: "Daily One Dose Increase", value: "dailyOneDose"},
        { text: "Daily Fully Immunized", value: "dailyFullyImmunized"},
        { text: "Daily J&J", value: "dailyJandJ"},
        { text: "Daily Moderna", value: "dailyModerna"},
        { text: "Daily Pfizer", value: "dailyPfizer"},
        { text: "Cumulative Fully Immunized", value: "cumulativeFullyImmunized"},
        { text: "Cumulative J&J", value: "cumulativeJandJ"},
        { text: "Cumulative Moderna", value: "cumulativeModerna"},
        { text: "Cumulative Pfizer", value: "cumulativePfizer"},
        { text: "Cumulative One Dose", value: "cumulativeOneDose"},
        { text: "Distributed Increase", value: "distributedIncrease"},
        { text: "Distributed Cumulative", value: "distributedCumulative"},
        { text: "Total Providers", value: "totalProviders"},
      ]

      const items = vaccinesHistory.reverse().map(v => {
          const data = {
            date: (v.reporting_date.slice(5) + '-' + v.reporting_date.slice(0, 4)).replaceAll("-", "/"),
            dailyQty: v.daily_qty,
            cumulativeTotal: v.daily_cumulative,
            dailyOneDose: v.one_dose_increase,
            dailyFullyImmunized: v.fully_immunized_increase,
            dailyJandJ: v.daily_jandj,
            dailyModerna: v.daily_moderna,
            dailyPfizer: v.daily_pfizer,
            cumulativeFullyImmunized: v.fully_immunized_total,
            cumulativeJandJ: v.jandj_total,
            cumulativeModerna: v.moderna_total,
            cumulativePfizer: v.pfizer_total,
            cumulativeOneDose: v.one_dose_total,
            distributedIncrease: v.distributed_increase,
            distributedCumulative: v.distrubuted_total,
            totalProviders: v.total_vaccine_providers,
          } 
          return data
        }
      )

      this.rawVaccineStats = {
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
      rawVaccineStats: [],
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
