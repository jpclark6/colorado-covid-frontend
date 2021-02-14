<template>
  <!-- <div class="lds-dual-ring"></div> -->
  <div id="casesContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);

const lightColor = "#e6e6ff";
const darkColor = "#0000cc";


export default {
  name: 'Cases',
  methods: {
    drawHighCharts() {
      const {casesAverage, casesHistory} = this.covidData
      this.drawCases(casesAverage, casesHistory)
    },
    drawCases(casesAverage, casesHistory) {
      let formattedCasesAverage = []
      casesAverage.forEach(day => formattedCasesAverage.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.positive_increase
        }
      ))

      let formattedCasesHistory = []
      casesHistory.forEach(day => formattedCasesHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.positive_increase
        }
      ))

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('casesContainer', {
        title: {
          text: 'Daily New Cases'
        },

        chart: {
          zoomType: 'x'
        },

        subtitle: {
          text: 'Daily and 7 Day Rolling Average'
        },

        yAxis: {
          title: {
            text: 'New Daily COVID-19 Cases'
          }
        },

        xAxis: {
          type: 'datetime',
          title: {
            text: 'Reporting Date'
          }
        },

        legend: {
          layout: 'vertical',
          align: 'right',
          verticalAlign: 'middle'
        },

        plotOptions: {
          series: {
            label: {
              connectorAllowed: false
            },
          }
        },

        series: [{
          name: 'Daily New Cases',
          data: formattedCasesHistory,
          color: lightColor
        }, {
            name: 'Ave Daily New Cases',
            data: formattedCasesAverage,
            color: darkColor
        }],

        responsive: {
          rules: [{
            condition: {
              maxWidth: 500
            },
            chartOptions: {
              legend: {
                layout: 'horizontal',
                align: 'center',
                verticalAlign: 'bottom'
              }
            }
          }]
        }
      })
    }
  },
  props: ['covidData', 'readyToChart'],
  watch: {
    readyToChart: function(newVar, oldVar) {
      this.drawHighCharts()
    }
  }
}
</script>

<style>

</style>



