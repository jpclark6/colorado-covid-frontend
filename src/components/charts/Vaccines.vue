<template>
  <div id="vaccinesContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);

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
          text: 'Daily Vaccine Distribution'
        },

        chart: {
          zoomType: 'x'
        },

        subtitle: {
          text: 'Daily and 7 Day Rolling Average'
        },

        yAxis: {
          title: {
            text: 'Vaccines Given Daily'
          },
          min: 0
        },

        xAxis: {
          min: 1607904000000,
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
          name: 'Daily',
          data: formattedVaccinesHistory,
          color: lightColor
        }, {
            name: '7 Day Rolling Average',
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
