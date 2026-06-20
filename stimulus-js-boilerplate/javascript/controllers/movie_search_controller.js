import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["input", "list"];

  connect() {
    console.log("hello from movie search controller");
  }

  async search() {
    // empty the result list
    this.listTarget.innerHTML = "";

    const movies = await this.fetchMovies();
    // iterate over the list of movies
    movies.forEach((movie) => {
      // on each iteration, make a li with the movie title and year
      const item = `<li class="list-group-item">${movie.Title}</li>`;
      // insert it into the ul
      this.listTarget.insertAdjacentHTML("beforeend", item);
    });

    // Clean the input field so it's easier to re-do search
    this.inputTarget.value = "";
  }

  async fetchMovies() {
    // look at what the user had typed
    const keyword = this.inputTarget.value;

    // using that keyword, run the query on OMDB
    const url = `http://www.omdbapi.com/?apikey=adf1f2d7&s=${keyword}`;
    const response = await fetch(url);
    // parse the json
    const data = await response.json();

    const movies = data.Search;

    return movies;
  }
}
