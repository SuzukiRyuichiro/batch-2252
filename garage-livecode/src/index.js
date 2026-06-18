// Define the garage name
const garage = "2252";
// Define the API url using the name
const url = `https://garage.api.lewagon.com/${garage}/cars`;
// Define cars list (an element selected from the document, with the class 'cars-list')
const carsList = document.querySelector(".cars-list");
// Fetch the cars in the garage from the API

const fetchCars = async () => {
  const response = await fetch(url);
  // Extract JSON (parse the JSON) into Array of Objects
  const data = await response.json();

  // Iterate over the array of cars objests.
  // On each iteration...
  data.forEach((car) => {
    const randomNum = Math.floor(Math.random() * 20);
    // Make the card for that car
    const carCard = `
      <div class="car">
        <div class="car-image">
          <img src="http://loremflickr.com/280/${280 + randomNum}/car" />
        </div>
        <div class="car-info">
          <h4>${car.brand} ${car.model}</h4>
          <p><strong>Owner:</strong> ${car.owner}</p>
          <p><strong>Plate:</strong> ${car.plate}</p>
        </div>
      </div>
    `;
    // Insert the car card
    carsList.insertAdjacentHTML("beforeend", carCard);
  });
};

fetchCars();
