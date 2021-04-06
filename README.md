# Quizz-App-IOS
Cette Application ios est un quizz qui nous permet de repondre a 10 questions aleatorement chargees d'une API distante et qui affiche un score actualise apres
la reponse a chaque question, pour repondre, l'utilisateur doit glisser son doigt a droite ou a gauche pour choisir si la proposition est vrai ou fausse.
et a travers les listeners du controlleur on detecte cette action et on effectue des animations et des transformations visuelles.

Cette Application respecte le design pattern MVC, et le bonnes pratique du developpement, la classe game par exemple elle propose le design pattern singleton en donnant acces a une instance unique partagee pour qu'on puisse la manipuler et acceder au dit "state" de l'application, d'autre part  on n'a pas de communication directe entre le modele et la vue, mais ctte communication passe a travers un controlleur via les notifications.

<img src="App-result-Images/Capture.PNG"  width="200" height="400">



En ca de glissement a droite:

<img src="App-result-Images/true.png" width="200" height="200">



En ca de glissement a gauche:

<img src="App-result-Images/false.png" width="200" height="200">


Mode paysant:

<img src="App-result-Images/mode paysant.PNG"  width="400" height="200">


iPad ecran d'acceuil:

<img src="App-result-Images/ipad launch screen (2).PNG"  width="400" height="600">


ipad ecran principal:

<img src="App-result-Images/ipadmainscreen.PNG"  width="400" height="600">

