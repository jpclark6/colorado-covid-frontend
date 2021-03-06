<template>
  <div class="pie-box">
      <div id="vaccinePieContainer"></div>
  </div>
</template>

<script>
var Highcharts = require('highcharts');
import { numberWithCommas } from '../../utils/formatting.js'
require('highcharts/modules/exporting')(Highcharts);

const unvaccinatedColor = "#e6e6ff";
const oneDoseColor = "#a199ff";
const fullyImmunizedColor = "#00ff15";

export default {
  name: 'VaccinePie',

  methods: {
    drawHighCharts() {
      const { vaccinesHistory } = this.covidData
      this.drawVaccines(vaccinesHistory)
    },
    drawVaccines(vaccinesHistory) {
      const fully_immunized = vaccinesHistory[vaccinesHistory.length - 1].fully_immunized_total
      const one_dose = vaccinesHistory[vaccinesHistory.length - 1].one_dose_total - fully_immunized
      const population = Math.round(5763976 * (1 - .219)) // 21.9% of population is under 18 https://www.census.gov/quickfacts/CO
      const one_dose_percentage = one_dose / population
      const fully_immunized_percentage = fully_immunized / population
      const unvaccinated = (population - one_dose - fully_immunized) / population

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        },
        colors: Highcharts.map([unvaccinatedColor, oneDoseColor, fullyImmunizedColor], function (color) {
          return {
            radialGradient: {
                cx: .5,
                cy: .5,
                r: 1
            },
            stops: [
                [0, color],
                [.5, Highcharts.color(color).brighten(-0.1).get('rgb')],
            ]
          };
        })
      });

      var chart = Highcharts.chart('vaccinePieContainer', {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie'
        },
        title: {
            text: 'Colorado Adult COVID Vaccine Rate'
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
            people: numberWithCommas(population - one_dose - fully_immunized)
          }, {
            name: 'Received One Dose',
            y: one_dose_percentage * 100,
            people: numberWithCommas(one_dose)
          }, {
            name: 'Fully Immunized',
            y: fully_immunized_percentage * 100,
            people: numberWithCommas(fully_immunized)
          }
          ]
        }],
        
      })
      chart.reflow()
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
  }
}
</script>

<style scoped>
@media (max-width: 600px) {
  .pie-box {
    max-width: 400px;
  }
}
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
