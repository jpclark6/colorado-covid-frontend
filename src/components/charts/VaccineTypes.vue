<template>
  <div id="vaccineTypesContainer"></div>
</template>

<script>
var Highcharts = require('highcharts');  
require('highcharts/modules/exporting')(Highcharts);

const lightColorModerna = "#e6e6ff";
const darkColorModerna = "#0000cc";

const lightColorPfizer = "#c1ffe0";
const darkColorPfizer = "#00241b";

const lightColorJandJ = "#ffd8de";
const darkColorJandJ = "#4f000b";

export default {
  name: 'VaccineTypes',

  methods: {
    drawHighCharts() {
      const {vaccinesAverage, vaccinesHistory} = this.covidData
      this.drawVaccines(vaccinesAverage, vaccinesHistory)
    },

    drawVaccines(vaccinesAverage, vaccinesHistory) {
      let formattedModernaAverage = []
      vaccinesAverage.forEach(day => formattedModernaAverage.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_moderna
        }
      ));
      let formattedModernaHistory = []
      vaccinesHistory.forEach(day => formattedModernaHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_moderna
        }
      ))
      
      let formattedPfizerAverage = []
      vaccinesAverage.forEach(day => formattedPfizerAverage.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_pfizer
        }
      ));
      let formattedPfizerHistory = []
      vaccinesHistory.forEach(day => formattedPfizerHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_pfizer
        }
      ))

      let formattedJandJAverage = []
      vaccinesAverage.forEach(day => formattedJandJAverage.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_jandj
        }
      ));
      let formattedJandJHistory = []
      vaccinesHistory.forEach(day => formattedJandJHistory.push(
        {
          x: Date.parse(day.reporting_date),
          y: day.daily_jandj
        }
      ))

      Highcharts.setOptions({
        lang: {
          thousandsSep: ','
        }
      });

      Highcharts.chart('vaccineTypesContainer', {
        title: {
          text: 'Daily Vaccine Administration by Type'
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

        series: [
          {
            name: 'Moderna',
            data: formattedModernaHistory,
            color: lightColorModerna
          }, {
            name: 'Pfizer',
            data: formattedPfizerHistory,
            color: lightColorPfizer
          }, {
            name: 'J&J',
            data: formattedJandJHistory,
            color: lightColorJandJ
          }, {
            name: 'Moderna 7 day ave.',
            data: formattedModernaAverage,
            color: darkColorModerna
          }, {
            name: 'Pfizer 7 day ave.',
            data: formattedPfizerAverage,
            color: darkColorPfizer
          }, {
            name: 'J&J 7 day ave.',
            data: formattedJandJAverage,
            color: darkColorJandJ
          },
        ],

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
