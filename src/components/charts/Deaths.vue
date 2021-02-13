<template>
  <!-- <div class="lds-dual-ring"></div> -->
  <div id="deathsContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);
const axios = require('axios');

const lightColor = "#e6e6ff";
const darkColor = "#0000cc";




export default {
  name: 'Deaths',
  methods: {
    drawHighCharts(data) {
      const {casesAverage, casesHistory} = this.covidData
      this.drawDeaths(casesAverage, casesHistory)
    },
    drawDeaths(casesAverage, casesHistory) {
      let formattedCasesAverage = []
      console.log(casesAverage)
      casesAverage.forEach(day => formattedCasesAverage.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.death_increase
        }
      ))

      let formattedCasesHistory = []
      casesHistory.forEach(day => formattedCasesHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.death_increase
        }
      ))

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('deathsContainer', {
        title: {
          text: 'Daily New Deaths'
        },

        chart: {
          zoomType: 'x'
        },

        subtitle: {
          text: 'Daily and 7 Day Rolling Average'
        },

        yAxis: {
          title: {
            text: 'Number of New Deaths'
          },
          min: 0,
          max: 150
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
          },
        },

        series: [{
          name: 'Daily New Deaths',
          data: formattedCasesHistory,
          color: lightColor
        }, {
            name: 'Ave Daily New Deaths',
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



