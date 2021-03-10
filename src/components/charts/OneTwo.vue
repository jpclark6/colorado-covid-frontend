<template>
  <div id="oneTwoContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);

const lightColorOneDose = "#e6e6ff";
const darkColorOneDose = "#0000cc";

const lightColorFullyImmunized = "#c1ffe0";
const darkColorFullyImmunized = "#00241b";

export default {
  name: 'OneTwo',

  methods: {
    drawHighCharts() {
      const {vaccinesAverage, vaccinesHistory} = this.covidData
      this.drawCases(vaccinesAverage, vaccinesHistory)
    },

    drawCases(vaccinesAverage, vaccinesHistory) {
      let fullyImmunizedAve = []
      vaccinesAverage.forEach(day => fullyImmunizedAve.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.fully_immunized_increase
        }
      ))

      let fullyImmunized = []
      vaccinesHistory.forEach(day => fullyImmunized.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.fully_immunized_increase
        }
      ))

      let oneDoseAve = []
      vaccinesAverage.forEach(day => oneDoseAve.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.one_dose_increase
        }
      ))

      let oneDose = []
      vaccinesHistory.forEach(day => oneDose.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.one_dose_increase
        }
      ))

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('oneTwoContainer', {
        title: {
          text: 'One Dose vs. Fully Immunized Dose'
        },

        chart: {
          zoomType: 'x'
        },

        subtitle: {
          text: 'Daily and 7 Day Rolling Average'
        },

        yAxis: {
          title: {
            text: 'Vaccines'
          },
          max: 40000
        },

        xAxis: {
          type: 'datetime',
          title: {
            text: 'Reporting Date'
          },
          min: 1610866800000,
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
          name: 'First Dose (Pfizer and Moderna)',
          data: oneDose,
          color: lightColorOneDose
        }, {
          name: 'First Dose 7 Day Ave.',
          data: oneDoseAve,
          color: darkColorOneDose
        }, {
          name: 'Fully Immunized Dose',
          data: fullyImmunized,
          color: lightColorFullyImmunized
        }, {
          name: 'Fully Immunized Dose 7 Day Ave.',
          data: fullyImmunizedAve,
          color: darkColorFullyImmunized
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
