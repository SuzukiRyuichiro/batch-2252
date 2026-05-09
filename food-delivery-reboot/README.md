Let's build a Food Delivery program for a restaurant!

Here are the first **user actions** of our app:
- As a user, I can add a new meal
- As a user, I can list all the meals
- As a user, I can add a new customer
- As a user, I can list all the customers

**WARNINGS**

The software is designed for **one restaurant only**, so no need to cater (no pun intended 😉) for a multi-restaurant one (e.g. we don't need a `Restaurant` model).

The software is designed for **the restaurant's staff only**, so no need to design a login interface for customers.

Hence, the first components of our software are:
- **Meals**
- **Customers**

## How we'll build this

We'll work in two phases:

1. **Data layer first**: For each component, build the model and repository and use `rake` to verify it works. No UI, no router, just clean data logic.
2. **Features second**: Once the data layer is solid, get the app running and build each feature (controller + view) end-to-end. Test each one by actually using the app.

Though the `rake` tests are very useful to check that the data layer works, they don't test the user experience. So we want to make sure to test each feature by actually using the app and seeing it work in the terminal. This is the best way to make sure that the user experience is good and that all the pieces of our app are working well together.

## 1 - Meals

### 1.1 - Meal model

Let's start with the data layer for meals.

Our restaurant sells meals, so we need a way to represent what a meal is.

Each `meal` has an `id`, a `name` and a `price`.

Write some code to implement this and crash-test your model. Then test your code by running `rake meal`.

All green? Good! Time to `git add`, `commit` and `push`.

### 1.2 - Meal repository

Now that we have a model representing our meals, we need a repository to store them.

This repository is initialized with a CSV file path. It reads and writes the meals from the CSV file and holds them as objects in an array. The behavior we want for the repository is to:
- `create` a new meal
- Get `all` the meals
- `find` a specific meal thanks to its id

Write some code to implement this and crash-test your repository. You should create your own `meals.csv` CSV file inside the `data` folder. Then test your code by running `rake meal`.

All green? Good! Time to `git add`, `commit` and `push`.

### 1.3 - Router and app

Now, let's start building the actual features of our app. Before we can implement the meals features, we need to be able to actually launch our app.

To do this, we need a router and we need to fill in the `app.rb` file.

The router is responsible for displaying the different features the user can select and routing the user's choice to the corresponding action of the matching controller. The `app.rb` file is responsible for requiring all the necessary files, instantiating a router and executing its `run` method to launch the app.

Fill in the `router.rb` and `app.rb` files to implement this. If you're stuck, you can go back to the [Cookbook](https://kitt.lewagon.com/camps/<user.batch_slug>/challenges?path=02-OOP%2F03-Cookbook%2F02-Cookbook) and download the solution to get some inspiration. **No need to instantiate the router with a controller** as we don't have it yet. Just print `TODO` for the moment when the user selects a task.

There is no rake for this part. Launch your app by running this command in the terminal:

```bash
ruby app.rb
```

Everything is working? Good! Time to `git add`, `commit` and `push`.

### 1.4 - Meals features

Let's move to making our `MealsController`. Here are the **user actions** we want to implement:
- `add` a new meal
- `list` all meals

⚠️ You don't want to try building both features at the same time. **Code in silo**, first building the entire `add` feature and testing it in the Terminal by launching your app with `ruby app.rb`. Then move to the `list` feature and do the same. Only proceed once you can actually add a meal and list all the meals in the terminal.

Remember that the role of the controller is to delegate and coordinate the work to the other components of our app (model, repository and view)!

In order to implement these features, you may also need to create a `MealsView` to display and ask for the relevant information to the user.

Start by writing the **pseudocode**, breaking each user action into elementary steps and delegating each step to a component (model, repository or view). Then write the code to implement each step. Create the view and code it step by step.

To test your controller, link it to your app by instantiating it in `app.rb` and passing it to the router. Then you can crash-test your code by launching your app:

```bash
ruby app.rb
```

`rake meal` should also help you go through all these steps. Follow your guide!

Make sure your two meal user actions work before moving on to the next feature.

📝 **Note:** There is no specific `rake` for the views in this challenge (unlike the models and controllers). This is because there are many different ways to display the relevant information, and no one way is the "correct" way. So feel free to think a bit artistically 🧑‍🎨 about what your views should show. But, you'll want to make sure they work properly by running `ruby app.rb` and seeing if the application functions well and is easy to use.

If everything is working, here's what your app should look like:

```
--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
8. Exit
> 1

Name?
> Burger
Price?
> 10

--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
8. Exit
> 2

1. Margherita : 8€
2. Capricciosa : 11€
3. Napolitana : 9€
4. Funghi : 12€
5. Calzone : 10€
6. Burger : 10€
```


All green and working? Good! Time to `git add`, `commit` and `push`.

## 2 - Customers

### 2.1 - Customer model

Our restaurant sells to customers, so we need a way to represent what a customer is. Let's start with the data layer again.

Each customer has an id, a name and an address.

Write some code to implement this and crash-test your model. Then test your code by running `rake customer`.

All green? Good! Time to `git add`, `commit` and `push`.

### 2.2 - Customer repository

Now that we have a model representing our customers, we need a repository to store them.

This repository is initialized with a CSV file path. It reads/writes the customers from the CSV file and holds them as objects in an array. The behavior we want for the repository is to:
- `create` a new customer
- Get `all` the customers
- `find` a specific customer thanks to its id

Write some code to implement this and crash-test your repository. You should create your own `customers.csv` CSV file inside the `data` folder. Then test your code by running `rake customer`.

All green? Good! Time to `git add`, `commit` and `push`.

### 2.3 - Customers features

Now it's time to implement the customers features. _Note: you don't need a new router or a new app file; we'll use the same ones for our whole app._

Let's move to the `CustomersController`. Here are the **user actions** we want to implement:
- `add` a new customer
- `list` all customers

Don't forget to **code in silo**, first building the entire `add` feature and testing it in the Terminal by launching your app with `ruby app.rb`. Then move to the `list` feature and do the same. Only proceed once you can actually add a customer and list all the customers in the terminal.

Remember that the role of the controller is to delegate the work to the other components of our app (model, repository and view)!

Start by writing the **pseudocode**, breaking each user action into elementary steps and delegating each step to a component (model, repository or view). Then write the code to implement each step. Create the view and code it step by step.

To test your controller, link it to your app by instantiating it in `app.rb` and passing it to the router. Then you can crash-test your code by launching your app:

```bash
ruby app.rb
```

`rake customer` should also help you go through all these steps. Follow your guide!

Make sure each user action works before moving on to the next feature.

If everything is working, here's what your app should look like:

```
--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
3. Add new customer
4. List all customers
8. Exit
> 3

Name?
> Alex
Address?
> Berlin

--------------------
------- MENU -------
--------------------
1. Add new meal
2. List all meals
3. Add new customer
4. List all customers
8. Exit
> 4

1. Paul McCartney : Liverpool
2. John Bonham : Redditch
3. John Entwistle : Chiswick
4. Alex : Berlin
```

All green? Good! Time to `git add`, `commit` and `push`.

## 3 - (Optionals)

### 3.1 - Implement `edit` and `destroy` actions for meals and customers

In our app, a user can't edit or destroy an existing meal or customer.

Implement these additional user actions:
- As a user, I can edit an existing meal
- As a user, I can destroy an existing meal
- As a user, I can edit an existing customer
- As a user, I can destroy an existing customer

Done? Time to `git add`, `commit` and `push`.

### 3.2 - Refactor repositories with inheritance

`MealRepository` and `CustomerRepository` have a lot of similarities don't they? In order to stay [DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself), we need to define a parent class, `BaseRepository`, which will hold all of the shared behavior and from which `MealRepository` and `CustomerRepository` will inherit.

Write some code to implement this. It's a refactoring process so there is no new test for this part. If your `rake` was all green before, it should be all green after!

Done? Time to `git add`, `commit` and `push`.
