e = Coin.create(name: "Ethereum", last_value: 296.40)
b = Coin.create(name: "Bitcoin", last_value: 3900.77)
l = Coin.create(name: "Litecoin", last_value: 52.77)
c = Coin.create(name: "Bitcoin Cash", last_value: 3000)

g = User.create(name: "Eric", email: "e@e.com", password: "qwerty")
a = User.create(name: "Allison", email: "a@a.com", password: "qwerty")

Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 1355.80, price_per_coin: 337.02)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 1104.00, price_per_coin: 363.01)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 337.96, price_per_coin: 397.27)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 2466.25, price_per_coin: 337.18)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 9980.74, price_per_coin: 337.00)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 1533.00, price_per_coin: 333.30)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 377.67, price_per_coin: 325.50)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 4579.99, price_per_coin: 335.00)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 3479.00, price_per_coin: 333.00)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 4745.01, price_per_coin: 332.04)

Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 563.60, price_per_coin: 389.44)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 940.98, price_per_coin: 349.74)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 13.00, price_per_coin: 333.66)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 1970.64, price_per_coin: 309.53)
Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 950.00, price_per_coin: 303.31)

Transaction.create(user_id: User.first.id, coin_id: Coin.second.id, money_in: 5990.00, price_per_coin: 5730.30)

Transaction.create(user_id: User.first.id, coin_id: Coin.first.id, money_in: 5000.00, price_per_coin: 564.73)
Transaction.create(user_id: User.first.id, coin_id: Coin.third.id, money_in: 311.90, price_per_coin: 314.92)
Transaction.create(user_id: User.first.id, coin_id: Coin.last.id, money_in: 4087.73, price_per_coin: 5300.00)

Transaction.create(user_id: User.first.id, coin_id: Coin.last.id, money_in: 3.41, price_per_coin: 3419.99)
Transaction.create(user_id: User.first.id, coin_id: Coin.last.id, money_in: 617.85, price_per_coin: 3420.00)
Transaction.create(user_id: User.first.id, coin_id: Coin.last.id, money_in: 232.90, price_per_coin: 3438.98)



Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 1355.80, price_per_coin: 337.02)

Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 2466.25, price_per_coin: 337.18)

Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 1104.00, price_per_coin: 363.01)
Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 337.96, price_per_coin: 397.27)
Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 9980.74, price_per_coin: 337.00)
Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 1533.00, price_per_coin: 333.30)
Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 377.67, price_per_coin: 325.50)
Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 4579.99, price_per_coin: 335.00)
Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 3479.00, price_per_coin: 333.00)
Transaction.create(user_id: User.last.id, coin_id: Coin.first.id, money_in: 4745.01, price_per_coin: 332.04)
Note.create(comment: "a,1of3 Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source.", transaction_id: Transaction.last.id)
Note.create(comment: "a,2of3 Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.", transaction_id: Transaction.last.id)
Note.create(comment: "a,3of3 This purchase was made after China banned initial coin offerings.", transaction_id: Transaction.last.id)
Note.create(comment: "b,1of1 This purchase was made after the IRS announced that they were demanding coinbase account data.", transaction_id: Transaction.last.id - 1)