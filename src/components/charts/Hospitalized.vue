<template>
  <!-- <div class="lds-dual-ring"></div> -->
  <div id="hospitalizedContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);
const axios = require('axios');

const lightColor = "#e6e6ff";
const darkColor = "#0000cc";




export default {
  name: 'Hospitalized',
  methods: {
    drawHighCharts() {
      const {casesAverage, casesHistory} = this.covidData
      this.drawHospitalized(casesAverage, casesHistory)
    },
    drawHospitalized(casesAverage, casesHistory) {
      let formattedCasesAverage = []
      casesAverage.forEach(day => formattedCasesAverage.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.hospitalized_increase
        }
      ))

      let formattedCasesHistory = []
      casesHistory.forEach(day => formattedCasesHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.hospitalized_increase
        }
      ))

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('hospitalizedContainer', {
        title: {
          text: 'Daily New Hospitalizations'
        },

        chart: {
          zoomType: 'x'
        },

        subtitle: {
          text: 'Daily and 7 Day Rolling Average'
        },

        yAxis: {
          title: {
            text: 'New Hospitalizations'
          },
          min: 0,
          max: 250
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
          name: 'Daily New Hospitalizations',
          data: formattedCasesHistory,
          color: lightColor
        }, {
            name: 'Ave Daily New Hospitalizations',
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



