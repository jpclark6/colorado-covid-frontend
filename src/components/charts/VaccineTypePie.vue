<template>
  <div class="pie-box">
      <div id="vaccineTypePieContainer"></div>
  </div>
</template>

<script>
var Highcharts = require('highcharts');
import { numberWithCommas } from '../../utils/formatting.js'
require('highcharts/modules/exporting')(Highcharts);

const pfizerColor = "#e6e6ff";
const modernaColor = "#a199ff";
const jandjColor = "#00ff15";

export default {
  name: 'VaccineTypePie',

  methods: {
    drawHighCharts() {
      const { vaccinesHistory } = this.covidData
      this.drawVaccines(vaccinesHistory)
    },
    drawVaccines(vaccinesHistory) {
      const vaccinesLastWeek = vaccinesHistory.slice(vaccinesHistory.length - 7, vaccinesHistory.length)

      const moderna = vaccinesLastWeek.map(v => v.daily_moderna).reduce( (sum, current) => sum + current, 0)
      const pfizer = vaccinesLastWeek.map(v => v.daily_pfizer).reduce( (sum, current) => sum + current, 0)
      const jandj = vaccinesLastWeek.map(v => v.daily_jandj).reduce( (sum, current) => sum + current, 0)

      const total = moderna + pfizer + jandj

      const moderna_p = moderna / total
      const pfizer_p = pfizer / total
      const jandj_p = jandj / total

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        },
        colors: Highcharts.map([pfizerColor, modernaColor, jandjColor], function (color) {
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

      var typeChart = Highcharts.chart('vaccineTypePieContainer', {
        chart: {
            plotBackgroundColor: null,
            plotBorderWidth: null,
            plotShadow: false,
            type: 'pie',
        },
        title: {
            text: "7 Days of Vaccine Types Administered"
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
                    format: '<b>{point.name}</b>: {point.percentage:.1f}%  ({point.vaccines} vaccines)',
                    padding: 10
                }
            }
        },
        series: [{
          name: 'Vaccinations By Type',
          colorByPoint: true,
          data: [{
            name: 'Moderna',
            y: moderna_p * 100,
            vaccines: numberWithCommas(moderna)
          }, {
            name: 'Pfizer',
            y: pfizer_p * 100,
            vaccines: numberWithCommas(pfizer)
          }, {
            name: 'J&J',
            y: jandj_p * 100,
            vaccines: numberWithCommas(jandj)
          }
          ]
        }],
        
      })
      typeChart.reflow()
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
