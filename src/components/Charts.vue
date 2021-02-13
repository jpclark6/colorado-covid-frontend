<template>
  <div class="text-center">
    <div v-show="!trigger">
    <v-progress-circular
        indeterminate
        color="primary"
        :size="70"
        :width="7"
      ></v-progress-circular>
      <div>Loading data</div>
      </div>
    <div v-show="trigger">
      <DataBox :items="casesData"/>
      <Vaccines :readyToChart="trigger" :covidData="covidData"/>
      <Cases :readyToChart="trigger" :covidData="covidData"/>
      <Hospitalized :readyToChart="trigger" :covidData="covidData"/>
      <Deaths :readyToChart="trigger" :covidData="covidData"/>
    </div>
  </div>
</template>

<script>
const axios = require('axios');
import Vaccines from './charts/Vaccines.vue'
import Cases from './charts/Cases.vue'
import Hospitalized from './charts/Hospitalized.vue'
import Deaths from './charts/Deaths.vue'
import DataBox from './DataBox.vue'

export default {
  name: 'Charts',
  components: {
    Vaccines,
    Cases,
    Hospitalized,
    Deaths,
    DataBox
  },
  data() {
    return {
      casesData: [],
      trigger: false,
      covidData: {}
    }
  },
  created() {
    this.getData()
    this.calculateCasesData()
  },
  methods: {
    getData() {
      (async () => {
        try {
          const [vaccinesAverageRes, vaccinesHistoryRes, casesAverageRes, casesHistoryRes] = await axios.all([
            axios.get('https://okvn4rtq0k.execute-api.us-east-1.amazonaws.com/Prod/vaccines_average/'),
            axios.get('https://okvn4rtq0k.execute-api.us-east-1.amazonaws.com/Prod/vaccines_history/'),
            axios.get('https://okvn4rtq0k.execute-api.us-east-1.amazonaws.com/Prod/cases_average/'),
            axios.get('https://okvn4rtq0k.execute-api.us-east-1.amazonaws.com/Prod/cases_history/')
          ]);
          const vaccinesAverage = vaccinesAverageRes.data
          const vaccinesHistory = vaccinesHistoryRes.data
          const casesAverage = casesAverageRes.data
          const casesHistory = casesHistoryRes.data
      
          this.covidData = {
            vaccinesAverage,
            vaccinesHistory,
            casesAverage,
            casesHistory
          }
          this.trigger = true
        } catch (error) {
          console.log(error);
        }
      })();
    },
    calculateCasesData() {
      this.casesData = [
          {description: "Vaccines today", value: 42},
          {description: "Vaccines yesterday", value: 87},
          {description: `Vaccines a week ago`, value: 87},
        ]
    }
  }
}
</script>

<style scoped>
.highcharts-figure, .highcharts-data-table table {
  min-width: 360px; 
  max-width: 800px;
  margin: 1em auto;
}

.highcharts-data-table table {
	font-family: Verdana, sans-serif;
	border-collapse: collapse;
	border: 1px solid #EBEBEB;
	margin: 10px auto;
	text-align: center;
	width: 100%;
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
.v-progress-circular {
  margin: 1rem;
  text-align: center;
}

/* .lds-dual-ring {
  display: inline-block;
  width: 80px;
  height: 80px;
}
.lds-dual-ring:after {
  content: " ";
  display: block;
  width: 64px;
  height: 64px;
  margin: 8px;
  border-radius: 50%;
  border: 6px solid #fff;
  border-color: #fff transparent #fff transparent;
  animation: lds-dual-ring 1.2s linear infinite;
}
@keyframes lds-dual-ring {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
} */

</style>
