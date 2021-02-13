<template>
  <!-- <div class="lds-dual-ring"></div> -->
  <div id="vaccinesContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);
const axios = require('axios');

const lightColor = "#e6e6ff";
const darkColor = "#0000cc";





export default {
  name: 'Vaccines',
  methods: {
    drawHighCharts() {
      const {vaccinesAverage, vaccinesHistory} = this.covidData
      this.drawVaccines(vaccinesAverage, vaccinesHistory)
    },
    drawVaccines(vaccinesAverage, vaccinesHistory) {
      let formattedVaccinesAverage = []
      vaccinesAverage.forEach(day => formattedVaccinesAverage.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_qty
        }
      ));

      let formattedVaccinesHistory = []
      vaccinesHistory.forEach(day => formattedVaccinesHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_qty
        }
      ))

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('vaccinesContainer', {
        title: {
          text: 'Vaccine Distribution'
        },

        chart: {
          zoomType: 'x'
        },

        subtitle: {
          text: 'Daily and 7 Day Rolling Average'
        },

        yAxis: {
          title: {
            text: 'Number of Vaccines Given Daily'
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
          name: 'Daily Vaccine Doses Given',
          data: formattedVaccinesHistory,
          color: lightColor
        }, {
            name: 'Ave Daily Vaccine Doses Given',
            data: formattedVaccinesAverage,
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
