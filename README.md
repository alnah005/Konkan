# Konkan

Konkan app

## Getting Started

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view [flutter documentation](https://flutter.dev/docs), which offers tutorials, samples, guidance on mobile development, and a full API reference.

# Konkan Rules:
>  This app implements "Regular" (عادي) Konkan, so if the rules don't seem familiar or different let us know. Also, these rules are subjectively based on how we know them, so let us know if there are rules that we got wrong/missed.

##### Table of Contents  
* [Requirements](#what-you-need-to-start-a-game)  
* [How to start](#how-to-start-the-game)  
* [OBJECTIVE](#objective-of-the-game)  
* [Set Cards](#how-to-set-your-cards)
    * [Score of your cards](#how-to-count-the-score-of-your-cards)
    * [Conditions to set your cards](#conditions-to-set-your-cards)
    * [Grouping your cards](#how-to-group-your-cards)
* [combining with other players](#how-to-combine-your-cards-with-other-players)
* [After you win](#what-happens-after-you-win)
    * [Penalizing each player](#how-to-calculate-penalty)

## What you need to start a game

* Two decks of cards and two jokers
    > Totalling 106 cards
* 2 - 4 players

## How to start the game

1) 1 player is chosen to be the first one to start
    > That players gets 15 cards
2) The remaining 1-3 players get 14 cards
3) The game goes either clockwise or anti-clockwise after the player chosen in (1.) plays his turn.
4) After giving all the players their cards:
    ```
    players cards =  14 * num_players + 1
    ```   
    you will have: 
    ```
    Bank cards =  106 - 14 * num_players + 1
    ```
    Cards left. 
5) The player whose turn is before the player from (1.) cuts the deck and if the first card he cut is a joker, he gets that joker.
    > This means he recieves 13 cards from the bank, which plus the joker will total to 14.
6) The remaining `Bank Cards` are kept on the field for the players to draw one card when its their turn.
    > Except the player in (1.) in his first turn since he starts with 15 cards. After his first turn, he draws one card from the deck on his turn too.
7) The bottom 1 - 3 cards from the `Bank Cards` are __BURNT__ cards and they are shown to all players.

## Objective of the game

 Main objective is to [SET](#how-to-set-your-cards) or [COMBINE](#how-to-combine-your-cards-with-other-players) 14 of your cards and discarding one card on your turn.   

## How to set your cards

1) First you need to know [how to count the score](#how-to-count-the-score-of-your-cards) of the cards you want to set
2) Your cards must have a score higher or equal to __52__, if no other player has set their cards, or the maximum score that other players set their cards at. Also, you must satisfy [some conditions](#conditions-to-set-your-cards) to be eligible to set your cards.
    ```
    Example:
    
    Let's say player one was able to collect a score of 60 and satisfied all the conditions
    to set their cards and no other player has set their cards. Since player one had
    a score > 52, he's able to set his cards.  
    Now, let's say player two wants to set their cards. His cards must score at least 60.  
    ```
3) The cards you set must be [correctly grouped](#how-to-group-your-cards)

### How to count the score of your cards

Here are the scores of each card:

|Card|Value|
|:---:|:---:|
|A|11|
|2|2|
|3|3|
|4|4|
|5|5|
|6|6|
|7|7|
|8|8|
|9|9|
|10|10|
|J|10|
|Q|10|
|K|10|
|Joker|Score of card that the Joker is replacing

Your score when you set your cards is simply the sum of your cards' values.

### Conditions to set your cards

1) It must be your turn
2) You must take the card that the player right before you discarded and use it in the cards you're setting.
    > In other words, you must utilize the card that was most recently discarded by your opponent towards the cards you're setting.

    If you instead drew a card from the `Bank cards` and that card happened to be the one that was missing in your cards (the card that would make you win), you are allowed to set your cards (without having to draw from the discarded cards).  
    ~~If you aren't able to [SET](#how-to-set-your-cards) or [COMBINE](#how-to-combine-your-cards-with-other-players) 14 cards and discard one card (which would make you win the game), you are penalized 50 on your [total game score](#how-to-calculate-penalty).~~
3) If you have set your cards for the first time, during your turn, you are allowed to set any group you have collected since setting your cards for the first time.

### How to group your cards

Here's a list of all possible groups:  

> The prefix of each card means a suit.  
    D &rarr; Diamond  
    C &rarr; clubs  
    H &rarr; hearts  
    S &rarr; Spades

|Group|Note|
|:---|:---:|
|HA &rarr; H2 &rarr; H3 &rarr; H4 &rarr; H5 &rarr; H6 &rarr; H7 &rarr; H8 &rarr; H9 &rarr; H10 &rarr; HJ &rarr; HQ &rarr; HK &rarr; HA| You can't have a HK &rarr; HA &rarr; H2 group|
|DA &rarr; D2 &rarr; D3 &rarr; D4 &rarr; D5 &rarr; D6 &rarr; D7 &rarr; D8 &rarr; D9 &rarr; D10 &rarr; DJ &rarr; DQ &rarr; DK &rarr; DA| You can't have a DK &rarr; DA &rarr; D2 group|
|SA &rarr; S2 &rarr; S3 &rarr; S4 &rarr; S5 &rarr; S6 &rarr; S7 &rarr; S8 &rarr; S9 &rarr; S10 &rarr; SJ &rarr; SQ &rarr; SK &rarr; SA| You can't have a SK &rarr; SA &rarr; S2 group|
|CA &rarr; C2 &rarr; C3 &rarr; C4 &rarr; C5 &rarr; C6 &rarr; C7 &rarr; C8 &rarr; C9 &rarr; C10 &rarr; CJ &rarr; CQ &rarr; CK &rarr; CA| You can't have a CK &rarr; CA &rarr; C2 group|
|3-4 of the same card (e.g. A, 3, Q...etc) but different suit (e.g. C,D,H,S)||

***The Joker can replace any card***

***Each of your groups must consist of at least 3 cards.***
    
```
Example:

This is a perfectly valid grouping:

        1               2                3
    DA SA CA        HA H2 H3        H9 Joker HJ
1. 11 + 11 + 11 = 33
2. 11 + 2 + 3 = 16
3. 9 + 10 + 10 = 29

This grouping will total a score of 33 + 16 + 29 = 78. 
If a player had a score of 79 when they set their cards, this grouping won't be enough to set your cards.
```


## How to combine your cards with other players

1) It must be your turn
2) You must have your cards set or you're in your winning turn that was mentioned in [2.](#conditions-to-set-your-cards)
3) The Card/s that you are combining must complete one of your opponents groups
```
Example:

Let's say one of your oppenents has:  
        1               2                3
    DA SA CA        HA H2 H3        H8 H9 Joker HJ

and you have these cards in your hand:
    HA, H4, H7, HQ, HK...etc

Then if you satisfy conditions 1. and 2. and you wanted to combine all your available cards,
here's how your opponent's groups will look like in the game:
         1                  2                       3
    DA SA CA HA        HA H2 H3 H4       H7 H8 H9 Joker HJ HQ HK

combining only benefits you because you lose some cards that could penalize you after
the game is done if you didn't win the game, and it removes the opportunity for other
players to combine their cards.  
combining does not increase the score for setting cards.

In the case where you had a H10, you can replace the Joker, and obtain the Joker to use it
for other purposes.
```

## What happens after you win

After you've [SET](#how-to-set-your-cards) or [COMBINED](#how-to-combine-your-cards-to-other-players) 14 of your cards and discarded one card on your turn (You won), here's what happens:
* ~~If the discarded card is a Joker, all your opponents recieve 200 penalty on their overall score.~~
* If not:
    * players that have not set their cards recieve 100 penalty on their overall score.
    * players that have set their cards are [penalized over the remaining cards in their hand](#how-to-calculate-penalty)
* If a player has a penalty of over 301 across games, that player is disqualified to play again.

### How to calculate penalty
|Card|Penalty|
|:---:|:---:|
|A|11|
|2|2|
|3|3|
|4|4|
|5|5|
|6|6|
|7|7|
|8|8|
|9|9|
|10|10|
|J|10|
|Q|10|
|K|10|
|Joker|50|

# _Congratulations! Now you are able to play the game!_

