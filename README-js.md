## Requirements

 1. Must render at least one index page (index resource - 'list of things') via jQuery and an Active Model Serialization JSON Backend. For example, in a blog domain with users and posts, you might display the index of the users posts on the users show page, fetching the posts via an AJAX GET request, with the backend rendering the posts in JSON format, and then appending the posts to the page.
 =wallet show page (ex: ethereum wallet) will be able to display index of transactions
 render transactions in backend in JSON format, then append to transactions page

 2. Must render at least one show page (show resource - 'one specific thing') via jQuery and an Active Model Serialization JSON Backend. For example, in the blog domain, you might allow a user to sift through the posts by clicking a 'Next' button on the posts show page, with the next post being fetched and rendered via JQuery/AJAX.
 =transactions index page will have ability to display an individual transaction show resource (if you click on 'i'
 you will be given the show view) (next, back to go through show views?)

 3. The rails API must reveal at least one `has-many` relationship in the JSON that is then rendered to the page. For example if each of those posts has many comments, you could render those comments as well on that show page.
 = building off of requirement 2, when on transactions index page and the 'i' is clicked, the show view of transaction will appear as well as NOTES the user may have entered about the transaction. (Transaction has many NOTES)

 4. Must use your Rails API and a form to create a resource and render the response without a page refresh. For example, a user might be able to add a comment to a post, and the comment would be serialized, and submitted via an AJAX POST request, with the response being the new object in JSON and then appending that new comment to the DOM using JavaScript (ES6 Template Literals can help out a lot with this).
 =On the transaction index page, the clicked "create a transaction" button will make appear a form (still on the transaction index page). When this form is submitted, a new transaction will appear (still on the transaction index page.)

 5. Must translate the JSON responses into Javascript Model Objects. The Model Objects must have at least one method on the prototype. Formatters work really well for this. Borrowing from the previous example, instead of plainly taking the JSON response of the newly created comment and appending it to the DOM, you would create a Comment prototype object and add a function to that prototype to perhaps concatenate (format) the comments authors first and last name. You would then use the object to append the comment information to the DOM.
=from requirement 5, the response is translated into a javascript model object... formatted..
So will have a transaction prototype object

Add transaction has many notes.  A note will have text, and it will have a date
## Instructions

1. Make the changes to your existing Rails assessment repo.
2. Add the spec-js.md file from this repo to the root directory of the project, commit it to Git and push it up to GitHub.
3. Submit that repo to the assessment immediately.
4. Build your app there. Make sure to commit early and commit often. Commit messages should be meaningful (clearly describe what you're doing in the commit) and accurate (there should be nothing in the commit that doesn't match the description in the commit message). Good rule of thumb is to commit every 3-7 mins of actual coding time. Most of your commits should have under 15 lines of code and a 2 line commit is perfectly acceptable. **This is important and you'll be graded on this**.
6. Record at least a 30 min coding session. During the session, either think out loud or not. It's up to you. You don't need to submit it, but we may ask for it at a later time.
7. Submit a video of how a user would interact with your working application.
8. Make sure to check each box in your spec.md (replace the space between the square braces with an x) and explain next to each one how you've met the requirement *before* you submit your project.
9. Submit the url to your github project
10. Write a blog post about the project and process.