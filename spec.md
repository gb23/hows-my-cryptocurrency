# Specifications for the Rails with jQuery Assessment

Specs:
- [x] Use jQuery for implementing new requirements
    See transactions.js file.  All dynamic aspects of this project are done using JQuery
- [x] Include a show resource rendered using jQuery and an Active Model Serialization JSON backend.
    transactions index page will have ability to display an individual transaction show resource (if you click on '...'
    you will be given the show view)
- [x] Include an index resource rendered using jQuery and an Active Model Serialization JSON backend.
    wallet show page (ex: ethereum wallet) will is able to display index of transactions
- [x] Include at least one has_many relationship in information rendered via JSON and appended to the DOM.
    when on transactions index page and the '...' is clicked, the show view of transaction will appear as well as NOTES the user may have entered about the transaction. (Transaction has many NOTES)
- [x] Use your Rails API and a form to create a resource and render the response without a page refresh.
    On the transaction index page, the clicked "create a transaction" button will make appear a form (still on the transaction index page). When this form is submitted, a new transaction will appear (still on the transaction index page.)
- [x] Translate JSON responses into js model objects.
    Resource created from transaction form is sent from the backend to the front, and is then instantiated as a javascript model object.  
- [x] At least one of the js model objects must have at least one method added by your code to the prototype.
    An instance of the javascript model object (described in prior requirement above) has a prototype method which formats the transaction data and preprends it to a list already in the DOM

Confirm
- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
