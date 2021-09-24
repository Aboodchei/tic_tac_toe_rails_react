# Tic Tac Toe ⚔️🛡- Rails - React - Action Cable
This was a fun project, I enjoyed it!
It took me ~5 days to complete.

I've also deployed it on Heroku! [Check it out here!](http://intense-temple-28283.herokuapp.com/)

The first part I thought about was how I was going to tackle this. I wanted to opt for something that was:
- User friendly and fun.
- Rather simple, and would not require a long time to implement, due to the time limitation.

I wanted to treat this project as I do my startup work. Get an MVP that works, and that meets requirements as quickly as possible, with as little technical debt as possible.

It's been a long time (3 years!) since I've last developed using React, so it was super exciting to get back to it. I'm also a more back-end focused full-stack developer, so it was definitely challenging!

##### Functionality
- Games can be played by both registered and unregistered (anonymous) users.
- Users can invite one another for an online game via an invitation link.
- Users have the ability to request a rematch after a game is over.
- Users can view one anothers' list of lifetime scores.
- Games can be spectated.

##### Setup
There should be nothing out of the ordinary.
`$ bundle install` to install Ruby dependencies
`$ yarn` to install Javascript and Frontend dependencies
`$ rails db:setup` to setup database (Postgresql)
`$ rails s` to run the server
`$ rspec` to run the back-end tests

##### React Components
There are 6 React components. I opted for functional components, and tried to kept the use of states to a minimum. `GameContainer` is the only component that uses state.
```
├── InvitationListener
├── GameContainer
│   ├── GameHeader
│   ├── Game
│   ├── RematchCallToActions
│   ├── RematchStatus
```

##### Back-end

The main game data request takes this shape:
```
{
   "slug":"f8SAy35c",
   "moves":{
      "1":["playable",null],
      "2":["played","X"],
      ..........\\ all the way to 9
      ..........\\ moves can either be 'playable', 'played', or 'winning'
   },
   "result":"not_applicable", \\ result can either be 'not_applicable', 'player_one_win', 'player_two_win', or 'draw' 
   "status":"in_progress", \\ status can either be 'invitation_pending', 'in_progress', or 'completed'
   "rematchStatus":"none", \\ rematchStatus can either be 'none', 'requested',  'accepted', or 'declined'
   "rematchSlug":null, \\ contains the slug for the created rematch game
   "rematchRequesterId":null \\ contains the id of the player who requested the rematch
   "winningCombination":[], \\ cached value  of the winning combination, one of Game::WINNING_COMBINATIONS
   "playerOne":{
      "id":2,
      "displayName":"Anonymous",
      "guest":true
   },
   "playerTwo":{
      "id":5,
      "displayName":"Anonymous",
      "guest":true
   },
   "playerWithTurn":{
      "id":2,
      "displayName":"Anonymous"
   },
}
```

##### Hope you like it!

##### Best,
##### Abdulla Mahmoud