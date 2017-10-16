# Specifications for the Rails Assessment

Specs:
- [x] Using Ruby on Rails for the project
- [x] Include at least one has_many relationship (x has_many y e.g. User has_many Recipes) 
example: user has many transactions
- [x] Include at least one belongs_to relationship (x belongs_to y e.g. Post belongs_to User)
example: transaction belongs to coin
- [x] Include at least one has_many through relationship (x has_many y through z e.g. Recipe has_many Items through Ingredients)
example: user has_many :coins, :through => :transactions 
- [x] The "through" part of the has_many through includes at least one user submittable attribute (attribute_name e.g. ingredients.quantity)
example: the "through" part is a transaction, which has many user submittable attributes; for instance, the price of the transaction.
- [x] Include reasonable validations for simple model objects (list of model objects with validations e.g. User, Recipe, Ingredient, Item)
Coin, Transaction, User.  (Wallet is created internally based on the validated data of the other classes)
- [x] Include a class level ActiveRecord scope method (model object & class method name and URL to see the working feature e.g. User.most_recipes URL: /users/most_recipes)
coins model object, most_transactions class method name, URL: /coins/most_transactions
- [x] Include a nested form writing to an associated model using a custom attribute writer (form URL, model name)
/users/transactions/new, Coin
- [x] Include signup 
(Devise)
- [x] Include login 
(Devise)
- [x] Include logout 
(Devise)
- [x] Include third party signup/login 
(Devise/OmniAuth with facebook)
- [x] Include nested resource show or index 
(URL e.g. users/2/transactions, users/2/transactions/1)
- [x] Include nested resource "new" form 
(URL e.g. users/1/transactions/new)
- [x] Include form display of validation errors
log-in, and create/edit transaction data display validation errors, ex: users/1/transactions/new

Confirm:
- [x] The application is pretty DRY
- [x] Limited logic in controllers
- [x] Views use helper methods if appropriate
- [x] Views use partials if appropriate