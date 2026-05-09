Dans cet exercice, on va créer un programme de livraison d'aliments pour un restaurant !

Voici les premières **actions utilisateur** de l'application :
- En tant qu'utilisateur, je peux ajouter un nouveau repas
- En tant qu'utilisateur, je peux lister tous les repas
- En tant qu'utilisateur, je peux ajouter un nouveau client
- En tant qu'utilisateur, je peux lister tous les clients

**ATTENTION**

Le logiciel est conçu pour **un restaurant seulement**, alors inutile de livrer (sans mauvais jeu de mots 😉) une application pour plusieurs restaurants (par ex., tu n'as pas besoin de modèle `Restaurant`).

Le logiciel est conçu pour **le personnel du restaurant uniquement**, alors inutile de concevoir une interface de connexion pour les clients.

Les premiers composants du logiciel sont donc les suivants :
- **Repas** (meals)
- **Clients** (customers)

## Comment on va construire ça

On va travailler en deux phases :

1. **D'abord la couche de données** : Pour chaque composant, construis le modèle et le repository et utilise `rake` pour vérifier que ça marche. Pas d'UI, pas de routeur, juste une logique de données solide.
2. **Ensuite les fonctionnalités** : Une fois la couche de données solide, lance l'app et construis chaque fonctionnalité (contrôleur + vue) de bout en bout. Teste chacune en utilisant vraiment l'app.

Les tests `rake` sont très utiles pour vérifier que la couche de données fonctionne, mais ils ne testent pas l'expérience utilisateur. On veut donc s'assurer de tester chaque fonctionnalité en utilisant vraiment l'app et en la voyant fonctionner dans le terminal. C'est la meilleure façon de s'assurer que l'expérience utilisateur est bonne et que tous les composants de l'app fonctionnent bien ensemble.

## 1 - Repas (meals)

### 1.1 - Modèle de repas (meal)

Commençons par la couche de données pour les repas.

Le restaurant vend des repas ; tu dois donc trouver une façon de représenter ce qu'est un repas (meal).

Chaque repas `meal` a un identifiant `id`, un nom `name` et un prix `price`.

Écris le code pour implémenter cela et teste ton modèle. Puis teste ton code en exécutant `rake meal`.

Tout est vert ? Parfait ! Le moment est venu de faire `git add`, `commit` et `push`.

### 1.2 - Dépôt de repas (meal repository)

Maintenant que tu as un modèle pour représenter les repas, tu as besoin d'un dépôt (repository) pour les stocker.

Ce repository s'initialise avec un chemin de fichier CSV. Il lit et écrit les repas depuis le fichier CSV et les stocke comme des objets dans un array. Le comportement que l'on souhaite pour le repository est le suivant :
- créer un nouveau `meal` (`create`)
- récupérer tous les `meal` (`all`)
- trouver un `meal` spécifique grâce à son `id` (`find`)

Écris le code pour implémenter cela et teste ton repository. Tu dois créer ton propre fichier CSV `meals.csv` dans le dossier `data`. Teste ensuite ton code en exécutant `rake meal`.

Tout est vert ? Parfait ! Le moment est venu de faire `git add`, `commit` et `push`.

### 1.3 - Routeur et application (router and app)

Maintenant, commençons à développer les vraies fonctionnalités de notre app. Avant d'implémenter les fonctionnalités des repas, on doit pouvoir lancer notre app.

Pour cela, on a besoin d'un routeur et de remplir le fichier `app.rb`.

Le routeur est chargé d'afficher les différentes fonctionnalités que l'utilisateur peut sélectionner et de router le choix de l'utilisateur vers la bonne action du bon contrôleur. Le fichier `app.rb` est en charge de `require` tous les fichiers nécessaires, d'instancier un routeur et d'exécuter sa méthode `run` pour lancer l'application.

Remplis les fichiers `router.rb` et `app.rb` pour implémenter cela. Si tu es coincé, retourne à l'exercice [Cookbook](https://kitt.lewagon.com/camps/<user.batch_slug>/challenges?path=02-OOP%2F03-Cookbook%2F02-Cookbook) et télécharge la solution pour trouver de l'inspiration. **Inutile d'instancier le routeur avec un contrôleur** puisque tu n'en as pas encore. Pour le moment, contente-toi d'imprimer `TODO` quand l'utilisateur sélectionne une tâche.

Il n'y a pas de rake pour cette partie. Lance ton application en exécutant cette commande dans le terminal :

```bash
ruby app.rb
```

Tout fonctionne correctement ? Parfait ! Le moment est venu de faire `git add`, `commit` et `push`.

### 1.4 - Fonctionnalités des repas (meals features)

On va passer au `MealsController`. Voici les **actions utilisateur** que l'on veut implémenter :
- ajouter un nouveau `meal` (`add`)
- lister tous les `meal` (`list`)

⚠️ Évite d'essayer de développer les deux fonctionnalités en même temps. **Code en silo**, en développant d'abord entièrement la fonctionnalité `add` et en la testant dans le Terminal en lançant ton app avec `ruby app.rb`. Ensuite passe à la fonctionnalité `list` et fais de même. Ne continue que lorsque tu peux vraiment ajouter un repas et lister tous les repas dans le terminal.

Souviens-toi que le rôle du contrôleur est de déléguer et de coordonner le travail des autres composants de l'app (modèle, repository et vue) !

Pour implémenter ces fonctionnalités, tu auras peut-être aussi besoin de créer une `MealsView` pour afficher les informations pertinentes à l'utilisateur et lui demander des informations.

Commence par écrire le **pseudo-code**, en distinguant les étapes élémentaires de chaque action utilisateur et en déléguant chaque étape à un composant (modèle, repository ou vue). Puis écris le code pour implémenter chaque étape. Crée la vue et code-la étape par étape.

Pour tester ton contrôleur, connecte-le à ton app en l'instanciant dans `app.rb` et en le passant au routeur. Tu peux ensuite tester ton code en lançant ton app :

```bash
ruby app.rb
```

`rake meal` devrait t'être utile pendant ces étapes. Suis ton guide !

Vérifie que les deux actions utilisateur sur les repas fonctionnent avant de passer à la fonctionnalité suivante.

📝 **Note:** Dans cet exercice (contrairement aux modèles et aux contrôleurs), il n'y a pas de `rake` spécifique pour les vues. Cela est dû au fait qu'il existe de nombreuses façons différentes d'afficher les informations pertinentes et qu'il n'y a pas de seule manière "correcte". N'hésitez donc pas à penser de manière artistique 🧑‍🎨 à ce que vos vues devraient montrer. Mais assurez-vous qu'elles fonctionnent correctement en exécutant `ruby app.rb` et en vérifiant si l'application fonctionne bien et est facile à utiliser.

Si tout fonctionne, voici à quoi devrait ressembler ton app :

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

Tout est vert et ça fonctionne ? Parfait ! Le moment est venu de `git add`, `commit` et `push`.

## 2 - Clients (customers)

### 2.1 - Modèle de client (customer model)

Le restaurant vend à des clients ; tu dois donc trouver une façon de représenter ce qu'est un client (customer). Recommençons par la couche de données.

Chaque client `customer` a un identifiant `id`, un nom `name` et une adresse `address`.

Écris le code pour implémenter cela et teste ton modèle. Puis teste ton code en exécutant `rake customer`.

Tout est vert ? Parfait ! Le moment est venu de `git add`, `commit` et `push`.

### 2.2 - Dépôt de client (client repository)

Maintenant que tu as un modèle pour représenter les clients, tu as besoin d'un dépôt (repository) pour les stocker.

Ce repository s'initialise avec un chemin de fichier CSV. Il lit et écrit les clients depuis le fichier CSV et les stocke comme des objets dans un array. Le comportement souhaité du repository est le suivant :
- créer un nouveau `customer` (`create`)
- récupérer tous les `customer` (`all`)
- trouver un `customer` spécifique grâce à son `id` (`find`)

Écris le code pour implémenter cela et teste ton repository. Tu dois créer ton propre fichier CSV `customers.csv` dans le dossier `data`. Teste ensuite ton code en exécutant `rake customer`.

Tout est vert ? Parfait ! Le moment est venu de `git add`, `commit` et `push`.

### 2.3 - Fonctionnalités des clients (customers features)

C'est le moment d'implémenter les fonctionnalités des clients. _Note : tu n'as pas besoin d'un nouveau routeur ni d'un nouveau fichier app ; on utilisera les mêmes pour toute l'app._

On va passer au `CustomersController`. Voici les **actions utilisateur** que l'on veut implémenter :
- ajouter un nouveau `customer` (`add`)
- lister tous les `customer` (`list`)

N'oublie pas de **coder en silo**, en développant d'abord entièrement la fonctionnalité `add` et en la testant dans le Terminal en lançant ton app avec `ruby app.rb`. Ensuite passe à la fonctionnalité `list` et fais de même. Ne continue que lorsque tu peux vraiment ajouter un client et lister tous les clients dans le terminal.

Souviens-toi que le rôle du contrôleur est de déléguer le travail aux autres composants de l'app (modèle, repository et vue) !

Commence par écrire le **pseudo-code**, en distinguant les étapes élémentaires de chaque action utilisateur et en déléguant chaque étape à un composant (modèle, repository ou vue). Puis écris le code pour implémenter chaque étape. Crée la vue et code-la étape par étape.

Pour tester ton contrôleur, connecte-le à ton app en l'instanciant dans `app.rb` et en le passant au routeur. Tu peux ensuite tester ton code en lançant ton app :

```bash
ruby app.rb
```

`rake customer` devrait t'être utile pendant ces étapes. Suis ton guide !

Vérifie que chaque action utilisateur fonctionne avant de passer à la fonctionnalité suivante.

Si tout fonctionne, voici à quoi devrait ressembler ton app :

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

Tout est vert ? Parfait ! Le moment est venu de `git add`, `commit` et `push`.

## 3 - (Optionnels)

### 3.1 - Implémenter les actions `edit` et `destroy` pour les repas et les clients

Dans l'application, un utilisateur ne peut pas modifier ou supprimer de repas ou de client existant.

Implémente ces actions utilisateurs complémentaires :
- En tant qu'utilisateur, je peux modifier un repas existant
- En tant qu'utilisateur, je peux supprimer un repas existant
- En tant qu'utilisateur, je peux modifier un client existant
- En tant qu'utilisateur, je peux supprimer un client existant

C'est bon ? Le moment est venu de `git add`, `commit` et `push`.

### 3.2 - Refactoriser des repositories grâce à l'héritage

`MealRepository` et `CustomerRepository` ont beaucoup de similitudes, non ? Pour que ton code reste [DRY](https://fr.wikipedia.org/wiki/Ne_vous_r%C3%A9p%C3%A9tez_pas), tu as besoin de définir une classe parente, `BaseRepository`, qui stockera tous les comportements partagés et dont `MealRepository` et `CustomerRepository` hériteront.

Écris le code pour implémenter cela. Il s'agit d'une refactorisation, il n'y a donc rien de nouveau à tester. Si ton `rake` était vert, il doit le rester !

C'est bon ? Le moment est venu de `git add`, `commit` et `push`.
