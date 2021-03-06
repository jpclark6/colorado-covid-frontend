<template>
  <div class="text-center">
    <Spinner v-show="!trigger" />

    <p class="m-3"> Data updated daily in the evening. Additional charts coming soon.</p>

    <div class="d-flex justify-center  flex-wrap align-center" v-show="trigger" id="flex-wrapper">
      <div class="mx-5" v-show="trigger && showChart(shownCharts, 'caseStats')">
        <DataBox :items="casesData" />
        <p class="text-caption text-left px-8">*Last updated {{ lastCasesUpdate }}</p>
      </div>

      <div class="mx-5" v-show="trigger && showChart(shownCharts, 'vaccineStats')">
        <DataBox :items="vaccinesData" />
        <p class="text-caption text-left px-8">*Last updated {{ lastVaccinesUpdate }}</p>
      </div>

      <div v-show="trigger && showChart(shownCharts, 'vaccinePie')" >
        <VaccinePie class="mb-8 mt-4" :readyToChart="trigger" :covidData="covidData"/>
      </div>

      <div v-show="trigger && showChart(shownCharts, 'generalStats')">
        <GeneralStats class="mb-8 mt-4" :readyToChart="trigger" :covidData="covidData"/>
      </div>
    </div>

    <Vaccines v-show="trigger && showChart(shownCharts, 'vaccinesChart')" class="mb-8" :readyToChart="trigger" :covidData="covidData"/>
    <Cases v-show="trigger && showChart(shownCharts, 'casesChart')" class="mb-8" :readyToChart="trigger" :covidData="covidData"/>
    <Deaths v-show="trigger && showChart(shownCharts, 'deathsChart')" class="mb-8" :readyToChart="trigger" :covidData="covidData"/>
    <Hospitalized v-show="trigger && showChart(shownCharts, 'hospitalizedChart')" class="mb-8" :readyToChart="trigger" :covidData="covidData"/>

    <p class="mx-6">*Data is updated daily in the evening as soon as it's available from the government APIs, usually around 6PM MST.
       Data on this site is not guaranteed to be accurate. See the sources directly for the official numbers.
    </p>
    <p class="mb-1 mx-5 text-left">Sources:</p>
    <p class="my-1 mx-2 text-left">Cases - <a href="https://opendata.arcgis.com/datasets/566216cf203e400f8cbf2e6b4354bc57_0.geojson">API</a> from <a href="https://data-cdphe.opendata.arcgis.com/search?tags=covid19">CDPHE Open Data</a> from <a href="https://covid19.colorado.gov/data">https://covid19.colorado.gov/data</a></p>
    <p class="my-1 mx-2 text-left">Vaccines - <a href="https://opendata.arcgis.com/datasets/a681d9e9f61144b2977badb89149198c_0.geojson">API</a> from <a href="https://data-cdphe.opendata.arcgis.com/search?tags=covid19">CDPHE Open Data</a> from <a href="https://covid19.colorado.gov/vaccine-data-dashboard">https://covid19.colorado.gov/vaccine-data-dashboard</a></p>
    <p class="mt-1 mx-2 text-left">Privacy - This website uses Google Analytics for general site info, such as tracking how many people visit this site.
      For the full policy visit <a href="https://www.privacypolicies.com/live/d93a5cf7-74a9-44d7-8af4-deec95d51130">this link</a>.</p>
  </div>
</template>

<script>
const axios = require('axios');
import Vaccines from './charts/Vaccines.vue'
import VaccinePie from './charts/VaccinePie.vue'
import Cases from './charts/Cases.vue'
import Hospitalized from './charts/Hospitalized.vue'
import Deaths from './charts/Deaths.vue'
import DataBox from './DataBox.vue'
import GeneralStats from './charts/GeneralStats.vue'
import Spinner from './Spinner.vue'
import { numberWithCommas } from '../utils/formatting.js'

