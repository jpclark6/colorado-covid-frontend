<template>
  <div id="hospitalizedCurrentlyContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);

const lightColor = "#e6e6ff";
const darkColor = "#0000cc";

export default {
  name: 'HospitalizedCurrently',

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
          y: day.hospitalized_currently
        }
      ))

      let formattedCasesHistory = []
      casesHistory.forEach(day => formattedCasesHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.hospitalized_currently
        }
      ))

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('hospitalizedCurrentlyContainer', {
        title: {
          text: 'Current Hospitalizations'
        },

        chart: {
          zoomType: 'x'
        },

        subtitle: {
          text: 'Daily and 7 Day Rolling Average'
        },

        yAxis: {
          title: {
            text: 'Current COVID Hospitalizations'
          },
          min: 0
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
          name: 'Current Hospitalizations',
          data: formattedCasesHistory,
          color: lightColor
        }, {
            name: 'Current Hospitalizations 7 Day Ave.',
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
