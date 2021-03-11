# Colorado COVID Data Dashboard

### Colorado COVID data updated daily, including vaccine stats, daily infections, hospitalizations, and deaths due to COVID.


<br>
<details open="open">
  <summary><h2 style="display: inline-block">Table of Contents</h2></summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#how-it-works">How it works</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
  </ol>
</details>


## About The Project

[<img src="https://github.com/jpclark6/colorado-covid-tracker/blob/master/images/dashboard.png" height="500px"/>](https://coloradocoviddata.com)

When I was looking around the web for Colorado COVID data the [Colorado government website](https://covid19.colorado.gov/data) had some good data and charts, but they were in a cluttered website with lots of data I wasn't interested in. This project delivers a simple layout of the data I wanted to see and updates the data daily. 

This repo is for the frontend dashboard. The backend repo can be found [here](https://github.com/jpclark6/colorado-covid-tracker)


### Built With

* [Vue.js](https://vuejs.org/)
* [Vuetify](https://vuetifyjs.com/)
* [Docker](https://www.docker.com/)

## Getting Started

To get a copy up and running follow these simple steps.

### Prerequisites

You'll need to have Docker installed to run this app. You'll need to have npm and node installed to use the dev server.

### Installation

1. Clone the repo to your favorite directory.
    ```sh
    $ git clone https://github.com/jpclark6/colorado-covid-frontend.git
    $ cd colorado-covid-frontend
    ```

2. Install packages
    ```sh
    $ npm install
    ```

3. Run dev server
    ```sh
    $ npm run serve
    ```

4. To run with docker
    ```sh
    $ docker build -t coloradocoviddata .
    $ docker run -p 8080:8080 -d --name dockerize-coloradocoviddata coloradocoviddata
    ```

5. To update on server
    ```sh
    $ ./build.sh
    ```


## Roadmap

1. Add data tables with paginated raw data
1. Add more data boxes with basic info from new graphs
1. Add tests

## License

Distributed under the MIT License.


## Contact

[LinkedIn](https://linkedin.com/in/jpclark6)