export default {
  name: 'Charts',

  props: ['shownCharts'],

  components: {
    Vaccines,
    VaccinePie,
    Cases,
    Hospitalized,
    Deaths,
    DataBox,
    GeneralStats,
    Spinner,
  },

  data() {
    return {
      casesData: [],
      vaccinesData: [],
      hospitalData: [],
      deathData: [],
      trigger: false,
      covidData: {},
      lastCasesUpdate: "",
      lastVaccinesUpdate: ""
    }
  },

  created() {
    this.getData()
  },

  methods: {
    showChart(selection, chart) {
      // caseStats, vaccineStats, vaccinePie, generalStats, vaccinesChart, casesChart, deathsChart, hospitalizedChart
      const key = {
        overview: [
          'caseStats', 'vaccineStats', 'vaccinePie', 'generalStats', 'vaccinesChart', 'casesChart'
        ],
        cases: [
          'caseStats', 'casesChart'
        ],
        vaccines: [
          'vaccineStats', 'vaccinePie', 'vaccinesChart'
        ], 
        hospitalizations: [
          'hospitalizedChart'
        ],
        deaths: [
          'deathsChart'
        ]
      }
      return key[selection].includes(chart)
    },
    getData() {
      (async () => {
        try {
          const api_url = process.env.VUE_APP_API_URL
          const [allData] = await axios.all([
            axios.get(api_url + '/data/')
          ]);

          const vaccinesAverage = allData.data.data.ave_vaccines
          const vaccinesHistory = allData.data.data.daily_vaccines
          const casesAverage = allData.data.data.ave_cases
          const casesHistory = allData.data.data.daily_cases

          this.covidData = {
            vaccinesAverage,
            vaccinesHistory,
            casesAverage,
            casesHistory
          }

          this.calculateCasesData()
          this.calculateVaccinesData()
          this.updateLastUpdatedCasesTime(casesHistory)
          this.updateLastUpdatedVaccinesTime(vaccinesHistory)
          this.trigger = true
        } catch (error) {
          console.log(error);
        }
      })();
    },

    calculateCasesData() {
      const casesHistory = this.covidData.casesHistory
      const casesAverage = this.covidData.casesAverage

      const today = numberWithCommas(casesHistory[casesHistory.length - 1].positive_increase)
      const yesterday = numberWithCommas(casesHistory[casesHistory.length - 2].positive_increase)
      const week_ago = numberWithCommas(casesHistory[casesHistory.length - 8].positive_increase)

      const today_date = numberWithCommas(casesHistory[casesHistory.length - 1].reporting_date).slice(7)
      const yesterday_date = numberWithCommas(casesHistory[casesHistory.length - 2].reporting_date).slice(7)
      const week_ago_date = numberWithCommas(casesHistory[casesHistory.length - 8].reporting_date).slice(7)

      const today_ave = numberWithCommas(casesAverage[casesAverage.length - 1].positive_increase)
      const yesterday_ave = numberWithCommas(casesAverage[casesAverage.length - 2].positive_increase)
      const week_ago_ave = numberWithCommas(casesAverage[casesAverage.length - 8].positive_increase)

      this.casesData = {
        "headers": ["Actual", "7-day Average"],
        "rows": [
          [`New Cases on ${today_date}`, today, today_ave],
          [`Cases on ${yesterday_date}`, yesterday, yesterday_ave],
          [`Cases on ${week_ago_date}`, week_ago, week_ago_ave],
        ]
      }
    },

    calculateVaccinesData() {
      const vaccinesHistory = this.covidData.vaccinesHistory
      const vaccinesAverage = this.covidData.vaccinesAverage

      const today = numberWithCommas(vaccinesHistory[vaccinesHistory.length - 1].daily_qty)
      const yesterday = numberWithCommas(vaccinesHistory[vaccinesHistory.length - 2].daily_qty)
      const week_ago = numberWithCommas(vaccinesHistory[vaccinesHistory.length - 8].daily_qty)

      const today_date = numberWithCommas(vaccinesHistory[vaccinesHistory.length - 1].reporting_date).slice(7)
      const yesterday_date = numberWithCommas(vaccinesHistory[vaccinesHistory.length - 2].reporting_date).slice(7)
      const week_ago_date = numberWithCommas(vaccinesHistory[vaccinesHistory.length - 8].reporting_date).slice(7)

      const today_ave = numberWithCommas(vaccinesAverage[vaccinesAverage.length - 1].daily_qty)
      const yesterday_ave = numberWithCommas(vaccinesAverage[vaccinesAverage.length - 2].daily_qty)
      const week_ago_ave = numberWithCommas(vaccinesAverage[vaccinesAverage.length - 8].daily_qty)

      this.vaccinesData = {
        "headers": ["Actual", "7-day Average"],
        "rows": [
          [`Vaccinated on ${today_date}`, today, today_ave],
          [`Vaccinated on ${yesterday_date}`, yesterday, yesterday_ave],
          [`Vaccinated on ${week_ago_date}`, week_ago, week_ago_ave],
        ]
      }
    },
    updateLastUpdatedCasesTime(casesHistory) {
      const time = new Date(casesHistory[casesHistory.length - 1].created_at)
      this.lastCasesUpdate = time.toLocaleString()
    },
    updateLastUpdatedVaccinesTime(vaccinesHistory) {
      const time = new Date(vaccinesHistory[vaccinesHistory.length - 1].created_at)
      this.lastVaccinesUpdate = time.toLocaleString()
    }
  }
}
</script>

<style scoped>
.highcharts-figure, .highcharts-data-table table {
  min-width: 360px; 
  max-width: 800px;
  margin: 1em auto;
}
.highcharts-data-table table {
	font-family: Verdana, sans-serif;
	border-collapse: collapse;
	border: 1px solid #EBEBEB;
	margin: 10px auto;
	text-align: center;
	width: 100%;
	max-width: 500px;
}
.highcharts-data-table caption {
  padding: 1em 0;
  font-size: 1.2em;
  color: #555;
}
.highcharts-data-table th {
	font-weight: 600;
  padding: 0.5em;
}
.highcharts-data-table td, .highcharts-data-table th, .highcharts-data-table caption {
  padding: 0.5em;
}
.highcharts-data-table thead tr, .highcharts-data-table tr:nth-child(even) {
  background: #f8f8f8;
}
.highcharts-data-table tr:hover {
  background: #f1f7ff;
}
.v-progress-circular {
  margin: 1rem;
  text-align: center;
}

#flex-wrapper {
  max-width: 1200px; 
  margin: auto;
}
</style>
