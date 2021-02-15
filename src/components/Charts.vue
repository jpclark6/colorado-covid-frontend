<template>
  <div class="text-center">
    <div v-show="!trigger">
    <v-progress-circular
        indeterminate
        color="primary"
        :size="70"
        :width="7"
      ></v-progress-circular>
      <div>Loading data</div>
      </div>
    <div v-show="trigger">
      <p>Data updated daily at 6pm MST*</p>
      <div class="d-flex justify-center d-md-flex flex-wrap">
        <div class="databox">
          <DataBox :items="casesData" />
        </div>
        <div class="databox">
          <DataBox :items="vaccinesData" />
        </div>
      </div>
      <VaccinePie class="mb-8 mt-4" :readyToChart="trigger" :covidData="covidData"/>
      <Vaccines class="mb-8" :readyToChart="trigger" :covidData="covidData"/>
      <Cases class="mb-8" :readyToChart="trigger" :covidData="covidData"/>
      <Deaths class="mb-8" :readyToChart="trigger" :covidData="covidData"/>
      <Hospitalized class="mb-8" :readyToChart="trigger" :covidData="covidData"/>
    </div>
    <p class="mx-6">*Vaccine data is typically released at 4pm for the previous day. So at 2pm on a Wednesday "Today" will
      be for Monday's vaccine data, while at 7pm will be for Tuesday's data. Cases are released on the day of, 
      so before 6pm "Today" is equal to yesterday's data, after 6pm it is equal to today's data.
    </p>
    <p>Sources:</p>
    <p>Cases - <a href="https://covid19.colorado.gov/data">https://covid19.colorado.gov/data</a></p>
    <p>Vaccines - <a href="https://covid19.colorado.gov/vaccine-data-dashboard">https://covid19.colorado.gov/vaccine-data-dashboard</a></p>
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

export default {
  name: 'Charts',
  components: {
    Vaccines,
    VaccinePie,
    Cases,
    Hospitalized,
    Deaths,
    DataBox
  },

  data() {
    return {
      casesData: [],
      vaccinesData: [],
      hospitalData: [],
      deathData: [],
      trigger: false,
      covidData: {}
    }
  },
  created() {
    this.getData()
  },
  methods: {
    getData() {
      (async () => {
        try {
          const [allData] = await axios.all([
            axios.get('https://okvn4rtq0k.execute-api.us-east-1.amazonaws.com/Prod/data/')
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
          this.trigger = true
        } catch (error) {
          console.log(error);
        }
      })();
    },
    calculateCasesData() {
      const today_date = this.covidData.casesHistory[this.covidData.casesHistory.length - 1].reporting_date
      const yesterday_date = this.covidData.casesHistory[this.covidData.casesHistory.length - 2].reporting_date
      const week_ago_date = this.covidData.casesHistory[this.covidData.casesHistory.length - 7].reporting_date

      const today = this.covidData.casesHistory[this.covidData.casesHistory.length - 1].positive_increase
      const yesterday = this.covidData.casesHistory[this.covidData.casesHistory.length - 2].positive_increase
      const week_ago = this.covidData.casesHistory[this.covidData.casesHistory.length - 7].positive_increase

      const today_ave = this.covidData.casesAverage[this.covidData.casesAverage.length - 1].positive_increase
      const yesterday_ave = this.covidData.casesAverage[this.covidData.casesAverage.length - 2].positive_increase
      const week_ago_ave = this.covidData.casesAverage[this.covidData.casesAverage.length - 7].positive_increase

      this.casesData = [
        {description: "Cases today", value: today, ave_value: today_ave},
        {description: "Cases yesterday", value: yesterday, ave_value: yesterday_ave},
        {description: "Cases a week ago", value: week_ago, ave_value: week_ago_ave},
      ]
    },
    calculateVaccinesData() {
      const today = this.covidData.vaccinesHistory[this.covidData.vaccinesHistory.length - 1].daily_qty
      const yesterday = this.covidData.vaccinesHistory[this.covidData.vaccinesHistory.length - 2].daily_qty
      const week_ago = this.covidData.vaccinesHistory[this.covidData.vaccinesHistory.length - 7].daily_qty

      const today_ave = this.covidData.vaccinesAverage[this.covidData.vaccinesAverage.length - 1].daily_qty
      const yesterday_ave = this.covidData.vaccinesAverage[this.covidData.vaccinesAverage.length - 2].daily_qty
      const week_ago_ave = this.covidData.vaccinesAverage[this.covidData.vaccinesAverage.length - 7].daily_qty

      this.vaccinesData = [
        {description: "Vaccines today", value: today, ave_value: today_ave},
        {description: "Vaccines yesterday", value: yesterday, ave_value: yesterday_ave},
        {description: "Vaccines a week ago", value: week_ago, ave_value: week_ago_ave},
      ]
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
.databox {
  margin: 0 10px;
}

</style>