<template>
  <div class="d-flex justify-center d-md-flex flex-wrap">
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
import DataBox from '../DataBox.vue'
require('highcharts/modules/exporting')(Highcharts);
const axios = require('axios');

const unvaccinatedColor = "#e6e6ff";
// const oneDoseColor = "#0000cc";
const oneDoseColor = "#a199ff";
const twoDosesColor = "#00ff15";

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}




export default {
  name: 'VaccinePie',
  components: {DataBox},
  methods: {
    drawHighCharts() {
      const {vaccinesHistory} = this.covidData
      this.getVaccineStats(vaccinesHistory)
      this.drawVaccines(vaccinesHistory)
    },
    drawVaccines(vaccinesHistory) {
      const one_dose = vaccinesHistory[vaccinesHistory.length - 1].one_dose_total
      const two_doses = vaccinesHistory[vaccinesHistory.length - 1].two_doses_total
      const population = Math.round(5763976 * (1 - .219)) // 21.9% of population is under 18 https://www.census.gov/quickfacts/CO
      const one_dose_percentage = one_dose / population
      const two_doses_percentage = two_doses / population
      const unvaccinated = (population - one_dose - two_doses) / population

      const one_dose_week_ago = vaccinesHistory[vaccinesHistory.length - 8].one_dose_total
      const two_doses_week_ago = vaccinesHistory[vaccinesHistory.length - 8].two_doses_total
      const one_dose_percentage_week_ago = one_dose_week_ago / population
      const two_doses_percentage_week_ago = two_doses_week_ago / population
      const unvaccinated_week_ago = (population - one_dose_week_ago - two_doses_week_ago) / population

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
            text: 'Colorado Population COVID Vaccine Rate'
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
                    format: '<b>{point.name}</b>: {point.percentage:.1f}%  ({point.people} people)'
                }
            }
        },
        series: [{
          name: 'Vaccination Rate',
          colorByPoint: true,
          data: [{
            name: 'Unvaccinated Adults (18+)',
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
    getVaccineStats(vaccinesHistory) {
      const daily_cumulative = vaccinesHistory[vaccinesHistory.length - 1].daily_cumulative
      this.vaccineStats = [{description: "Cases today", value: daily_cumulative, ave_value: 42},
        {description: "Cases yesterday", value: 24, ave_value: 42}]
    }
  },
  props: ['covidData', 'readyToChart'],
  watch: {
    readyToChart: function(newVar, oldVar) {
      this.drawHighCharts()
    }
  },
  data() {
    return {
      vaccineStats: []
    }
  },
}
</script>

<style>

</style>
