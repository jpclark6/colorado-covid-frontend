<template>
  <div class="d-lg-flex justify-center d-md-flex flex-wrap">
    <div>
      <div id="vaccinePieContainer"></div>
    </div>
    <div class="databox d-flex align-center" v-if="true">
      <DataBox :items="vaccineStats" />
    </div>
  </div>
</template>

<script>
var Highcharts = require('highcharts');
require('highcharts/modules/exporting')(Highcharts);
import DataBox from '../DataBox.vue'
import { numberWithCommas } from '../../utils/formatting.js'

const unvaccinatedColor = "#e6e6ff";
const oneDoseColor = "#a199ff";
const twoDosesColor = "#00ff15";

export default {
  name: 'VaccinePie',

  components: {DataBox},

  methods: {
    drawHighCharts() {
      const {vaccinesHistory, casesHistory} = this.covidData
      this.getVaccineStats(vaccinesHistory, casesHistory)
      this.drawVaccines(vaccinesHistory)
    },
    drawVaccines(vaccinesHistory) {
      const two_doses = vaccinesHistory[vaccinesHistory.length - 1].two_doses_total
      const one_dose = vaccinesHistory[vaccinesHistory.length - 1].one_dose_total - two_doses
      const population = Math.round(5763976 * (1 - .219)) // 21.9% of population is under 18 https://www.census.gov/quickfacts/CO
      const one_dose_percentage = one_dose / population
      const two_doses_percentage = two_doses / population
      const unvaccinated = (population - one_dose - two_doses) / population

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('vaccinePieContainer', {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: 'Colorado 18+ Population COVID Vaccine Rate'
        },
        tooltip: {
            pointFormat: '{series.name}: <b>{point.percentage:.1f}%</b>'
        },
        accessibility: {
            point: {
                valueSuffix: '%'
            }
        },
        plotOptions: {
            pie: {
                allowPointSelect: true,
                cursor: 'pointer',
                colors: [unvaccinatedColor, oneDoseColor, twoDosesColor],
                dataLabels: {
                    enabled: true,
                    format: '<b>{point.name}</b>: {point.percentage:.1f}%  ({point.people} people)',
                    padding: 10
                }
            }
        },
        series: [{
          name: 'Vaccination Rate',
          colorByPoint: true,
          data: [{
            name: 'Unvaccinated Adults',
            y: unvaccinated * 100,
            people: numberWithCommas(population - one_dose - two_doses)
          }, {
            name: 'Received One Dose',
            y: one_dose_percentage * 100,
            people: numberWithCommas(one_dose)
          }, {
            name: 'Received Both Doses',
            y: two_doses_percentage * 100,
            people: numberWithCommas(two_doses)
          }
          ]
        }]
      })
    },
    getVaccineStats(vaccinesHistory, casesHistory) {
      const daily_cumulative = vaccinesHistory[vaccinesHistory.length - 1].daily_cumulative
      const total_deaths = casesHistory[casesHistory.length - 1].death_confirmed
      const total_positive = casesHistory[casesHistory.length - 1].positive
      const total_tested = casesHistory[casesHistory.length - 1].tested
      const at_least_one_dose = vaccinesHistory[vaccinesHistory.length - 1].one_dose_total

      this.vaccineStats = {
        "headers": ["CO Stats"],
        "rows": [
          ["Total population", numberWithCommas(5763976)],
          ["Total population 18+", numberWithCommas(Math.round(5763976 * (1 - .219)))],
          ["Total positive cases", numberWithCommas(total_positive)],
          ["Total vaccines given", numberWithCommas(daily_cumulative)],
          ["People with at least one dose", numberWithCommas(at_least_one_dose)],
          ["Total deaths", numberWithCommas(total_deaths)],
          ["Total tests given", numberWithCommas(total_tested)]
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
      this.drawHighCharts()
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
.highcharts-figure, .highcharts-data-table table {
    min-width: 320px; 
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
input[type="number"] {
	min-width: 50px;
}
</style>
